# Outputs de la función Lambda bot-handler
output "function_name" {
  description = "Nombre de la función Lambda"
  value       = aws_lambda_function.bot_handler.function_name
}

output "function_arn" {
  description = "ARN de la función Lambda"
  value       = aws_lambda_function.bot_handler.arn
}

output "function_invoke_arn" {
  description = "ARN de invocación de la función Lambda"
  value       = aws_lambda_function.bot_handler.invoke_arn
}

output "function_version" {
  description = "Versión de la función Lambda"
  value       = aws_lambda_function.bot_handler.version
}

output "log_group_name" {
  description = "Nombre del grupo de logs de CloudWatch"
  value       = aws_cloudwatch_log_group.lambda_logs.name
}

output "log_group_arn" {
  description = "ARN del grupo de logs de CloudWatch"
  value       = aws_cloudwatch_log_group.lambda_logs.arn
}
