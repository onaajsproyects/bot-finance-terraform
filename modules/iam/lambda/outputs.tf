# Outputs del rol IAM para Lambda
output "lambda_execution_role_arn" {
  description = "ARN del rol de ejecución de Lambda"
  value       = aws_iam_role.lambda_execution_role.arn
}

output "lambda_execution_role_name" {
  description = "Nombre del rol de ejecución de Lambda"
  value       = aws_iam_role.lambda_execution_role.name
}
