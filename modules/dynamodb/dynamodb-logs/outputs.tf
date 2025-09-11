# Outputs de la tabla DynamoDB para logs
output "table_name" {
  description = "Nombre de la tabla DynamoDB"
  value       = aws_dynamodb_table.logs.name
}

output "table_arn" {
  description = "ARN de la tabla DynamoDB"
  value       = aws_dynamodb_table.logs.arn
}

output "table_id" {
  description = "ID de la tabla DynamoDB"
  value       = aws_dynamodb_table.logs.id
}

output "table_hash_key" {
  description = "Clave hash de la tabla DynamoDB"
  value       = aws_dynamodb_table.logs.hash_key
}

output "table_billing_mode" {
  description = "Modo de facturación de la tabla DynamoDB"
  value       = aws_dynamodb_table.logs.billing_mode
}
