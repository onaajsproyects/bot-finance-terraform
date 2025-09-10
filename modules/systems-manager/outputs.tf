output "telegram_token_parameter_name" {
  description = "Name of the Telegram token SSM parameter"
  value       = aws_ssm_parameter.telegram_token.name
}

output "telegram_token_parameter_arn" {
  description = "ARN of the Telegram token SSM parameter"
  value       = aws_ssm_parameter.telegram_token.arn
}

output "dynamodb_table_name_parameter_name" {
  description = "Name of the DynamoDB table name SSM parameter"
  value       = aws_ssm_parameter.dynamodb_table_name.name
}

output "s3_bucket_name_parameter_name" {
  description = "Name of the S3 bucket name SSM parameter"
  value       = aws_ssm_parameter.s3_bucket_name.name
}

output "api_gateway_url_parameter_name" {
  description = "Name of the API Gateway URL SSM parameter"
  value       = aws_ssm_parameter.api_gateway_url.name
}

output "parameter_prefix" {
  description = "SSM parameter prefix for this project and environment"
  value       = "/${var.project_name}/${var.environment}"
}

output "custom_parameter_names" {
  description = "Names of custom SSM parameters"
  value       = { for k, v in aws_ssm_parameter.custom_parameters : k => v.name }
}

output "bot_config_parameter_name" {
  description = "Name of the bot config SSM parameter"
  value       = var.bot_config != null ? aws_ssm_parameter.bot_config[0].name : null
}

output "feature_flags_parameter_name" {
  description = "Name of the feature flags SSM parameter"
  value       = var.feature_flags != null ? aws_ssm_parameter.feature_flags[0].name : null
}
