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

# Variables opcionales para parámetros específicos
variable "telegram_token" {
  description = "Token del bot de Telegram"
  type        = string
  sensitive   = true
  default     = ""
}
