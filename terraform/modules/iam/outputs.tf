output "snowflake-role-arn" {
  value = aws_iam_role.snowflake.arn
}

output "s3-replication-role-arn" {
  value = aws_iam_role.s3-replication.arn
}