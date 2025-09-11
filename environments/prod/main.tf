# Common tags para todos los recursos
locals {
  common_tags = {
    Proyecto  = var.proyecto
    Ambiente  = var.ambiente
    Owner     = var.owner
    CreatedBy = "terraform"
    CreatedAt = timestamp()
  }
}

# Data source para la cuenta actual de AWS
data "aws_caller_identity" "current" {}

# Data source para la región actual de AWS
data "aws_region" "current" {}

# CloudWatch Logs - Módulo de monitoreo centralizado
module "cloudwatch" {
  source = "../../modules/cloudwatch"

  project_name = var.proyecto
  environment  = var.ambiente

  # Variables de configuración de logs
  log_retention_days       = 30
  error_log_retention_days = 90

  # Tags comunes
  tags = {
    Proyecto = var.proyecto
    Ambiente = var.ambiente
    Region   = data.aws_region.current.name
  }
}

# IAM - Módulo de seguridad
module "iam" {
  source = "../../modules/iam"

  proyecto = var.proyecto
  ambiente = var.ambiente
  region   = data.aws_region.current.name

  # Configuración de acceso a servicios
  enable_dynamodb_access = false # Cambiar a true cuando DynamoDB esté activo
}

# DynamoDB - Módulo de base de datos
# module "dynamodb" {
#   source = "../../modules/dynamodb"

#   proyecto = var.proyecto
#   ambiente = var.ambiente
#   region   = data.aws_region.current.name
# }

# S3 - Módulo de almacenamiento
module "s3" {
  source = "../../modules/s3"

  proyecto = var.proyecto
  ambiente = var.ambiente
  region   = data.aws_region.current.name
}

# Lambda - Módulo de funciones
module "lambda" {
  source = "../../modules/lambda"

  proyecto          = var.proyecto
  ambiente          = var.ambiente
  region            = data.aws_region.current.name
  python_version    = var.python_version
  bucket_artefactos = module.s3.artifacts_bucket_name

  # Variables de dependencias
  lambda_role_arn = module.iam.lambda_execution_role_arn
  # tabla_logs_arn          = module.dynamodb.logs_table_arn
  # tabla_logs_name         = module.dynamodb.logs_table_name
  bucket_receipts_arn  = module.s3.receipts_bucket_arn
  bucket_receipts_name = module.s3.receipts_bucket_name
  bucket_artifacts_arn = module.s3.artifacts_bucket_arn
  bucket_artifacts_name = module.s3.artifacts_bucket_name
  # ssm_telegram_token_arn  = module.systems_manager.telegram_token_parameter_arn
  # ssm_telegram_token_name = module.systems_manager.telegram_token_parameter_name
  cloudwatch_log_group_arn = module.cloudwatch.lambda_log_group_arn

  depends_on = [module.iam, module.dynamodb, module.s3, module.systems_manager, module.cloudwatch]
}

# Systems Manager - Módulo de parámetros
# module "systems_manager" {
#   source = "../../modules/systems-manager"

#   proyecto = var.proyecto
#   ambiente = var.ambiente
#   region   = data.aws_region.current.name
# }

# API Gateway - Módulo de API
# module "api_gateway" {
#   source = "../../modules/api-gateway"

#   proyecto = var.proyecto
#   ambiente = var.ambiente
#   region   = data.aws_region.current.name

#   # Variables de dependencias
#   lambda_invoke_arn = module.lambda.procesar_mensaje_telegram_invoke_arn

#   depends_on = [module.lambda]
# }
