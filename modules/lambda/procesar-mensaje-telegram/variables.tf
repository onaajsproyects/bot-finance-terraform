# Variables del proyecto
variable "proyecto" {
  description = "Nombre del proyecto"
  type        = string
}

variable "ambiente" {
  description = "Ambiente de despliegue (dev, test, prod)"
  type        = string
}

variable "region" {
  description = "Región de AWS donde se desplegará la infraestructura"
  type        = string
}

# Variables específicas de Lambda
variable "source_dir" {
  description = "Directorio que contiene el código fuente de la función Lambda"
  type        = string
  default     = "../../../../bot-finance-lambda/src/bot_handler"
}

variable "handler" {
  description = "Handler de la función Lambda"
  type        = string
  default     = "lambda_function.lambda_handler"
}

variable "python_version" {
  description = "Versión de Python para la función Lambda"
  type        = string
  default     = "3.11"
}

variable "timeout" {
  description = "Tiempo de timeout para la función Lambda en segundos"
  type        = number
  default     = 30
}

variable "memory_size" {
  description = "Cantidad de memoria asignada a la función Lambda en MB"
  type        = number
  default     = 128
}

# Variables de dependencias
variable "lambda_role_arn" {
  description = "ARN del rol IAM para la función Lambda"
  type        = string
}

variable "tabla_logs_arn" {
  description = "ARN de la tabla DynamoDB para logs"
  type        = string
}

variable "tabla_logs_name" {
  description = "Nombre de la tabla DynamoDB para logs"
  type        = string
}

variable "bucket_receipts_arn" {
  description = "ARN del bucket S3 para recibos"
  type        = string
}

variable "bucket_receipts_name" {
  description = "Nombre del bucket S3 para recibos"
  type        = string
}

variable "bucket_artefactos_arn" {
  description = "ARN del bucket S3 para artefactos"
  type        = string
}

variable "bucket_artefactos_name" {
  description = "Nombre del bucket S3 para artefactos"
  type        = string
}

variable "ssm_telegram_token_arn" {
  description = "ARN del parámetro SSM para el token de Telegram"
  type        = string
}

variable "ssm_telegram_token_name" {
  description = "Nombre del parámetro SSM para el token de Telegram"
  type        = string
}

variable "cloudwatch_log_group_arn" {
  description = "ARN del grupo de logs de CloudWatch"
  type        = string
}
