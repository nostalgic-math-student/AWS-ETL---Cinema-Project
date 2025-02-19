output "glue_job_name" {
  description = "ARN del Glue Job"
  value       = aws_glue_job.etl_process.arn
}
