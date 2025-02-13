locals {
  common_tags = {
    createdBy   = "indhirap@presidio.com"
    Project = "Terraform Learning"
  }
}
  resource "aws_db_subnet_group" "rds-subnet-group" {
  name       = "${var.prefix}rds-subnet-group"
  subnet_ids = [aws_subnet.private-subnet-1.id, aws_subnet.private-subnet-2.id]
  tags = local.common_tags
}
resource "aws_db_instance" "mysql-db" {
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
//variables prefix data sources locals state backend - s3 dynamo
resource "aws_security_group" "rds-sg" {
  name = "ipd-rds-sg"
  vpc_id = aws_vpc.vpc.id
  ingress {      
    to_port = 3306
    from_port = 3306
    protocol = "tcp"
    security_groups = [aws_security_group.asg-sg.id]
  }
  egress {
     from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}