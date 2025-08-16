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

variable "bucket-sse-algorithm" {
  description = "Server side encryption algorithm to use"
  type        = string
}

variable "bucket-versioning" {
  description = "Status for bucket versioning"
  type        = string
}

variable "bucket-block-public-acls" {
  description = "Block public ACLs"
  type        = bool
}

variable "bucket-block-public-policy" {
  description = "Block public bucket policies"
  type        = bool
}

variable "bucket-ignore-public-acls" {
  description = "Ignore public ACLs"
  type        = bool
}

variable "restrict-public-buckets" {
  description = "Restrict public buckets"
  type        = bool
}

variable "s3-replication-role-arn" {
  description = "Arn value of s3 replication role"
  type        = string
}

variable "bucket-replication-rule" {
  description = "Status for bucket replication rule"
  type        = string
}

variable "bucket-replication-storage-class" {
  description = "Storage class used for bucket replication"
  type        = string
}

variable "bucket-logging-destination" {
  description = "Destination for S3 access logs"
  type        = string
}

variable "bucket-inventory-configuration-name" {
  description = "Inventory configuration name"
  type        = string
}

variable "bucket-inventory-configuration-object-version" {
  description = "Object version for Inventory configuration"
  type        = string
}

variable "bucket-inventory-configuration-frequency" {
  description = "Frequency for S3 Inventory reports"
  type        = string
}

variable "bucket-inventory-configuration-output-format" {
  description = "Output format for Inventory configuration"
  type        = string
}

variable "bucket-inventory-configuration-destination" {
  description = "Destination for the inventory configuration"
  type        = string
}