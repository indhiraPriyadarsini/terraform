terraform {
  backend "s3" {
    bucket = "ipd-s3-state-bucket"
    key    = "terraform-state"
    region = "us-east-1"
    dynamodb_table = "ipd-dynamo-state-backend"
    encrypt = true
  }
}

provider "aws" {
    region = var.aws_region
    profile = "default"
}