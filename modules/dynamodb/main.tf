module "dynamodb-logs" {
  source = "./dynamodb-logs"

  # Variables del proyecto
  organizacion = var.organizacion
  proyecto     = var.proyecto
  ambiente     = var.ambiente
  region       = var.region
}
