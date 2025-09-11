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
# module "cloudwatch" {
#   source = "../../modules/cloudwatch"

#   proyecto = var.proyecto
#   ambiente = var.ambiente
#   region   = data.aws_region.current.name
# }

# IAM - Módulo de seguridad
# module "iam" {
#   source = "../../modules/iam"

#   proyecto = var.proyecto
#   ambiente = var.ambiente
#   region   = data.aws_region.current.name
# }

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
# module "lambda" {
#   source = "../../modules/lambda"

#   proyecto          = var.proyecto
#   ambiente          = var.ambiente
#   region            = data.aws_region.current.name
#   python_version    = var.python_version
#   bucket_artefactos = module.s3.artifacts_bucket_name

#   # Variables de dependencias
#   lambda_role_arn         = module.iam.lambda_execution_role_arn
#   tabla_logs_arn          = module.dynamodb.logs_table_arn
#   tabla_logs_name         = module.dynamodb.logs_table_name
#   bucket_receipts_arn     = module.s3.receipts_bucket_arn
#   bucket_receipts_name    = module.s3.receipts_bucket_name
#   ssm_telegram_token_arn  = module.systems_manager.telegram_token_parameter_arn
#   ssm_telegram_token_name = module.systems_manager.telegram_token_parameter_name

#   depends_on = [module.iam, module.dynamodb, module.s3, module.systems_manager]
# }

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
#   lambda_invoke_arn = module.lambda.bot_handler_invoke_arn

#   depends_on = [module.lambda]
# }
