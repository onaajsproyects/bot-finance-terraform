variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "source_dir" {
  description = "Directory containing the Lambda function source code"
  type        = string
}

variable "lambda_role_arn" {
  description = "ARN of the IAM role for the Lambda function"
  type        = string
}

variable "handler" {
  description = "Lambda function handler"
  type        = string
  default     = "lambda_function.lambda_handler"
}

variable "runtime" {
  description = "Lambda runtime"
  type        = string
  default     = "python3.11"
}

variable "timeout" {
  description = "Lambda function timeout in seconds"
  type        = number
  default     = 30
}

variable "memory_size" {
  description = "Lambda function memory size in MB"
  type        = number
  default     = 128
}

variable "environment_variables" {
  description = "Environment variables for the Lambda function"
  type        = map(string)
  default     = {}
}

variable "vpc_config" {
  description = "VPC configuration for the Lambda function"
  type = object({
    subnet_ids         = list(string)
    security_group_ids = list(string)
  })
  default = null
}

variable "dead_letter_queue_arn" {
  description = "ARN of the dead letter queue"
  type        = string
  default     = null
}

variable "tracing_mode" {
  description = "X-Ray tracing mode (Active or PassThrough)"
  type        = string
  default     = "PassThrough"
  validation {
    condition     = contains(["Active", "PassThrough"], var.tracing_mode)
    error_message = "Tracing mode must be either Active or PassThrough."
  }
}

variable "layer_arns" {
  description = "List of Lambda layer ARNs"
  type        = list(string)
  default     = []
}

variable "reserved_concurrent_executions" {
  description = "Number of reserved concurrent executions"
  type        = number
  default     = -1
}

variable "file_system_config" {
  description = "EFS file system configuration"
  type = object({
    arn              = string
    local_mount_path = string
  })
  default = null
}

variable "log_retention_days" {
  description = "CloudWatch log retention in days"
  type        = number
  default     = 14
}

variable "create_alias" {
  description = "Whether to create a Lambda alias"
  type        = bool
  default     = false
}

variable "alias_name" {
  description = "Name of the Lambda alias"
  type        = string
  default     = "live"
}

variable "function_version" {
  description = "Lambda function version for alias"
  type        = string
  default     = "$LATEST"
}

variable "weighted_routing" {
  description = "Weighted routing configuration for alias"
  type        = map(number)
  default     = null
}

variable "dynamodb_stream_arn" {
  description = "ARN of DynamoDB stream to trigger Lambda"
  type        = string
  default     = null
}

variable "stream_starting_position" {
  description = "Starting position for DynamoDB stream"
  type        = string
  default     = "LATEST"
}

variable "stream_batch_size" {
  description = "Batch size for DynamoDB stream"
  type        = number
  default     = 10
}

variable "stream_maximum_batching_window" {
  description = "Maximum batching window in seconds"
  type        = number
  default     = 5
}

variable "stream_parallelization_factor" {
  description = "Parallelization factor for DynamoDB stream"
  type        = number
  default     = 1
}

variable "stream_destination_config" {
  description = "Destination configuration for stream errors"
  type = object({
    on_failure_destination_arn = string
  })
  default = null
}

variable "stream_filter_criteria" {
  description = "Filter criteria for DynamoDB stream"
  type = object({
    pattern = string
  })
  default = null
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
