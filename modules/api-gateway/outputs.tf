output "api_gateway_id" {
  description = "ID of the API Gateway"
  value       = aws_api_gateway_rest_api.bot_finance.id
}

output "api_gateway_arn" {
  description = "ARN of the API Gateway"
  value       = aws_api_gateway_rest_api.bot_finance.arn
}

output "api_gateway_url" {
  description = "URL of the API Gateway"
  value       = aws_api_gateway_deployment.bot_finance.invoke_url
}

output "webhook_url" {
  description = "Complete webhook URL"
  value       = "${aws_api_gateway_deployment.bot_finance.invoke_url}/webhook"
}

output "api_gateway_execution_arn" {
  description = "Execution ARN of the API Gateway"
  value       = aws_api_gateway_rest_api.bot_finance.execution_arn
}

output "deployment_id" {
  description = "ID of the API Gateway deployment"
  value       = aws_api_gateway_deployment.bot_finance.id
}

output "stage_name" {
  description = "Stage name of the API Gateway deployment"
  value       = aws_api_gateway_deployment.bot_finance.stage_name
}
