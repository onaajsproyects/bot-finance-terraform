# S3 Bucket for storing receipts/boletas
resource "aws_s3_bucket" "receipts" {
  bucket = "${var.project_name}-${var.environment}-receipts"

  tags = merge(var.tags, {
    Name    = "${var.project_name}-${var.environment}-receipts"
    Type    = "S3"
    Purpose = "Receipts Storage"
  })
}
