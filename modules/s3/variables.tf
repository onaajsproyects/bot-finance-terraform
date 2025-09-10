variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "enable_versioning" {
  description = "Enable S3 bucket versioning"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "KMS key ID for S3 encryption (optional)"
  type        = string
  default     = null
}

variable "block_public_access" {
  description = "Block all public access to S3 bucket"
  type        = bool
  default     = true
}

variable "enable_lifecycle" {
  description = "Enable S3 lifecycle management"
  type        = bool
  default     = true
}

variable "ia_transition_days" {
  description = "Days after which objects transition to IA"
  type        = number
  default     = 30
}

variable "glacier_transition_days" {
  description = "Days after which objects transition to Glacier"
  type        = number
  default     = 90
}

variable "deep_archive_transition_days" {
  description = "Days after which objects transition to Deep Archive"
  type        = number
  default     = 365
}

variable "noncurrent_version_expiration_days" {
  description = "Days after which non-current versions expire"
  type        = number
  default     = 90
}

variable "enable_cors" {
  description = "Enable CORS configuration"
  type        = bool
  default     = false
}

variable "cors_allowed_headers" {
  description = "Allowed headers for CORS"
  type        = list(string)
  default     = ["*"]
}

variable "cors_allowed_methods" {
  description = "Allowed methods for CORS"
  type        = list(string)
  default     = ["GET", "PUT", "POST"]
}

variable "cors_allowed_origins" {
  description = "Allowed origins for CORS"
  type        = list(string)
  default     = ["*"]
}

variable "cors_expose_headers" {
  description = "Headers to expose for CORS"
  type        = list(string)
  default     = []
}

variable "cors_max_age_seconds" {
  description = "Max age in seconds for CORS"
  type        = number
  default     = 3000
}

variable "enable_notifications" {
  description = "Enable S3 bucket notifications"
  type        = bool
  default     = false
}

variable "lambda_notifications" {
  description = "Lambda function notifications configuration"
  type = list(object({
    function_arn    = string
    function_name   = string
    events          = list(string)
    filter_prefix   = string
    filter_suffix   = string
  }))
  default = []
}

variable "lambda_role_arn" {
  description = "ARN of Lambda role for bucket policy"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
