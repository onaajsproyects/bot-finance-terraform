module "receipts" {
  source = "./receipts"

  # Variables del proyecto
  proyecto = var.proyecto
  ambiente = var.ambiente
  region   = var.region
}

module "artifacts" {
  source = "./artifacts"

  # Variables del proyecto
  proyecto = var.proyecto
  ambiente = var.ambiente
  region   = var.region
}
