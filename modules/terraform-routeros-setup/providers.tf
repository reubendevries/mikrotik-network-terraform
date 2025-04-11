# providers.tf
terraform {
  required_providers {
    routeros = {
      source  = "terraform-routeros/routeros"
      version = "1.81.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "routeros" {
  hosturl  = data.aws_secretsmanager_secret_version.router_ip.secret_string
  username = data.aws_secretsmanager_secret_version.router_username.secret_string
  password = data.aws_secretsmanager_secret_version.router_password.secret_string
}
