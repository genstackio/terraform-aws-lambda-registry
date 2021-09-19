locals {
  bucket_name = (null == var.bucket_name) ? "${var.master_bucket_name}-${data.aws_region.current.name}" : var.bucket_name
}