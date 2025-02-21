output "dynamodb_table_names" {
  value = [for table in aws_dynamodb_table.tables : table.name]
}