# Parámetros SSM esenciales para bot finance
resource "aws_ssm_parameter" "telegram_token" {
  count     = var.telegram_token != "" ? 1 : 0
  name      = "/${var.organizacion}-${var.proyecto}-${var.ambiente}/telegram/token"
  type      = "SecureString"
  value     = var.telegram_token
  overwrite = true

  description = "Telegram Bot Token"

  tags = local.tags
}