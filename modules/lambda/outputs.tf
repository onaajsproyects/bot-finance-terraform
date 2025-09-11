# Outputs del módulo procesar-mensaje-telegram
output "procesar_mensaje_telegram_function_name" {
  description = "Nombre de la función Lambda procesar-mensaje-telegram"
  value       = module.procesar-mensaje-telegram.function_name
}

output "procesar_mensaje_telegram_function_arn" {
  description = "ARN de la función Lambda procesar-mensaje-telegram"
  value       = module.procesar-mensaje-telegram.function_arn
}

output "procesar_mensaje_telegram_invoke_arn" {
  description = "ARN de invocación de la función Lambda procesar-mensaje-telegram"
  value       = module.procesar-mensaje-telegram.function_invoke_arn
}

output "procesar_mensaje_telegram_function_version" {
  description = "Versión de la función Lambda procesar-mensaje-telegram"
  value       = module.procesar-mensaje-telegram.function_version
}
