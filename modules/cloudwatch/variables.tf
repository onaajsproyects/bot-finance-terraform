# Variables de configuración básicas para CloudWatch
variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
}

variable "environment" {
  description = "Nombre del entorno"
  type        = string
}

variable "log_retention_days" {
  description = "Período de retención de logs de CloudWatch en días"
  type        = number
  default     = 14
}

variable "error_log_retention_days" {
  description = "Período de retención de logs de error en días"
  type        = number
  default     = 30
}

variable "tags" {
  description = "Tags para aplicar a los recursos"
  type        = map(string)
  default     = {}
}
