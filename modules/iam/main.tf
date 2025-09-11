# Rol IAM para funciones Lambda - Configuración mínima
resource "aws_iam_role" "lambda_execution_role" {
  name = local.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [tags]
  }

  tags = local.tags
}

# Política básica de ejecución de Lambda (incluye CloudWatch Logs)
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_execution_role.name
}

# Política personalizada para acceso a DynamoDB (solo si se proporciona ARN)
resource "aws_iam_role_policy" "lambda_dynamodb_policy" {
  count = var.dynamodb_table_arn != "" ? 1 : 0
  name  = "${local.role_name}-dynamodb-policy"
  role  = aws_iam_role.lambda_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ]
        Resource = [
          var.dynamodb_table_arn,
          "${var.dynamodb_table_arn}/index/*"
        ]
      }
    ]
  })
}

# Política personalizada para acceso a S3 (solo si se proporciona ARN)
resource "aws_iam_role_policy" "lambda_s3_policy" {
  count = var.s3_bucket_arn != "" ? 1 : 0
  name  = "${local.role_name}-s3-policy"
  role  = aws_iam_role.lambda_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = "${var.s3_bucket_arn}/*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = var.s3_bucket_arn
      }
    ]
  })
}

# Política personalizada para acceso a Systems Manager
resource "aws_iam_role_policy" "lambda_ssm_policy" {
  name = "${local.role_name}-ssm-policy"
  role = aws_iam_role.lambda_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:GetParametersByPath"
        ]
        Resource = "arn:aws:ssm:${var.region}:*:parameter/${var.proyecto}/*"
      }
    ]
  })
}

# Locals para naming conventions
locals {
  role_name = "${var.proyecto}-${var.ambiente}-lambda-execution-role"

  tags = {
    Proyecto = var.proyecto
    Ambiente = var.ambiente
    Region   = var.region
    Name     = local.role_name
    Type     = "IAM Role"
  }
}
