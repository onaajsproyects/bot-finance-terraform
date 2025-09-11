# Outputs condicionales - solo si los módulos están desplegados

# Outputs de S3 (siempre disponibles)
output "receipts_bucket_name" {
  description = "Nombre del bucket S3 para recibos"
  value       = module.s3.receipts_bucket_name
}

output "artifacts_bucket_name" {
  description = "Nombre del bucket S3 para artefactos"
  value       = module.s3.artifacts_bucket_name
}

# Outputs de Lambda (solo si el módulo está activo)
# output "lambda_function_name" {
#   description = "Nombre de la función Lambda"
#   value       = module.lambda.bot_handler_function_name
# }

# output "bot_handler_function_name" {
#   description = "Nombre de la función Lambda bot-handler"
#   value       = module.lambda.bot_handler_function_name
# }

# Outputs de API Gateway (solo si el módulo está activo)
# output "api_gateway_url" {
#   description = "URL del API Gateway"
#   value       = module.api_gateway.api_url
# }

# output "api_url" {
#   description = "URL de la API"
#   value       = module.api_gateway.api_url
# }

# Output de prefijo SSM (solo si systems-manager está activo)
# output "ssm_parameter_prefix" {
#   description = "Prefijo de parámetros SSM"
#   value       = module.systems_manager.parameter_prefix
# }

# Outputs de DynamoDB (solo si el módulo está activo)
# output "logs_table_name" {
#   description = "Nombre de la tabla DynamoDB para logs"
#   value       = module.dynamodb.logs_table_name
# }

# Información general del despliegue
output "environment_info" {
  description = "Información del ambiente desplegado"
  value = {
    organizacion = var.organizacion
    proyecto     = var.proyecto
    ambiente     = var.ambiente
    region       = data.aws_region.current.name
    account_id   = data.aws_caller_identity.current.account_id
  }
}
