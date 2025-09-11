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

# Variables específicas para políticas de Lambda
variable "enable_dynamodb_access" {
  description = "Habilitar acceso a DynamoDB"
  type        = bool
  default     = false
}
