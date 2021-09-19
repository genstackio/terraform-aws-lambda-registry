data "aws_iam_policy_document" "s3_replication_assume_role_policy" {
  count = local.is_replicated ? 1 : 0
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
  }
}
data "aws_iam_policy_document" "s3_replication_policy" {
  count = local.is_replicated ? 1 : 0
  statement {
    actions = [
      "s3:GetReplicationConfiguration",
      "s3:ListBucket"
    ]
    resources = [
      aws_s3_bucket.bucket.arn
    ]
    effect = "Allow"
  }
  statement {
    actions = [
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging"
    ]
    resources = [
      "${aws_s3_bucket.bucket.arn}/*"
    ]
    effect = "Allow"
  }
  statement {
    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
      "s3:ReplicateTags"
    ]
    resources = [for r in var.replications: "${r}/*"]
    effect = "Allow"
  }
}