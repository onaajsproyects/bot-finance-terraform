# Common tags for all resources
locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    Owner       = var.owner
    CreatedBy   = "terraform"
    CreatedAt   = timestamp()
  }

  # Lambda source directory
  lambda_source_dir = "${path.module}/../../base/lambda/bot-handler"
}

# Data source for current AWS account
data "aws_caller_identity" "current" {}

# Data source for current AWS region
data "aws_region" "current" {}

# IAM Module
module "iam" {
  source = "../../modules/iam"

  project_name            = var.project_name
  environment             = var.environment
  aws_region              = var.aws_region
  dynamodb_table_arn      = module.dynamodb.table_arn
  s3_bucket_arn           = module.s3.bucket_arn
  enable_enhanced_logging = var.enable_enhanced_logging
  enable_xray_tracing     = var.enable_xray_tracing

  tags = local.common_tags
}

# DynamoDB Module
module "dynamodb" {
  source = "../../modules/dynamodb"

  project_name                  = var.project_name
  environment                   = var.environment
  billing_mode                  = var.dynamodb_billing_mode
  enable_point_in_time_recovery = var.enable_dynamodb_point_in_time_recovery

  tags = local.common_tags
}

# S3 Module
module "s3" {
  source = "../../modules/s3"

  project_name      = var.project_name
  environment       = var.environment
  enable_versioning = var.enable_s3_versioning
  enable_lifecycle  = var.enable_s3_lifecycle
  lambda_role_arn   = module.iam.lambda_execution_role_arn

  tags = local.common_tags
}

# Lambda Bot Handler Module
module "lambda_bot_handler" {
  source = "../../modules/lambda/bot-handler"

  project_name       = var.project_name
  environment        = var.environment
  source_dir         = local.lambda_source_dir
  lambda_role_arn    = module.iam.lambda_execution_role_arn
  runtime            = var.lambda_runtime
  timeout            = var.lambda_timeout
  memory_size        = var.lambda_memory_size
  log_retention_days = var.lambda_log_retention_days

  environment_variables = {
    DYNAMODB_TABLE       = module.dynamodb.table_name
    S3_BUCKET            = module.s3.bucket_name
    TELEGRAM_TOKEN_PARAM = module.systems_manager.telegram_token_parameter_name
    PROJECT_NAME         = var.project_name
    ENVIRONMENT          = var.environment
    AWS_REGION           = var.aws_region
  }

  tracing_mode = var.enable_xray_tracing ? "Active" : "PassThrough"

  tags = local.common_tags

  depends_on = [module.iam]
}

# API Gateway Module
module "api_gateway" {
  source = "../../modules/api-gateway"

  project_name         = var.project_name
  environment          = var.environment
  lambda_invoke_arn    = module.lambda_bot_handler.function_invoke_arn
  lambda_function_name = module.lambda_bot_handler.function_name
  quota_limit          = var.api_gateway_quota_limit
  throttle_rate_limit  = var.api_gateway_throttle_rate_limit
  throttle_burst_limit = var.api_gateway_throttle_burst_limit

  tags = local.common_tags

  depends_on = [module.lambda_bot_handler]
}

# Systems Manager Module
module "systems_manager" {
  source = "../../modules/systems-manager"

  project_name        = var.project_name
  environment         = var.environment
  telegram_token      = var.telegram_token
  dynamodb_table_name = module.dynamodb.table_name
  s3_bucket_name      = module.s3.bucket_name
  api_gateway_url     = module.api_gateway.api_gateway_url
  bot_config          = var.bot_config
  feature_flags       = var.feature_flags

  custom_parameters = {
    "aws/account-id" = {
      type        = "String"
      value       = data.aws_caller_identity.current.account_id
      description = "AWS Account ID"
    }
    "aws/region" = {
      type        = "String"
      value       = data.aws_region.current.name
      description = "AWS Region"
    }
  }

  tags = local.common_tags
}
