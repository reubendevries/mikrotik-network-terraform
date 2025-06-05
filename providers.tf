terraform {
  backend "s3" {
    bucket       = "mikrotik-network-tf-state-devries-family"
    key          = "mikrotik/terraform.tfstate"
    region       = "ca-west-1"
    encrypt      = true
    use_lockfile = true
  }

  required_providers {
    routeros = {
      source  = "terraform-routeros/routeros"
      version = "1.81.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "5.94.1"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.9.1"
    }
  }
}

provider "routeros" {
  # Provider configuration
  hosturl  = var.routeros_host
  username = var.routeros_username
  password = var.routeros_password
  insecure = true # Set to false in production if using valid SSL
}