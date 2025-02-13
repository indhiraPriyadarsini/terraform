
resource "aws_vpc" "vpc" {
  cidr_block = "${var.vpc_cidr}"
}
resource "aws_subnet" "public-subnet-1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block              = "${var.public_subnet_cidr_1}"
  availability_zone       = "${var.availability_zone_east_1a}"
  map_public_ip_on_launch = true
}
resource "aws_subnet" "public-subnet-2" {
  vpc_id = aws_vpc.vpc.id
  cidr_block              = "${var.public_subnet_cidr_2}"
  availability_zone       = "${var.availability_zone_east_1b}"
  map_public_ip_on_launch = true
}
resource "aws_subnet" "private-subnet-1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block              = "${var.private_subnet_cidr_1}"
  availability_zone       = "${var.availability_zone_east_1a}"
  map_public_ip_on_launch = false
}
resource "aws_subnet" "private-subnet-2" {
  vpc_id = aws_vpc.vpc.id
  cidr_block              = "${var.private_subnet_cidr_2}"
  availability_zone       = "${var.availability_zone_east_1b}"
  map_public_ip_on_launch = false
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
   tags = {
    Name = "${var.prefix}igw"
  }  
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc.id
   tags = {
    Name = "${var.prefix}public-rt"
  }
}
resource "aws_route" "public-route" {
  route_table_id = aws_route_table.rt.id
  gateway_id = aws_internet_gateway.igw.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "ipd-subnet-association-1" {
  subnet_id = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "ipd-subnet-association-2" {
  subnet_id = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.rt.id
}