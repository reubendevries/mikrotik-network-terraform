terraform {
  required_providers {
    routeros = {
      source  = "terraform-routeros/routeros"
      version = ">= 1.0.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
}
