terraform {
  backend "s3" {  
    bucket = "ipd-s3-state-bucket"
    key    = "day-4-terraform-state"
    region = "us-east-1"
    dynamodb_table = "ipd-dynamo-state-backend"
    encrypt = true
  }
}
provider "aws" {
  region = "us-east-1"
  profile = "default"

}