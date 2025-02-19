variable "bucket_name" {
  description = "Nombre del bucket"
  type        = string
}

variable "aws_iam_role_glue" {
  description = "Nombre del rol de ETL"
  sensitive = true
}
