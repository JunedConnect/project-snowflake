output "snowflake-aws-iam-user-arn" {
  value = snowflake_storage_integration.this.storage_aws_iam_user_arn
}

output "snowflake-aws-account-id" {
  value = regex("arn:aws:iam::(\\d+):user/.+", snowflake_storage_integration.this.storage_aws_iam_user_arn)[0]
}