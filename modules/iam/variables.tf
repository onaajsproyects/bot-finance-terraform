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

# Variables de dependencias (opcionales para el rol básico)
variable "dynamodb_table_arn" {
  description = "ARN de la tabla DynamoDB"
  type        = string
  default     = ""
}

variable "s3_bucket_arn" {
  description = "ARN del bucket S3"
  type        = string
  default     = ""
}
