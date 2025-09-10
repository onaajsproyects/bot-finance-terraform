# Data source to get the Lambda function code
data "archive_file" "bot_handler" {
  type        = "zip"
  source_dir  = var.source_dir
  output_path = "${path.module}/bot-handler.zip"
}

# Lambda function for bot handler
resource "aws_lambda_function" "bot_handler" {
  filename         = data.archive_file.bot_handler.output_path
  function_name    = "${var.project_name}-${var.environment}-bot-handler"
  role            = var.lambda_role_arn
  handler         = var.handler
  source_code_hash = data.archive_file.bot_handler.output_base64sha256
  runtime         = var.runtime
  timeout         = var.timeout
  memory_size     = var.memory_size

  # Environment variables
  environment {
    variables = var.environment_variables
  }

  # VPC configuration (optional)
  dynamic "vpc_config" {
    for_each = var.vpc_config != null ? [var.vpc_config] : []
    content {
      subnet_ids         = vpc_config.value.subnet_ids
      security_group_ids = vpc_config.value.security_group_ids
    }
  }

  # Dead letter queue configuration
  dynamic "dead_letter_config" {
    for_each = var.dead_letter_queue_arn != null ? [1] : []
    content {
      target_arn = var.dead_letter_queue_arn
    }
  }

  # Tracing configuration
  tracing_config {
    mode = var.tracing_mode
  }

  # Layers
  layers = var.layer_arns

  # Reserved concurrent executions
  reserved_concurrent_executions = var.reserved_concurrent_executions

  # File system configuration (optional)
  dynamic "file_system_config" {
    for_each = var.file_system_config != null ? [var.file_system_config] : []
    content {
      arn              = file_system_config.value.arn
      local_mount_path = file_system_config.value.local_mount_path
    }
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-bot-handler"
    Type = "Lambda"
  })

  depends_on = [
    aws_cloudwatch_log_group.lambda_logs,
  ]
}

# CloudWatch Log Group for Lambda
resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${var.project_name}-${var.environment}-bot-handler"
  retention_in_days = var.log_retention_days

  tags = var.tags
}

# Lambda alias for versioning
resource "aws_lambda_alias" "bot_handler" {
  count            = var.create_alias ? 1 : 0
  name             = var.alias_name
  description      = "Alias for bot handler Lambda function"
  function_name    = aws_lambda_function.bot_handler.function_name
  function_version = var.function_version

  dynamic "routing_config" {
    for_each = var.weighted_routing != null ? [var.weighted_routing] : []
    content {
      additional_version_weights = routing_config.value
    }
  }
}

# Lambda event source mapping for DynamoDB Streams (if enabled)
resource "aws_lambda_event_source_mapping" "dynamodb_stream" {
  count                          = var.dynamodb_stream_arn != null ? 1 : 0
  event_source_arn              = var.dynamodb_stream_arn
  function_name                 = aws_lambda_function.bot_handler.arn
  starting_position             = var.stream_starting_position
  batch_size                    = var.stream_batch_size
  maximum_batching_window_in_seconds = var.stream_maximum_batching_window
  parallelization_factor        = var.stream_parallelization_factor

  # Error handling
  dynamic "destination_config" {
    for_each = var.stream_destination_config != null ? [var.stream_destination_config] : []
    content {
      on_failure {
        destination_arn = destination_config.value.on_failure_destination_arn
      }
    }
  }

  # Filter criteria
  dynamic "filter_criteria" {
    for_each = var.stream_filter_criteria != null ? [var.stream_filter_criteria] : []
    content {
      filter {
        pattern = filter_criteria.value.pattern
      }
    }
  }
}
