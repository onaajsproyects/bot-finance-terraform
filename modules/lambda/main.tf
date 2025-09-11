module "bot-handler" {
  source = "./bot-handler"

  # Variables del proyecto
  proyecto = var.proyecto
  ambiente = var.ambiente
  region   = var.region

  # Variables específicas de Lambda
  python_version    = var.python_version
  bucket_artefactos = var.bucket_artefactos
  lambda_role_arn   = var.lambda_role_arn

  # Variables de dependencias
  tabla_logs_arn          = var.tabla_logs_arn
  tabla_logs_name         = var.tabla_logs_name
  bucket_receipts_arn     = var.bucket_receipts_arn
  bucket_receipts_name    = var.bucket_receipts_name
  ssm_telegram_token_arn  = var.ssm_telegram_token_arn
  ssm_telegram_token_name = var.ssm_telegram_token_name
}
