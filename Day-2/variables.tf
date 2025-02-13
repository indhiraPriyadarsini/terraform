variable "aws_region" {
  type    = string
  default = "us-east-1"

}
variable "availability_zone_east_1a" {
  type    = string
  default = "us-east-1a"    
  
}
variable "availability_zone_east_1b" {
  type    = string
  default = "us-east-1b"        
}
variable "environment" {
  type    = string
  default = "test"
}
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
  
}
variable "public_subnet_cidr_1" {
  type    = string
  default = "10.0.1.0/24"
  
}
variable "public_subnet_cidr_2" {
  type    = string
  default = "10.0.2.0/24"
  
}
variable "private_subnet_cidr_1" {
  type    = string
  default = "10.0.3.0/24"
  
}
variable "private_subnet_cidr_2" {
  type    = string
  default = "10.0.4.0/24"
  
}
variable "s3_state_backend_bucket" {
  type    = string
  default = "ipd-s3-state-bucket"
}
variable "min-size" {
  default = 1
}
variable "max-size" {
  default = 3
}
variable "default-size" {
  default = 2
}
variable "ec2-key" {
  type    = string
  default = "ipd-terraform-key"
}
variable "instance_class" {
  type    = string
  default = "t2.micro"
}
variable "ami_id" {
  type    = string
  default = "ami-01e3c4a339a264cc9"
}
variable "health_check_type" {
    type = string
    default = "ELB"
}
variable "health_check_grace_period" {
    type = string
    default = "300"
}
variable "load_balancer_type" {
     type = string
    default = "application"
  
}
variable "db_name" {
    type = string
    default = "mydb"
}
variable "db_engine" {
    type = string
    default = "mysql"
}
variable "db_engine_version" {
    type = string
    default = "8.0"
}
variable "db_instance_class" {
    type = string
    default = "db.t3.micro"
}
variable "db_username" {
    type = string
    default = ""
}
variable "db_password" {
    type = string
    default = ""
}
variable "db_parameter_group_name" {
    type = string
    default = "default.mysql8.0"
}
variable "adjustment_type" {
    type = string
    default = "ChangeInCapacity"
  
}
variable "prefix" {
    type = string
    default = "ipd-terraform-"
}
variable "metric_name" {
    type = string
    default = "CPUUtilization"  
  
}
variable "namespace" {
    type = string
    default = "AWS/EC2"
  
}
variable "statistic" {
    type = string
    default = "Average" 
  
}
variable "period" {
    type = string
    default = "120"
  
}
