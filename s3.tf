resource "aws_s3_bucket" "ipd-terraform-s3-bucket" {
  bucket  = "ipd-terraform-s3-bucket"
  tags    = {
	Name          = "ipd-terraform-s3-bucket"
	Environment    = "Production"
  }
}