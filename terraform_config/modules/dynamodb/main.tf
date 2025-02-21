resource "aws_dynamodb_table" "tables" {
  for_each = var.dynamodb_tables

  name         = each.key
  billing_mode = "PAY_PER_REQUEST"

  hash_key  = each.value.key_id.name
  range_key = each.value.ordering_key != null ? each.value.ordering_key.name : null

  attribute {
    name = each.value.key_id.name
    type = each.value.key_id.type
  }

  dynamic "attribute" {
    for_each = each.value.ordering_key != null ? [each.value.ordering_key] : []
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  tags = {
    Name = each.key
  }
}