output "table_name" {
  description = "Name of the DynamoDB table"
  value       = aws_dynamodb_table.transactions.name
}

output "table_arn" {
  description = "ARN of the DynamoDB table"
  value       = aws_dynamodb_table.transactions.arn
}

output "table_id" {
  description = "ID of the DynamoDB table"
  value       = aws_dynamodb_table.transactions.id
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
