# S3 Bucket for storing receipts/boletas
resource "aws_s3_bucket" "receipts" {
  bucket = "${var.project_name}-${var.environment}-receipts-${random_string.bucket_suffix.result}"

  tags = merge(var.tags, {
    Name        = "${var.project_name}-${var.environment}-receipts"
    Type        = "S3"
    Purpose     = "Receipts Storage"
  })
}

# Random string for bucket suffix to ensure uniqueness
resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

# S3 Bucket versioning
resource "aws_s3_bucket_versioning" "receipts_versioning" {
  bucket = aws_s3_bucket.receipts.id
  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}

# S3 Bucket server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "receipts_encryption" {
  bucket = aws_s3_bucket.receipts.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.kms_key_id != null ? "aws:kms" : "AES256"
      kms_master_key_id = var.kms_key_id
    }
    bucket_key_enabled = var.kms_key_id != null ? true : false
  }
}

# S3 Bucket public access block
resource "aws_s3_bucket_public_access_block" "receipts_pab" {
  bucket = aws_s3_bucket.receipts.id

  block_public_acls       = var.block_public_access
  block_public_policy     = var.block_public_access
  ignore_public_acls      = var.block_public_access
  restrict_public_buckets = var.block_public_access
}

# S3 Bucket lifecycle configuration
resource "aws_s3_bucket_lifecycle_configuration" "receipts_lifecycle" {
  count  = var.enable_lifecycle ? 1 : 0
  bucket = aws_s3_bucket.receipts.id

  rule {
    id     = "receipts_lifecycle"
    status = "Enabled"

    filter {
      prefix = ""
    }

    # Transition to Infrequent Access after 30 days
    transition {
      days          = var.ia_transition_days
      storage_class = "STANDARD_IA"
    }

    # Transition to Glacier after 90 days
    transition {
      days          = var.glacier_transition_days
      storage_class = "GLACIER"
    }

    # Transition to Deep Archive after 365 days
    transition {
      days          = var.deep_archive_transition_days
      storage_class = "DEEP_ARCHIVE"
    }

    # Delete non-current versions after specified days
    noncurrent_version_expiration {
      noncurrent_days = var.noncurrent_version_expiration_days
    }

    # Delete incomplete multipart uploads after 7 days
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

# S3 Bucket CORS configuration
resource "aws_s3_bucket_cors_configuration" "receipts_cors" {
  count  = var.enable_cors ? 1 : 0
  bucket = aws_s3_bucket.receipts.id

  cors_rule {
    allowed_headers = var.cors_allowed_headers
    allowed_methods = var.cors_allowed_methods
    allowed_origins = var.cors_allowed_origins
    expose_headers  = var.cors_expose_headers
    max_age_seconds = var.cors_max_age_seconds
  }
}

# S3 Bucket notification configuration (optional)
resource "aws_s3_bucket_notification" "receipts_notification" {
  count  = var.enable_notifications ? 1 : 0
  bucket = aws_s3_bucket.receipts.id

  dynamic "lambda_function" {
    for_each = var.lambda_notifications
    content {
      lambda_function_arn = lambda_function.value.function_arn
      events              = lambda_function.value.events
      filter_prefix       = lambda_function.value.filter_prefix
      filter_suffix       = lambda_function.value.filter_suffix
    }
  }

  depends_on = [aws_lambda_permission.s3_invoke_lambda]
}

# Lambda permission for S3 notifications
resource "aws_lambda_permission" "s3_invoke_lambda" {
  count         = var.enable_notifications ? length(var.lambda_notifications) : 0
  statement_id  = "AllowExecutionFromS3Bucket-${count.index}"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_notifications[count.index].function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.receipts.arn
}

# S3 Bucket policy for Lambda access
resource "aws_s3_bucket_policy" "receipts_policy" {
  bucket = aws_s3_bucket.receipts.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowLambdaAccess"
        Effect = "Allow"
        Principal = {
          AWS = var.lambda_role_arn != null ? var.lambda_role_arn : "*"
        }
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = "${aws_s3_bucket.receipts.arn}/*"
      }
    ]
  })
}
