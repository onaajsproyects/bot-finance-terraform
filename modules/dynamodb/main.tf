module "dynamodb-logs" {
  source = "./dynamodb-logs"

  # Variables del proyecto
  proyecto = var.proyecto
  ambiente = var.ambiente
  region   = var.region
}
