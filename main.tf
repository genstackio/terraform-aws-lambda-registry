resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
  acl    = "private"
  dynamic "versioning" {
    for_each = local.is_replicated ? {x = true} : {}
    content {
      enabled = true
    }
  }
  dynamic "replication_configuration" {
    for_each = local.is_replicated ? {x: true} : {}
    content {
      dynamic "rules" {
        for_each = toset(var.replications)
        content {
          role = aws_iam_role.replication[0].arn
          id     = "all"
          status = "Enabled"
          destination {
            bucket        = rules.value
            storage_class = "STANDARD"
          }
        }
      }
    }
  }
}

resource "aws_iam_role" "replication" {
  count              = local.is_replicated ? 1 : 0
  name_prefix        = "tf-iam-role-replication-"
  assume_role_policy = data.aws_iam_policy_document.s3_replication_assume_role_policy[0].json
}

resource "aws_iam_policy" "replication" {
  count       = local.is_replicated ? 1 : 0
  name_prefix = "tf-iam-role-policy-replication-"
  policy      = data.aws_iam_policy_document.s3_replication_policy[0].json
}

resource "aws_iam_role_policy_attachment" "replication" {
  count      = local.is_replicated ? 1 : 0
  role       = aws_iam_role.replication[0].name
  policy_arn = aws_iam_policy.replication[0].arn
}