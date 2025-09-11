# Outputs del bucket S3 para artefactos
output "bucket_id" {
  description = "ID del bucket S3"
  value       = aws_s3_bucket.artifacts.id
}

output "bucket_arn" {
  description = "ARN del bucket S3"
  value       = aws_s3_bucket.artifacts.arn
}

output "bucket_name" {
  description = "Nombre del bucket S3"
  value       = aws_s3_bucket.artifacts.bucket
}

output "bucket_domain_name" {
  description = "Nombre de dominio del bucket S3"
  value       = aws_s3_bucket.artifacts.bucket_domain_name
}

output "bucket_region" {
  description = "Región del bucket S3"
  value       = aws_s3_bucket.artifacts.region
}
