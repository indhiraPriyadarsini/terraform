provider "aws" {
    region = "us-east-1"
    profile = "default"
}
resource "aws_vpc" "ipd-terraform-vpc" {
  cidr_block = "10.0.0.0/16"
}
resource "aws_subnet" "ipd-terraform-public-subnet" {
  vpc_id = aws_vpc.ipd-terraform-vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}
resource "aws_security_group" "ipd-terraform-ec2-sg" {
  vpc_id = aws_vpc.ipd-terraform-vpc.id
  ingress {
    from_port = "22"
    to_port = "22"
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

resource "aws_instance" "ipd-terraform-ec2-instance" {
  subnet_id = aws_subnet.ipd-terraform-public-subnet.id
  security_groups = [aws_security_group.ipd-terraform-ec2-sg.id]
  ami = "ami-00c39f71452c08778"
  instance_type = "t3.micro"
  tags = {
    Name = "ipd-terraform-ec2-instance"
  }
}

