#provider variables below
variable "aws-tags" {
  type = map(string)
}

variable "snowflake-organization-name" {
  type = string
}

variable "snowflake-account-name" {
  type = string
}

variable "snowflake-user" {
  type = string
}

variable "snowflake-password" {
  type      = string
  sensitive = true
}

variable "snowflake-role" {
  type = string
}



#module variables below


#iam

variable "snowflake-role-name" {
  description = "name of snowflake role"
  type        = string
  default     = "snowflake-role"
}

variable "s3-replication-role-name" {
  description = "Name of S3 replication role"
  type        = string
  default     = "s3-replication-role"
}

#snowflake

variable "snowflake-aws-account-id" {
  description = "aws account-id of snowflake account"
  type        = string
}

variable "snowflake-external-id" {
  description = "external-id of snowflake integration"
  type        = string
  sensitive   = true
}

variable "snowflake-warehouse-name" {
  description = "Name of Snowflake Warehouse"
  type        = string
  default     = "my-warehouse"
}

variable "snowflake-warehouse-size" {
  description = "Size of Snowflake Warehouse"
  type        = string
  default     = "XSMALL"
}

variable "snowflake-database-name" {
  description = "Name of Snowflake Database"
  type        = string
  default     = "my-database"
}

variable "snowflake-schema-name" {
  description = "Name of Snowflake Schema"
  type        = string
  default     = "my-schema"
}

variable "snowflake-sequence-name" {
  description = "Name of Snowflake Sequence"
  type        = string
  default     = "my-schema"
}

variable "snowflake-table-name" {
  description = "Name of Snowflake Table"
  type        = string
  default     = "my-table"
}

variable "snowflake-storage-integration-name" {
  description = "Name of Snowflake Storage Integration"
  type        = string
  default     = "my-storage-integration"
}

variable "snowflake-stage-name" {
  description = "Name of Snowflake Stage"
  type        = string
  default     = "my-stage"
}

variable "snowflake-storage-provider" {
  description = "Name of Snowflake Storage Provider"
  type        = string
  default     = "S3"
}



#s3

variable "s3-data-bucket-name" {
  description = "Name of S3 Data Bucket"
  type        = string
  default     = "project-snowflake-data-main"
}

variable "s3-backup-bucket-name" {
  description = "Name of S3 Backup Bucket"
  type        = string
  default     = "project-snowflake-data-backup"
}

variable "s3-audit-bucket-name" {
  description = "Name of S3 Audit Bucket"
  type        = string
  default     = "project-snowflake-data-audit"
}

variable "bucket-sse-algorithm" {
  description = "Server side encryption algorithm to use"
  type        = string
  default     = "AES256"
}

variable "bucket-versioning" {
  description = "Status for bucket versioning"
  type        = string
  default     = "Enabled"
}

variable "bucket-block-public-acls" {
  description = "Block public ACLs"
  type        = bool
  default     = true
}

variable "bucket-block-public-policy" {
  description = "Block public bucket policies"
  type        = bool
  default     = true
}

variable "bucket-ignore-public-acls" {
  description = "Ignore public ACLs"
  type        = bool
  default     = true
}

variable "restrict-public-buckets" {
  description = "Restrict public buckets"
  type        = bool
  default     = true
}

variable "bucket-replication-rule" {
  description = "Status for bucket replication rule"
  type        = string
  default     = "Enabled"
}

variable "bucket-replication-storage-class" {
  description = "Storage class used for bucket replication"
  type        = string
  default     = "INTELLIGENT_TIERING"
}

variable "bucket-logging-destination" {
  description = "Destination for S3 access logs"
  type        = string
  default     = "log/"
}

variable "bucket-inventory-configuration-name" {
  description = "Inventory configuration name"
  type        = string
  default     = "project-snowflake-data-bucket-inventory"
}

variable "bucket-inventory-configuration-object-version" {
  description = "Object version for Inventory configuration"
  type        = string
  default     = "All"
}

variable "bucket-inventory-configuration-frequency" {
  description = "Frequency for S3 Inventory reports"
  type        = string
  default     = "Daily"
}

variable "bucket-inventory-configuration-output-format" {
  description = "Output format for Inventory configuration"
  type        = string
  default     = "CSV"
}

variable "bucket-inventory-configuration-destination" {
  description = "Destination for the inventory configuration"
  type        = string
  default     = "inventory-configuration-report/"
}