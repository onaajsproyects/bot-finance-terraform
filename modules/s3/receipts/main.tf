locals {
  bucket_name = "${var.proyecto}-${var.ambiente}-receipts"

  tags = {
    Proyecto = var.proyecto
    Ambiente = var.ambiente
    Region   = var.region
    Name     = local.bucket_name
    Type     = "S3"
  }
}

# Bucket S3 para almacenar recibos/boletas - Configuración mínima
resource "aws_s3_bucket" "receipts" {
  bucket = local.bucket_name
  tags   = local.tags
}

# TODO: Configuración de versionado del bucket (comentado temporalmente para deployment rápido)
# resource "aws_s3_bucket_versioning" "receipts" {
#   bucket = aws_s3_bucket.receipts.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }