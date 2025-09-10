# API Gateway REST API
resource "aws_api_gateway_rest_api" "bot_finance" {
  name        = "${var.project_name}-${var.environment}-api"
  description = "API Gateway for Finance Bot"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = var.tags
}

# API Gateway Resource for webhook
resource "aws_api_gateway_resource" "webhook" {
  rest_api_id = aws_api_gateway_rest_api.bot_finance.id
  parent_id   = aws_api_gateway_rest_api.bot_finance.root_resource_id
  path_part   = "webhook"
}

# API Gateway Method for webhook POST
resource "aws_api_gateway_method" "webhook_post" {
  rest_api_id   = aws_api_gateway_rest_api.bot_finance.id
  resource_id   = aws_api_gateway_resource.webhook.id
  http_method   = "POST"
  authorization = "NONE"
}

# API Gateway Integration with Lambda
resource "aws_api_gateway_integration" "webhook_lambda" {
  rest_api_id = aws_api_gateway_rest_api.bot_finance.id
  resource_id = aws_api_gateway_resource.webhook.id
  http_method = aws_api_gateway_method.webhook_post.http_method

  integration_http_method = "POST"
  type                   = "AWS_PROXY"
  uri                    = var.lambda_invoke_arn
}

# API Gateway Method Response
resource "aws_api_gateway_method_response" "webhook_response_200" {
  rest_api_id = aws_api_gateway_rest_api.bot_finance.id
  resource_id = aws_api_gateway_resource.webhook.id
  http_method = aws_api_gateway_method.webhook_post.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

# API Gateway Integration Response
resource "aws_api_gateway_integration_response" "webhook_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.bot_finance.id
  resource_id = aws_api_gateway_resource.webhook.id
  http_method = aws_api_gateway_method.webhook_post.http_method
  status_code = aws_api_gateway_method_response.webhook_response_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  depends_on = [aws_api_gateway_integration.webhook_lambda]
}

# API Gateway Deployment
resource "aws_api_gateway_deployment" "bot_finance" {
  depends_on = [
    aws_api_gateway_integration.webhook_lambda,
    aws_api_gateway_integration_response.webhook_integration_response
  ]

  rest_api_id = aws_api_gateway_rest_api.bot_finance.id
  stage_name  = var.environment

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

# Lambda permission for API Gateway
resource "aws_lambda_permission" "api_gateway_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.bot_finance.execution_arn}/*/*"
}

# Usage Plan for rate limiting
resource "aws_api_gateway_usage_plan" "bot_finance" {
  name         = "${var.project_name}-${var.environment}-usage-plan"
  description  = "Usage plan for Finance Bot API"

  api_stages {
    api_id = aws_api_gateway_rest_api.bot_finance.id
    stage  = aws_api_gateway_deployment.bot_finance.stage_name
  }

  quota_settings {
    limit  = var.quota_limit
    period = "DAY"
  }

  throttle_settings {
    rate_limit  = var.throttle_rate_limit
    burst_limit = var.throttle_burst_limit
  }

  tags = var.tags
}
