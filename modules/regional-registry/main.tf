resource "aws_s3_bucket" "bucket" {
  bucket = local.bucket_name
  acl    = "private"
  versioning {
    enabled = true
  }
}