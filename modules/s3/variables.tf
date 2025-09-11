# Variables del proyecto
variable "organizacion" {
  description = "Nombre de la organización"
  type        = string
}

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
