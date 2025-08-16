variable "s3-data-bucket-name" {
  description = "Name of S3 Data Bucket"
  type        = string
}

variable "snowflake-warehouse-name" {
  description = "Name of Snowflake Warehouse"
  type        = string
}

variable "snowflake-warehouse-size" {
  description = "Size of Snowflake Warehouse"
  type        = string
}

variable "snowflake-database-name" {
  description = "Name of Snowflake Database"
  type        = string
}

variable "snowflake-schema-name" {
  description = "Name of Snowflake Schema"
  type        = string
}

variable "snowflake-sequence-name" {
  description = "Name of Snowflake Sequence"
  type        = string
}

variable "snowflake-table-name" {
  description = "Name of Snowflake Table"
  type        = string
}

variable "snowflake-storage-integration-name" {
  description = "Name of Snowflake Storage Integration"
  type        = string
}

variable "snowflake-stage-name" {
  description = "Name of Snowflake Stage"
  type        = string
}

variable "snowflake-external-id" {
  description = "external-id of snowflake integration"
  type        = string
}

variable "snowflake-role-arn" {
  description = "Arn value of snowflake role"
  type        = string
}

variable "snowflake-storage-provider" {
  description = "Name of Snowflake Storage Provider"
  type        = string
}