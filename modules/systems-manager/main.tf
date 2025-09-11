# Locals para naming conventions
locals {
  tags = {
    Proyecto = var.proyecto
    Ambiente = var.ambiente
    Region   = var.region
    Type     = "SSM"
  }
}

# Parámetros SSM esenciales para bot finance
resource "aws_ssm_parameter" "telegram_token" {
  count     = var.telegram_token != "" ? 1 : 0
  name      = "/${var.proyecto}-${var.ambiente}/telegram/token"
  type      = "SecureString"
  value     = var.telegram_token
  overwrite = true

  description = "Telegram Bot Token"

  tags = local.tags
}