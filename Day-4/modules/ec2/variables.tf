
variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}
variable "instance_name" {
  description = "Name of the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID for the instance (leave empty to use the latest Amazon Linux)"
  type        = string
  default     = ""
}

variable "instance_count" {
  description = "Number of instances to launch"
  type        = number
  default     = 1
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
}

variable "subnet_id" {
  description = "Subnet ID where the instance should be launched"
  type        = string
}

variable "tags" {
  description = "Additional tags for the EC2 instance"
  type        = map(string)
  default     = {}
}

variable "private_key_path" {
  description = "Path to the private key file"
  type        = string
  
}