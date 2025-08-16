output "storage_aws_iam_user_arn" {
  value = snowflake_storage_integration.this.storage_aws_iam_user_arn
}

output "storage_aws_account_id" {
  value = regex("arn:aws:iam::(\\d+):user/.+", snowflake_storage_integration.this.storage_aws_iam_user_arn)[0]
}