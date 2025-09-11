# Outputs de la función Lambda procesar-mensaje-telegram
output "function_name" {
  description = "Nombre de la función Lambda"
  value       = aws_lambda_function.procesar_mensaje_telegram.function_name
}

output "function_arn" {
  description = "ARN de la función Lambda"
  value       = aws_lambda_function.procesar_mensaje_telegram.arn
}

output "function_invoke_arn" {
  description = "ARN de invocación de la función Lambda"
  value       = aws_lambda_function.procesar_mensaje_telegram.invoke_arn
}

output "function_version" {
  description = "Versión de la función Lambda"
  value       = aws_lambda_function.procesar_mensaje_telegram.version
}
