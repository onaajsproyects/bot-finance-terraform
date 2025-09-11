# Outputs del módulo dynamodb-logs
output "logs_table_name" {
  description = "Nombre de la tabla DynamoDB para logs"
  value       = module.dynamodb-logs.table_name
}

output "logs_table_arn" {
  description = "ARN de la tabla DynamoDB para logs"
  value       = module.dynamodb-logs.table_arn
}

output "logs_table_id" {
  description = "ID de la tabla DynamoDB para logs"
  value       = module.dynamodb-logs.table_id
}

output "logs_table_hash_key" {
  description = "Clave hash de la tabla DynamoDB para logs"
  value       = module.dynamodb-logs.table_hash_key
}

output "stream_arn" {
  description = "ARN of the DynamoDB stream"
  value       = aws_dynamodb_table.transactions.stream_arn
}

output "stream_label" {
  description = "Label of the DynamoDB stream"
  value       = aws_dynamodb_table.transactions.stream_label
}

output "global_secondary_indexes" {
  description = "Global secondary indexes of the table"
  value = {
    user_index     = "UserIndex"
    date_index     = "DateIndex"
    category_index = "CategoryIndex"
  }
}
