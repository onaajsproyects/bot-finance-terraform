variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "bot-finance"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "owner" {
  description = "Owner of the resources"
  type        = string
  default     = "DevOps Team"
}

variable "telegram_token" {
  description = "Telegram bot token"
  type        = string
  sensitive   = true
}

# DynamoDB Configuration
variable "dynamodb_billing_mode" {
  description = "DynamoDB billing mode"
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "enable_dynamodb_point_in_time_recovery" {
  description = "Enable DynamoDB point-in-time recovery"
  type        = bool
  default     = true
}

# S3 Configuration
variable "enable_s3_versioning" {
  description = "Enable S3 bucket versioning"
  type        = bool
  default     = true
}

variable "enable_s3_lifecycle" {
  description = "Enable S3 lifecycle management"
  type        = bool
  default     = true
}

# Lambda Configuration
variable "lambda_runtime" {
  description = "Lambda runtime"
  type        = string
  default     = "python3.11"
}

variable "lambda_timeout" {
  description = "Lambda function timeout in seconds"
  type        = number
  default     = 30
}

variable "lambda_memory_size" {
  description = "Lambda function memory size in MB"
  type        = number
  default     = 256
}

variable "lambda_log_retention_days" {
  description = "CloudWatch log retention in days"
  type        = number
  default     = 14
}

# API Gateway Configuration
variable "api_gateway_quota_limit" {
  description = "API Gateway quota limit per day"
  type        = number
  default     = 10000
}

variable "api_gateway_throttle_rate_limit" {
  description = "API Gateway throttle rate limit"
  type        = number
  default     = 100
}

variable "api_gateway_throttle_burst_limit" {
  description = "API Gateway throttle burst limit"
  type        = number
  default     = 200
}

# Feature Flags
variable "enable_xray_tracing" {
  description = "Enable X-Ray tracing"
  type        = bool
  default     = false
}

variable "enable_enhanced_logging" {
  description = "Enable enhanced CloudWatch logging"
  type        = bool
  default     = false
}

# Bot Configuration
variable "bot_config" {
  description = "Bot configuration"
  type = object({
    max_retries           = number
    timeout_seconds       = number
    enable_debug_mode     = bool
    max_file_size_mb      = number
    supported_currencies  = list(string)
  })
  default = {
    max_retries           = 3
    timeout_seconds       = 30
    enable_debug_mode     = false
    max_file_size_mb      = 10
    supported_currencies  = ["CLP", "USD", "EUR"]
  }
}

variable "feature_flags" {
  description = "Feature flags"
  type        = map(bool)
  default = {
    enable_webhooks       = true
    enable_file_uploads   = true
    enable_metrics        = true
    enable_backup         = true
    enable_notifications  = false
  }
}
