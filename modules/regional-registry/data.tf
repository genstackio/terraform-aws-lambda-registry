data "aws_region" "current" {}

data "aws_s3_bucket" "master_bucket" {
  bucket = var.master_bucket_name
}