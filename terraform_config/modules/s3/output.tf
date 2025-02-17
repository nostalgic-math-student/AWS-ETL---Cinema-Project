output "bucket_name" {
  description = "ARN del bucket"
  value       = aws_s3_bucket.bucket.arn
}
