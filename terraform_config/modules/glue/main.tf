provider "aws" {
  region = "us-east-1"
}

resource "aws_glue_job" "etl_process" {
  name     = "example"
  role_arn = var.aws_iam_role

  command {
    script_location = "s3://${aws_s3_bucket.example.bucket}/example.py"
  }
}