# Data source para obtener el código de la función Lambda
data "archive_file" "bot_handler" {
  type        = "zip"
  source_dir  = var.source_dir
  output_path = "${path.module}/bot-handler.zip"
}

# Función Lambda para el manejo del bot - Configuración mínima
resource "aws_lambda_function" "bot_handler" {
  filename         = data.archive_file.bot_handler.output_path
  function_name    = local.function_name
  role             = var.lambda_role_arn
  handler          = var.handler
  source_code_hash = data.archive_file.bot_handler.output_base64sha256
  runtime          = "python${var.python_version}"
  timeout          = var.timeout
  memory_size      = var.memory_size

  environment {
    variables = {
      DYNAMODB_TABLE       = var.tabla_logs_name
      S3_BUCKET_RECEIPTS   = var.bucket_receipts_name
      TELEGRAM_TOKEN_PARAM = var.ssm_telegram_token_name
    }
  }

  tags = local.tags

  depends_on = [aws_cloudwatch_log_group.lambda_logs]
}

# Grupo de logs de CloudWatch para la función Lambda
resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${local.function_name}"
  retention_in_days = var.log_retention_days
  tags              = local.tags
}

# Locals para naming conventions
locals {
  function_name = "${var.proyecto}-${var.ambiente}-bot-handler"

  tags = {
    Proyecto = var.proyecto
    Ambiente = var.ambiente
    Region   = var.region
    Name     = local.function_name
    Type     = "Lambda"
  }
}
