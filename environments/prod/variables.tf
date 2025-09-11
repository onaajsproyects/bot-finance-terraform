# Variables del proyecto
variable "proyecto" {
  description = "Nombre del proyecto"
  type        = string
  default     = "bot-finance"
}

variable "ambiente" {
  description = "Ambiente de despliegue"
  type        = string
  default     = "prod"
}

variable "owner" {
  description = "Propietario de los recursos"
  type        = string
  default     = "DevOps Team"
}

# Variables específicas de tecnología
variable "python_version" {
  description = "Versión de Python para las funciones Lambda"
  type        = string
  default     = "3.11"
}

variable "telegram_token" {
  description = "Token del bot de Telegram (se configurará manualmente después)"
  type        = string
  sensitive   = true
  default     = "PLACEHOLDER_TOKEN"
}
