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

# Rol IAM para funciones Lambda
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


# Política específica para acceso a buckets S3 del proyecto
resource "aws_iam_role_policy" "lambda_s3_policy" {
  name = "${local.role_name}-s3-policy"
  role = aws_iam_role.lambda_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "S3Access"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:GetObjectVersion",
          "s3:ListBucketVersions",
          "s3:ListBucket",
          "s3:GetBucketLocation",
          "s3:GetBucketVersioning"
        ]
        Resource = [
          "arn:aws:s3:::${var.proyecto}-${var.ambiente}-receipts/*",
          "arn:aws:s3:::${var.proyecto}-${var.ambiente}-receipts",
          "arn:aws:s3:::${var.proyecto}-${var.ambiente}-artifacts/*",
          "arn:aws:s3:::${var.proyecto}-${var.ambiente}-artifacts"
        ]
      }
    ]
  })
}

# Política específica para acceso a DynamoDB
resource "aws_iam_role_policy" "lambda_dynamodb_policy" {
  count = var.enable_dynamodb_access ? 1 : 0
  name  = "${local.role_name}-dynamodb-policy"
  role  = aws_iam_role.lambda_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DynamoDBAccess"
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:BatchGetItem",
          "dynamodb:BatchWriteItem",
          "dynamodb:DescribeTable",
          "dynamodb:DescribeTimeToLive",
          "dynamodb:ListTagsOfResource"
        ]
        Resource = [
          "arn:aws:dynamodb:${var.region}:*:table/${var.proyecto}-${var.ambiente}-logs",
          "arn:aws:dynamodb:${var.region}:*:table/${var.proyecto}-${var.ambiente}-logs/index/*"
        ]
      }
    ]
  })
}

# Política específica para acceso a Systems Manager Parameter Store
resource "aws_iam_role_policy" "lambda_ssm_policy" {
  name = "${local.role_name}-ssm-policy"
  role = aws_iam_role.lambda_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "SSMParameterAccess"
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:GetParametersByPath",
          "ssm:DescribeParameters"
        ]
        Resource = [
          "arn:aws:ssm:${var.region}:*:parameter/${var.proyecto}/*",
          "arn:aws:ssm:${var.region}:*:parameter/${var.proyecto}-${var.ambiente}/*",
          "*"
        ]
        Condition = {
          StringBeginsWith = {
            "ssm:parameter-name" = [
              "${var.proyecto}/",
              "${var.proyecto}-${var.ambiente}/"
            ]
          }
        }
      }
    ]
  })
}
