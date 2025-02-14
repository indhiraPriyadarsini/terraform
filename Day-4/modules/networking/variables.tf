variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr_1" {
  description = "CIDR block for the public subnet"
  type        = string
}

variable "public_subnet_cidr_2" {
  description = "CIDR block for the private subnet"
  type        = string
}
variable "private_subnet_cidr_1" {
  description = "CIDR block for the private subnet 1"
  type        = string
  
}

variable "private_subnet_cidr_2" {
  description = "CIDR block for the private subnet 1"
  type        = string
}

variable "availability_zone_east_1a" {
  type    = string
  default = "us-east-1a"    
  
}
variable "availability_zone_east_1b" {
  type    = string
  default = "us-east-1b"        
}
variable "prefix" {
  description = "Prefix for resource names"
  type        = string
}

