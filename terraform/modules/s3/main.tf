resource "aws_s3_bucket" "data" {
  bucket = var.s3-data-bucket-name
}

resource "aws_s3_bucket" "backup" {
  bucket = var.s3-backup-bucket-name
}

resource "aws_s3_bucket" "audit" {
  bucket = var.s3-audit-bucket-name
}

resource "aws_s3_bucket_server_side_encryption_configuration" "data" {
  bucket = aws_s3_bucket.data.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.bucket-sse-algorithm
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "backup" {
  bucket = aws_s3_bucket.backup.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.bucket-sse-algorithm
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "audit" {
  bucket = aws_s3_bucket.audit.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.bucket-sse-algorithm
    }
  }
}

resource "aws_s3_bucket_versioning" "data" {
  bucket = aws_s3_bucket.data.id
  versioning_configuration {
    status = var.bucket-versioning
  }
}

resource "aws_s3_bucket_versioning" "backup" {
  bucket = aws_s3_bucket.backup.id
  versioning_configuration {
    status = var.bucket-versioning
  }
}

resource "aws_s3_bucket_versioning" "audit" {
  bucket = aws_s3_bucket.audit.id
  versioning_configuration {
    status = var.bucket-versioning
  }
}

resource "aws_s3_bucket_public_access_block" "data" {
  bucket = aws_s3_bucket.data.id

  block_public_acls       = var.bucket-block-public-acls
  block_public_policy     = var.bucket-block-public-policy
  ignore_public_acls      = var.bucket-ignore-public-acls
  restrict_public_buckets = var.restrict-public-buckets
}

resource "aws_s3_bucket_public_access_block" "backup" {
  bucket = aws_s3_bucket.backup.id

  block_public_acls       = var.bucket-block-public-acls
  block_public_policy     = var.bucket-block-public-policy
  ignore_public_acls      = var.bucket-ignore-public-acls
  restrict_public_buckets = var.restrict-public-buckets
}

resource "aws_s3_bucket_public_access_block" "audit" {
  bucket = aws_s3_bucket.audit.id

  block_public_acls       = var.bucket-block-public-acls
  block_public_policy     = var.bucket-block-public-policy
  ignore_public_acls      = var.bucket-ignore-public-acls
  restrict_public_buckets = var.restrict-public-buckets
}

resource "aws_s3_bucket_replication_configuration" "data" {
  role   = var.s3-replication-role-arn
  bucket = aws_s3_bucket.data.id

  rule {
    status = var.bucket-replication-rule

    destination {
      bucket        = aws_s3_bucket.backup.arn
      storage_class = var.bucket-replication-storage-class
    }
  }

  depends_on = [aws_s3_bucket_versioning.data, aws_s3_bucket_versioning.backup]
}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket_policy" "s3-logging" {
  bucket = aws_s3_bucket.audit.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "S3ServerAccessLogsPolicy"
        Effect = "Allow"
        Principal = {
          Service = "logging.s3.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.audit.arn}/*"
        Condition = {
          ArnLike = {
            "aws:SourceArn" = aws_s3_bucket.data.arn
          }
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      },
      {
        Sid    = "InventoryAndAnalyticsPolicy"
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.audit.arn}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl"      = "bucket-owner-full-control"
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
          ArnLike = {
            "aws:SourceArn" = aws_s3_bucket.data.arn
          }
        }
      }
    ]
  })
}

resource "aws_s3_bucket_logging" "data" {
  bucket = aws_s3_bucket.data.id

  target_bucket = aws_s3_bucket.audit.id
  target_prefix = var.bucket-logging-destination
}

resource "aws_s3_bucket_inventory" "data" {
  bucket = aws_s3_bucket.data.id
  name   = var.bucket-inventory-configuration-name

  included_object_versions = var.bucket-inventory-configuration-object-version

  schedule {
    frequency = var.bucket-inventory-configuration-frequency
  }

  destination {
    bucket {
      format     = var.bucket-inventory-configuration-output-format
      bucket_arn = aws_s3_bucket.audit.arn
      prefix     = var.bucket-inventory-configuration-destination
    }
  }
}