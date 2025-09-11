# Outputs del módulo bot-handler
output "bot_handler_function_name" {
  description = "Nombre de la función Lambda bot-handler"
  value       = module.bot-handler.function_name
}

output "bot_handler_function_arn" {
  description = "ARN de la función Lambda bot-handler"
  value       = module.bot-handler.function_arn
}

output "bot_handler_invoke_arn" {
  description = "ARN de invocación de la función Lambda bot-handler"
  value       = module.bot-handler.function_invoke_arn
}

output "bot_handler_function_version" {
  description = "Versión de la función Lambda bot-handler"
  value       = module.bot-handler.function_version
}

output "bot_handler_log_group_name" {
  description = "Nombre del grupo de logs de CloudWatch del bot-handler"
  value       = module.bot-handler.log_group_name
}

output "bot_handler_log_group_arn" {
  description = "ARN del grupo de logs de CloudWatch del bot-handler"
  value       = module.bot-handler.log_group_arn
}
