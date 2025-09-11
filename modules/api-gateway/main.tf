# API Gateway REST API - Minimal configuration
resource "aws_api_gateway_rest_api" "bot_finance" {
  name        = "${var.project_name}-${var.environment}-api"
  description = "API Gateway for Finance Bot"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = var.tags
}

# Webhook resource
resource "aws_api_gateway_resource" "webhook" {
  rest_api_id = aws_api_gateway_rest_api.bot_finance.id
  parent_id   = aws_api_gateway_rest_api.bot_finance.root_resource_id
  path_part   = "webhook"
}

# POST method for webhook
resource "aws_api_gateway_method" "webhook_post" {
  rest_api_id   = aws_api_gateway_rest_api.bot_finance.id
  resource_id   = aws_api_gateway_resource.webhook.id
  http_method   = "POST"
  authorization = "NONE"
}

# Lambda integration
resource "aws_api_gateway_integration" "webhook_lambda" {
  rest_api_id = aws_api_gateway_rest_api.bot_finance.id
  resource_id = aws_api_gateway_resource.webhook.id
  http_method = aws_api_gateway_method.webhook_post.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn
}

# Basic deployment
resource "aws_api_gateway_deployment" "bot_finance" {
  depends_on = [
    aws_api_gateway_integration.webhook_lambda
  ]

  rest_api_id = aws_api_gateway_rest_api.bot_finance.id

  lifecycle {
    create_before_destroy = true
  }

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.webhook.id,
      aws_api_gateway_method.webhook_post.id,
      aws_api_gateway_integration.webhook_lambda.id,
    ]))
  }
}

# Stage
resource "aws_api_gateway_stage" "bot_finance" {
  deployment_id = aws_api_gateway_deployment.bot_finance.id
  rest_api_id   = aws_api_gateway_rest_api.bot_finance.id
  stage_name    = var.environment

  tags = var.tags
}

# Lambda permission for API Gateway
resource "aws_lambda_permission" "api_gateway_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.bot_finance.execution_arn}/*/*"
}
