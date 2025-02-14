locals {
  common_tags = {
    createdBy   = "indhirap@presidio.com"
    Project = "Terraform Learning"
  }
}
  resource "aws_db_subnet_group" "rds-subnet-group" {
  name       = "${var.prefix}rds-subnet-group"
  subnet_ids = [var.private_subnet_cidr_1, var.private_subnet_cidr_2]
  tags = local.common_tags
}
resource "aws_db_instance" "mysql_db" {
  allocated_storage    = 10
  db_name              = var.db_name
  engine               = var.db_engine
  engine_version       = var.db_engine_version
  instance_class       = var.db_instance_class
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = var.db_parameter_group_name
  skip_final_snapshot  = true
  publicly_accessible = false
  db_subnet_group_name = aws_db_subnet_group.rds-subnet-group.id
  vpc_security_group_ids = [aws_security_group.rds-sg.id]

}
resource "aws_security_group" "rds-sg" {
  name = "ipd-rds-sg"
  vpc_id = "${var.vpc_id}"
  ingress {      
    to_port = 3306
    from_port = 3306
    protocol = "tcp"
    security_groups = ["${var.ec2_sg_id}"]
  }
  egress {
     from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}