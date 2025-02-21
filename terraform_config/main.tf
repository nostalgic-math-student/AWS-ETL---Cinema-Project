terraform {
  backend "s3" {
    bucket         = "backend-integrator-jrn"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}

provider "aws" {
    region = "us-east-1"
  
}
module "s3_bucket" {
  source       = "./modules/s3"
  local_folder = "./data/glue"
  bucket_name  = "xideral-integrator-project-jrn"

}

module "dynamodb" {
  source = "./modules/dynamodb"

  dynamodb_tables = {
    "AverageOrderValue_jrn" = {
      key_id = { name = "membershipNumber", type = "S" }
      ordering_key = { name = "average_order_value", type = "N" }
    }
    "InventoryEfficiency_jrn" = {
      key_id = { name = "snack_name", type = "S" }
      ordering_key = { name = "avg_days_in_inventory", type = "N" }
    }
    "ProfitPerClient_jrn" = {
      key_id = { name = "membershipNumber", type = "S" }
      ordering_key = { name = "avg_profit", type = "N" }
    }
    "ProfitPerMovie_jrn" = {
      key_id = { name = "movie", type = "S" }
      ordering_key = { name = "avg_profit", type = "N" }
    }
  }
}

## Upload Glue Job 

module "glue" {
  source = "./modules/glue"
  bucket_name = module.s3_bucket.bucket_name
  aws_iam_role_glue = var.aws_iam_role_glue
}