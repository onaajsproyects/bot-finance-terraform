terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.4"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.4"
    }
  }

  # Backend configuration for remote state (recommended for production)
  # Uncomment and configure for production use
  # backend "s3" {
  #   bucket         = "your-terraform-state-bucket"
  #   key            = "bot-finance/prod/terraform.tfstate"
  #   region         = "us-east-1"
  #   encrypt        = true
  #   dynamodb_table = "terraform-state-lock"
  # }
}

provider "aws" {
  region = "us-east-1"

  # Para desarrollo local usar profile, en CI/CD usar variables de entorno
  # profile = "personal"  # Solo para desarrollo local

  default_tags {
    tags = {
      Proyecto  = var.proyecto
      Ambiente  = var.ambiente
      ManagedBy = "terraform"
      Owner     = var.owner
    }
  }
}
