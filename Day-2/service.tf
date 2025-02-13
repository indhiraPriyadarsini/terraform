
resource "aws_security_group" "alb-sg" {
  vpc_id = aws_vpc.vpc.id
  name   = "${var.prefix}alb-sg"

  ingress {
    from_port = "80"
    to_port = "80"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
}
resource "aws_security_group" "asg-sg" {
  vpc_id = aws_vpc.vpc.id
  ingress {
    from_port = "22"
    to_port = "22"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = "80"
    to_port = "80"
    protocol = "tcp"
    security_groups = [ aws_security_group.alb-sg.id ]
  }
  egress {
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_autoscaling_group" "auto-scaling-group" {
  name = "${var.prefix}auto-scaling-group"
  min_size = 1
  max_size = 3
  health_check_grace_period = var.health_check_grace_period
  health_check_type         = var.health_check_type 
  desired_capacity          = 2
  force_delete              = true
  vpc_zone_identifier = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id]
  target_group_arns = [aws_lb_target_group.target-group.arn]

  launch_template {
    id      = aws_launch_template.launch-template.id
    version = aws_launch_template.launch-template.latest_version
  }
}

resource "aws_launch_template" "launch-template" {
  name_prefix   = "${var.prefix}launch-template"
  image_id      = var.ami_id
  instance_type = var.instance_class
  key_name      = var.ec2-key
  vpc_security_group_ids = [aws_security_group.asg-sg.id]
   user_data = base64encode(<<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y httpd
    sudo systemctl start httpd
    sudo systemctl enable httpd
    echo "Hello from $(hostname)" > /var/www/html/index.html
  EOF
  )
}

resource "aws_lb" "alb" {
  name               = "${var.prefix}alb"
  internal           = false
  load_balancer_type = var.load_balancer_type
  security_groups    = [aws_security_group.alb-sg.id] 
  subnets            = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id]
  enable_deletion_protection = true

}

resource "aws_lb_target_group" "target-group" {
  name     = "target-group"
  port     = 80
  target_type = "instance"
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
  
}
resource "aws_lb_listener" "http-listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group.arn
  }
}

resource "aws_autoscaling_policy" "scale_out_policy" {
  name                   = "scale_out_policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.auto-scaling-group.name
}

resource "aws_autoscaling_policy" "scale_in_policy" {
  name                   = "scale_in_policy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.auto-scaling-group.name
}
resource "aws_cloudwatch_metric_alarm" "scale_out_alarm" {
  alarm_name          = "scale_out_alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "${var.metric_name}"
  namespace           = "${var.namespace}"
  period              = "${var.period}"
  statistic           = "${var.statistic}"
  threshold           = 75

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.auto-scaling-group.name
  }

  alarm_description = "Alarm when CPU utilization exceeds 75%"
  alarm_actions = [aws_autoscaling_policy.scale_out_policy.arn]

}

resource "aws_cloudwatch_metric_alarm" "scale_in_alarm" {
  alarm_name          = "scale_in_alarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "${var.metric_name}"
  namespace           = "${var.namespace}"
  period              = "${var.period}"
  statistic           = "${var.statistic}"
  threshold           = 25

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.auto-scaling-group.name
  }

  alarm_description = "Alarm when CPU utilization drops below 25%"
  alarm_actions = [aws_autoscaling_policy.scale_in_policy.arn]
}