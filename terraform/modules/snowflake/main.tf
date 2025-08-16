#provider block here is required otherwise initialisation will not work as Terraform will default to hashicorp/snowflake rather than snowflakedb/snowflake
terraform {
  required_providers {
    snowflake = {
      source = "snowflakedb/snowflake"
    }
  }
}

resource "snowflake_warehouse" "this" {
  name           = var.snowflake-warehouse-name
  warehouse_size = var.snowflake-warehouse-size
}

resource "snowflake_database" "this" {
  name = var.snowflake-database-name
}

resource "snowflake_schema" "this" {
  name     = var.snowflake-schema-name
  database = snowflake_database.this.name
}

resource "snowflake_sequence" "sequence" {
  name     = var.snowflake-sequence-name
  database = snowflake_schema.this.database
  schema   = snowflake_schema.this.name
}

resource "snowflake_table" "this" {
  name     = var.snowflake-table-name
  database = snowflake_schema.this.database
  schema   = snowflake_schema.this.name

  column {
    name     = "data"
    type     = "text"
    nullable = false
    collate  = "en-ci"
  }
}

resource "snowflake_storage_integration" "this" {
  name = var.snowflake-storage-integration-name

  storage_allowed_locations = ["s3://${var.s3-data-bucket-name}"]
  storage_provider          = var.snowflake-storage-provider
  storage_aws_external_id   = var.snowflake-external-id
  storage_aws_role_arn      = var.snowflake-role-arn
}

resource "snowflake_stage" "this" {
  name                = var.snowflake-stage-name
  url                 = "s3://${var.s3-data-bucket-name}"
  database            = snowflake_database.this.name
  schema              = snowflake_schema.this.name
  storage_integration = snowflake_storage_integration.this.name
}