#the below is there if you require the AWS Swowflake account details to be outputted on the CLI when you run Terraform

output "snowflake-iam-user-arn" {
  value = module.snowflake.snowflake-aws-iam-user-arn
}

output "snowflake-aws-account-id" {
  value = module.snowflake.snowflake-aws-account-id
}