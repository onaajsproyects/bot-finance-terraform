module "lambda" {
  source = "./lambda"

  # Variables del proyecto
  proyecto = var.proyecto
  ambiente = var.ambiente
  region   = var.region

  # Variables específicas de Lambda
  enable_dynamodb_access = var.enable_dynamodb_access
}

