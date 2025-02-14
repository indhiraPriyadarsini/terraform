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
variable "vpc_id" {
  type    = string
  description = "ID of the VPC"
  
}
variable "public_subnet_cidr_1" {
  type    = string
  default = ""
  
}
variable "public_subnet_cidr_2" {
  type    = string
  default = ""
  
}
variable "private_subnet_cidr_1" {
  type    = string
  default = ""
  
}
variable "private_subnet_cidr_2" {
  type    = string
  default = ""
  
}
variable "ami_id" {
  type    = string
  default = "ami-01e3c4a339a264cc9"
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
variable "prefix" {
    type = string
    default = "ipd-terraform-"
}
variable "ec2_sg_id" {
    type = string
    default = ""
  
}
