variable "dynamodb_tables" {
  description = "Lista de tablas de DynamoDB con claves personalizadas"
  type = map(object({
    key_id = object({
      name = string
      type = string
    })
    ordering_key = optional(object({
      name = string
      type = string
    }), null)
  }))
}
