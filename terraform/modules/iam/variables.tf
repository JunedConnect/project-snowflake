variable "snowflake-role-name" {
  description = "name of snowflake role"
  type        = string
}

variable "snowflake-external-id" {
  description = "external-id of snowflake integration"
  type        = string
}

variable "s3-replication-role-name" {
  description = "Name of S3 replication role"
  type        = string
  default     = "s3-replication-role"
}

variable "s3-data-bucket-name" {
  description = "Name of S3 Data Bucket"
  type        = string
}

variable "s3-backup-bucket-name" {
  description = "Name of S3 Backup Bucket"
  type        = string
}

variable "s3-audit-bucket-name" {
  description = "Name of S3 Audit Bucket"
  type        = string
}