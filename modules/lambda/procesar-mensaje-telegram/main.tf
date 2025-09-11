locals {
  function_name = "${var.proyecto}-${var.ambiente}-procesar-mensaje-telegram"
  artifact_key = "${local.function_name}.zip"

  tags = {
    Proyecto = var.proyecto
    Ambiente = var.ambiente
    Region   = var.region
    Name     = local.function_name
    Type     = "Lambda"
  }
}

data "archive_file" "source" {
  type = "zip"
  source_file = "../../base/lambda/lambda_function.py"
  output_path = "../../base/lambda/lambda_function.zip"
}

resource "aws_s3_object" "artifact_upload" {
  bucket = var.bucket_artefactos
  key = "lambda/${local.artifact_key}"
  source = "${data.archive_file.source.output_path}"
}

# Función Lambda para procesar mensajes de Telegram
resource "aws_lambda_function" "procesar_mensaje_telegram" {
  function_name = "${local.function_name}"
  description = "Procesa los mensajes de telegram: extrae, transforma y almacena"
  s3_bucket = var.bucket_artefactos
  s3_key = "${aws_s3_object.artifact_upload.key}"
  role = var.lambda_role_arn
  handler = var.handler
  runtime = "python${var.python_version}"
  logging_config {
    application_log_level = "INFO"
    log_format = "JSON"
    system_log_level = "INFO"
  }
  environment {
    variables = {
      TABLA_LOGS_NAME          = var.tabla_logs_name
      BUCKET_RECEIPTS_NAME     = var.bucket_receipts_name
    }
  }
  timeout = 30
  memory_size = 128
}