output "function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.bot_handler.function_name
}

output "function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.bot_handler.arn
}

output "function_invoke_arn" {
  description = "Invoke ARN of the Lambda function"
  value       = aws_lambda_function.bot_handler.invoke_arn
}

output "function_qualified_arn" {
  description = "Qualified ARN of the Lambda function"
  value       = aws_lambda_function.bot_handler.qualified_arn
}

output "function_version" {
  description = "Version of the Lambda function"
  value       = aws_lambda_function.bot_handler.version
}

output "function_last_modified" {
  description = "Last modified date of the Lambda function"
  value       = aws_lambda_function.bot_handler.last_modified
}

output "function_source_code_hash" {
  description = "Source code hash of the Lambda function"
  value       = aws_lambda_function.bot_handler.source_code_hash
}

output "function_source_code_size" {
  description = "Source code size of the Lambda function"
  value       = aws_lambda_function.bot_handler.source_code_size
}

output "log_group_name" {
  description = "Name of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.lambda_logs.name
}

output "log_group_arn" {
  description = "ARN of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.lambda_logs.arn
}

output "alias_arn" {
  description = "ARN of the Lambda alias"
  value       = var.create_alias ? aws_lambda_alias.bot_handler[0].arn : null
}

output "alias_invoke_arn" {
  description = "Invoke ARN of the Lambda alias"
  value       = var.create_alias ? aws_lambda_alias.bot_handler[0].invoke_arn : null
}
