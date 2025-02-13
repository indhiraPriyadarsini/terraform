variable "prefix" {
    type = string
    default = "ipd-terraform-"
  
}
variable "environment" {
    type = string
    default = "test"
  
}
variable "aws_region" {
    type = string
    default = "us-east-1"
  
}
variable "availability_zone" {
    type = string
    default = "us-east-1a" 
  
}
variable "instance_type" {
    type = string
    default = "t2.micro"
  
}
variable "ami_id" {
    type = string
    default = "ami-00c39f71452c08778"
  
}