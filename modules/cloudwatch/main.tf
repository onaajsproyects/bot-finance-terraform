# CloudWatch Log Groups for all services
resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${var.project_name}-${var.environment}-bot-handler"
  retention_in_days = var.log_retention_days

  tags = merge(var.tags, {
    Name    = "${var.project_name}-${var.environment}-lambda-logs"
    Type    = "CloudWatch Log Group"
    Service = "Lambda"
  })
}

resource "aws_cloudwatch_log_group" "api_gateway_logs" {
  name              = "/aws/apigateway/${var.project_name}-${var.environment}"
  retention_in_days = var.log_retention_days

  tags = merge(var.tags, {
    Name    = "${var.project_name}-${var.environment}-api-gateway-logs"
    Type    = "CloudWatch Log Group"
    Service = "API Gateway"
  })
}

# CloudWatch Log Group for application logs
resource "aws_cloudwatch_log_group" "application_logs" {
  name              = "/aws/application/${var.project_name}-${var.environment}"
  retention_in_days = var.log_retention_days

  tags = merge(var.tags, {
    Name    = "${var.project_name}-${var.environment}-app-logs"
    Type    = "CloudWatch Log Group"
    Service = "Application"
  })
}

# CloudWatch Log Group for errors
resource "aws_cloudwatch_log_group" "error_logs" {
  name              = "/aws/errors/${var.project_name}-${var.environment}"
  retention_in_days = var.error_log_retention_days

  tags = merge(var.tags, {
    Name    = "${var.project_name}-${var.environment}-error-logs"
    Type    = "CloudWatch Log Group"
    Service = "Errors"
  })
}
