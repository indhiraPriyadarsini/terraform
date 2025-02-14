module "vpc" {
  source              = "./modules/networking"
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidr_1  = "10.0.5.0/24"
  public_subnet_cidr_2  = "10.0.6.0/24"
  private_subnet_cidr_1 = "10.0.7.0/24"
  private_subnet_cidr_2 = "10.0.8.0/24"
  prefix              = "training"
}

resource "aws_security_group" "ec2_sg" {
  vpc_id = module.vpc.vpc_id
  ingress {
    from_port = "22"
    to_port = "22"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = "80"
    to_port = "80"
    protocol = "tcp"
    cidr_blocks =  ["0.0.0.0/0"]
  }
  egress {
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "ec2" {
  vpc_id         = module.vpc.vpc_id
  source         = "./modules/ec2"
  instance_count = 1
  instance_type  = "t2.micro"
  instance_name  = "ipd-instance"
  subnet_id      = module.vpc.public_subnet_1_id
  key_name       = "new-key"
  tags = {
    Environment = "training"
  }
  security_group_ids = [aws_security_group.ec2_sg.id]
  private_key_path = "/Users/presidio/new-key.pem"
}

module "rds" {
  source = "./modules/rds"
  vpc_id = module.vpc.vpc_id
  db_name = "mysqldb"
  db_engine = "mysql"
  db_engine_version = "5.7"
  db_instance_class = "db.t3.micro"
  db_username = "master"
  db_password = ""
  db_parameter_group_name = "default.mysql5.7"
  prefix = "training"
  private_subnet_cidr_1 = module.vpc.private_subnet_1_id
  private_subnet_cidr_2 = module.vpc.private_subnet_2_id
  public_subnet_cidr_1 = module.vpc.public_subnet_1_id
  public_subnet_cidr_2 = module.vpc.public_subnet_2_id
  ec2_sg_id = aws_security_group.ec2_sg.id
  
}