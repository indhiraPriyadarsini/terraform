resource "aws_s3_bucket" "s3-bucket" {
  bucket  = "${var.prefix}s3-bucket"
  tags    = {
	Name          = "${var.prefix}s3-bucket"
	Environment    = "${var.environment}"
  }
}