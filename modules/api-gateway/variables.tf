# Variables de configuración básicas para API Gateway
variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
}

variable "environment" {
  description = "Nombre del entorno"
  type        = string
}

variable "lambda_invoke_arn" {
  description = "ARN de la función Lambda para invocar"
  type        = string
}

variable "lambda_function_name" {
  description = "Nombre de la función Lambda"
  type        = string
}

variable "tags" {
  description = "Tags para aplicar a los recursos"
  type        = map(string)
  default     = {}
}
