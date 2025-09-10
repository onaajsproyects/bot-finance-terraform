# Systems Manager Parameter for Telegram Bot Token
resource "aws_ssm_parameter" "telegram_token" {
  name  = "/${var.project_name}/${var.environment}/telegram/token"
  type  = "SecureString"
  value = var.telegram_token

  description = "Telegram Bot Token for ${var.project_name} ${var.environment}"

  tags = merge(var.tags, {
    Name      = "${var.project_name}-${var.environment}-telegram-token"
    Type      = "SSM Parameter"
    Sensitive = "true"
  })
}

# Systems Manager Parameter for DynamoDB table name
resource "aws_ssm_parameter" "dynamodb_table_name" {
  name  = "/${var.project_name}/${var.environment}/dynamodb/table-name"
  type  = "String"
  value = var.dynamodb_table_name

  description = "DynamoDB table name for ${var.project_name} ${var.environment}"

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-dynamodb-table-name"
    Type = "SSM Parameter"
  })
}

# Systems Manager Parameter for S3 bucket name
resource "aws_ssm_parameter" "s3_bucket_name" {
  name  = "/${var.project_name}/${var.environment}/s3/bucket-name"
  type  = "String"
  value = var.s3_bucket_name

  description = "S3 bucket name for ${var.project_name} ${var.environment}"

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-s3-bucket-name"
    Type = "SSM Parameter"
  })
}

# Systems Manager Parameter for API Gateway URL
resource "aws_ssm_parameter" "api_gateway_url" {
  name  = "/${var.project_name}/${var.environment}/api-gateway/url"
  type  = "String"
  value = var.api_gateway_url

  description = "API Gateway URL for ${var.project_name} ${var.environment}"

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-api-gateway-url"
    Type = "SSM Parameter"
  })
}

# Additional custom parameters
resource "aws_ssm_parameter" "custom_parameters" {
  for_each = var.custom_parameters

  name        = "/${var.project_name}/${var.environment}/${each.key}"
  type        = each.value.type
  value       = each.value.value
  description = each.value.description

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-${each.key}"
    Type = "SSM Parameter"
  })
}

# Parameter for bot configuration (JSON)
resource "aws_ssm_parameter" "bot_config" {
  count = var.bot_config != null ? 1 : 0
  name  = "/${var.project_name}/${var.environment}/bot/config"
  type  = "String"
  value = jsonencode(var.bot_config)

  description = "Bot configuration for ${var.project_name} ${var.environment}"

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-bot-config"
    Type = "SSM Parameter"
  })
}

# Parameter for feature flags
resource "aws_ssm_parameter" "feature_flags" {
  count = var.feature_flags != null ? 1 : 0
  name  = "/${var.project_name}/${var.environment}/bot/feature-flags"
  type  = "String"
  value = jsonencode(var.feature_flags)

  description = "Feature flags for ${var.project_name} ${var.environment}"

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-feature-flags"
    Type = "SSM Parameter"
  })
}
