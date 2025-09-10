variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "telegram_token" {
  description = "Telegram bot token"
  type        = string
  sensitive   = true
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  type        = string
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "api_gateway_url" {
  description = "URL of the API Gateway"
  type        = string
}

variable "custom_parameters" {
  description = "Custom SSM parameters"
  type = map(object({
    type        = string
    value       = string
    description = string
  }))
  default = {}
}

variable "bot_config" {
  description = "Bot configuration object"
  type        = any
  default     = null
}

variable "feature_flags" {
  description = "Feature flags configuration"
  type        = map(bool)
  default     = null
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
