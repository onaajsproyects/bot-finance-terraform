# Tabla DynamoDB para logs de transacciones - Configuración mínima
resource "aws_dynamodb_table" "logs" {
  name         = local.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "transaction_id"

  attribute {
    name = "transaction_id"
    type = "S"
  }

  # Configuración de TTL para limpieza automática de logs antiguos
  ttl {
    attribute_name = "ttl"
    enabled        = true
  }

  # Configuración de cifrado
  server_side_encryption {
    enabled = true
  }

  tags = local.tags
}

# Locals para naming conventions
locals {
  table_name = "${var.organizacion}-${var.proyecto}-${var.ambiente}-logs"

  tags = {
    Organizacion = var.organizacion
    Proyecto     = var.proyecto
    Ambiente     = var.ambiente
    Region       = var.region
    Name         = local.table_name
    Type         = "DynamoDB"
  }
}
