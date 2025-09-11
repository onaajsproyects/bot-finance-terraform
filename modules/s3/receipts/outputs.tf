# Outputs del bucket S3 para recibos
output "bucket_id" {
  description = "ID del bucket S3"
  value       = aws_s3_bucket.receipts.id
}

output "bucket_arn" {
  description = "ARN del bucket S3"
  value       = aws_s3_bucket.receipts.arn
}

output "bucket_name" {
  description = "Nombre del bucket S3"
  value       = aws_s3_bucket.receipts.bucket
}

output "bucket_domain_name" {
  description = "Nombre de dominio del bucket S3"
  value       = aws_s3_bucket.receipts.bucket_domain_name
}

output "bucket_region" {
  description = "Región del bucket S3"
  value       = aws_s3_bucket.receipts.region
}
