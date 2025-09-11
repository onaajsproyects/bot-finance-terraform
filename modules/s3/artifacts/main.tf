locals {
  bucket_name = "${var.organizacion}-${var.proyecto}-${var.ambiente}-artifacts"

  tags = {
    Organizacion = var.organizacion
    Proyecto     = var.proyecto
    Ambiente     = var.ambiente
    Region       = var.region
    Name         = local.bucket_name
    Type         = "S3"
  }
}
# Bucket S3 para almacenar artefactos de despliegue - Configuración mínima
resource "aws_s3_bucket" "artifacts" {
  bucket = local.bucket_name
  tags   = local.tags
}

# Configuración de versionado del bucket
resource "aws_s3_bucket_versioning" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id
  versioning_configuration {
    status = "Enabled"
  }
}
