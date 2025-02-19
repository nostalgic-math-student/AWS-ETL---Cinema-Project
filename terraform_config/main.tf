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

module "glue" {
  source = "./modules/glue"
  bucket_name = module.s3_bucket.bucket_name
  aws_iam_role_glue = var.aws_iam_role_glue
}