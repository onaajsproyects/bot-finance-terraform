output "telegram_token_parameter_name" {
  description = "Name of the Telegram token SSM parameter"
  value       = aws_ssm_parameter.telegram_token.name
}

output "telegram_token_parameter_arn" {
  description = "ARN of the Telegram token SSM parameter"
  value       = aws_ssm_parameter.telegram_token.arn
}