resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name        = "${var.prefix}-vpc"
    Environment = "training"
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidr_1
  map_public_ip_on_launch = true
  availability_zone = var.availability_zone_east_1a
  tags = {
    Name        = "${var.prefix}-public-subnet-1"
    Environment = "training"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidr_2
  availability_zone = var.availability_zone_east_1b
  tags = {
    Name        = "${var.prefix}-public-subnet-2"
    Environment = "training"
  }
}
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr_1
  availability_zone = var.availability_zone_east_1a

  tags = {
    Name        = "${var.prefix}-private-subnet-1"
    Environment = "training"
  }
}
resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr_2
  availability_zone = var.availability_zone_east_1b

  tags = {
    Name        = "${var.prefix}-private-subnet-2"
    Environment = "training"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
   tags = {
    Name = "${var.prefix}igw"
  }  
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id
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
  subnet_id = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "ipd-subnet-association-2" {
  subnet_id = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.rt.id
}