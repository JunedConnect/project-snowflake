terraform {

  required_version = ">=1.12.2"

  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "6.7.0"
    }

    snowflake = {
      source  = "snowflakedb/snowflake"
      version = "2.5.0"
    }

  }

  backend "s3" {
    bucket       = "tf-state-project-snowflake"
    key          = "terraform.tfstate"
    region       = "eu-west-2"
    encrypt      = "true"
    use_lockfile = true
  }

}

provider "aws" {

  region = "eu-west-2"

  default_tags {
    tags = var.aws-tags
  }

}

provider "snowflake" {
  
  organization_name = var.snowflake-organization-name
  account_name      = var.snowflake-account-name
  user              = var.snowflake-user
  password          = var.snowflake-password
  role              = var.snowflake-role
  preview_features_enabled = [
    "snowflake_sequence_resource",
    "snowflake_table_resource",
    "snowflake_storage_integration_resource",
    "snowflake_stage_resource"
  ]

}