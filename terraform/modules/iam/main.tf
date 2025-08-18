resource "aws_iam_role" "snowflake" {
  name = var.snowflake-role-name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          AWS = [var.snowflake-aws-account-id]
        }
        Condition = {
          StringEquals = {
            "sts:ExternalId" = var.snowflake-external-id
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "s3-snowflake" {

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:DeleteObject",
          "s3:DeleteObjectVersion"
        ],
        Resource = "arn:aws:s3:::${var.s3-data-bucket-name}/*"
      },
      {
        Effect = "Allow",
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ],
        Resource = "arn:aws:s3:::${var.s3-data-bucket-name}"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3-snowflake" {
  role       = aws_iam_role.snowflake.name
  policy_arn = aws_iam_policy.s3-snowflake.arn
}

resource "aws_iam_role" "s3-replication" {
  name = var.s3-replication-role-name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "s3.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "s3-replicate" {

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetReplicationConfiguration",
          "s3:GetObjectVersionForReplication",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionTagging",
          "s3:GetObjectRetention",
          "s3:GetObjectLegalHold"
        ]
        Resource = [
          "arn:aws:s3:::${var.s3-data-bucket-name}",
          "arn:aws:s3:::${var.s3-data-bucket-name}/*",
          "arn:aws:s3:::${var.s3-backup-bucket-name}",
          "arn:aws:s3:::${var.s3-backup-bucket-name}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags",
          "s3:ObjectOwnerOverrideToBucketOwner"
        ]
        Resource = [
          "arn:aws:s3:::${var.s3-data-bucket-name}/*",
          "arn:aws:s3:::${var.s3-backup-bucket-name}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3-replicate" {
  role       = aws_iam_role.s3-replication.name
  policy_arn = aws_iam_policy.s3-replicate.arn
}