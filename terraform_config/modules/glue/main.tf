provider "aws" {
  region = "us-east-1"
}
resource "aws_glue_job" "etl_process" {
  name     = "example"
  role_arn = var.aws_iam_role_glue

  command {
    script_location = "s3://${var.bucket_name}/glue_job.py"
  }
}

resource "aws_glue_trigger" "glue_job_schedule" {
  name     = "glue_job_schedule"
  type     = "SCHEDULED"
  schedule = "cron(0 */2 * * ? *)"  # Se ejecuta cada 2 horas

  actions {
    job_name = aws_glue_job.etl_process.name
  }

  start_on_creation = true
  enabled           = true
}
