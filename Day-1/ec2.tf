

//variables prefix data sources locals state backend - s3 dynamo
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
}
resource "aws_subnet" "public" {
  vpc_id = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.availability_zone}"
  map_public_ip_on_launch = true
}
resource "aws_security_group" "ec2-sg" {
  vpc_id = aws_vpc.vpc.id
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

resource "aws_instance" "ec2-instance" {
  subnet_id = aws_subnet.public.id
  security_groups = [aws_security_group.ec2-sg.id]
  ami = "${var.ami_id}"
  instance_type = "${var.instance_type}"
  tags = {
    Name = "${var.prefix}ec2-instance"
  }
}

