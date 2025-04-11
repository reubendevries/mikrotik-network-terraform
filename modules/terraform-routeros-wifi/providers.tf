# modules/firewall/versions.tf
terraform {
  required_providers {
    routeros = {
      source  = "terraform-routeros/routeros"
      version = ">= 1.0.0"
    }
  }
}
