#the below is there if you require the AWS Swowflake accout details to be outputted on the CLI when you run Terraform

output "snowflake_storage_iam_user_arn" {
  value = module.snowflake.storage_aws_iam_user_arn
}

output "snowflake_storage_aws_account_id" {
  value = module.snowflake.storage_aws_account_id
}