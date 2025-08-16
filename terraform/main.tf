module "iam" {
 source                      = "./modules/iam"

 snowflake-role-name         = var.snowflake-role-name
 snowflake-external-id       = var.snowflake-external-id

 s3-replication-role-name    = var.s3-replication-role-name

 s3-data-bucket-name         = var.s3-data-bucket-name
 s3-backup-bucket-name       = var.s3-backup-bucket-name
 s3-audit-bucket-name        = var.s3-audit-bucket-name
}


module "s3" {
 source                                            = "./modules/s3"

  s3-data-bucket-name                              = var.s3-data-bucket-name
  s3-backup-bucket-name                            = var.s3-backup-bucket-name
  s3-audit-bucket-name                             = var.s3-audit-bucket-name

  bucket-sse-algorithm                             = var.bucket-sse-algorithm
  bucket-versioning                                = var.bucket-versioning

  bucket-block-public-acls                         = var.bucket-block-public-acls
  bucket-block-public-policy                       = var.bucket-block-public-policy
  bucket-ignore-public-acls                        = var.bucket-ignore-public-acls
  restrict-public-buckets                          = var.restrict-public-buckets

  s3-replication-role-arn                          = module.iam.s3-replication-role-arn
  bucket-replication-rule                          = var.bucket-replication-rule
  bucket-replication-storage-class                 = var.bucket-replication-storage-class

  bucket-logging-destination                       = var.bucket-logging-destination

  bucket-inventory-configuration-name              = var.bucket-inventory-configuration-name
  bucket-inventory-configuration-object-version    = var.bucket-inventory-configuration-object-version
  bucket-inventory-configuration-frequency         = var.bucket-inventory-configuration-frequency
  bucket-inventory-configuration-output-format     = var.bucket-inventory-configuration-output-format
  bucket-inventory-configuration-destination       = var.bucket-inventory-configuration-destination
}

module "snowflake" {
 source                                = "./modules/snowflake"

 s3-data-bucket-name                   = var.s3-data-bucket-name
 
 snowflake-warehouse-name              = var.snowflake-warehouse-name
 snowflake-warehouse-size              = var.snowflake-warehouse-size
 snowflake-database-name               = var.snowflake-database-name
 snowflake-schema-name                 = var.snowflake-schema-name
 snowflake-sequence-name               = var.snowflake-sequence-name
 snowflake-table-name                  = var.snowflake-table-name
 snowflake-storage-integration-name    = var.snowflake-storage-integration-name
 snowflake-stage-name                  = var.snowflake-stage-name
 snowflake-role-arn                    = module.iam.snowflake-role-arn
 snowflake-external-id                 = var.snowflake-external-id
 snowflake-storage-provider            = var.snowflake-storage-provider
}