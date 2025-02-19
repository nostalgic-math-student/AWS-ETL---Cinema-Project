provider "aws" {
  region = "us-east-1"
}

resource "aws_glue_job" "etl_process" {
  name     = "example"
  role_arn = var.aws_iam_role_glue

  command {
    script_location = "s3://${var.bucket_name}/example.py"
  }
}