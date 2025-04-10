terraform {
	backend "s3" {
    bucket         = "${var.bucket_name}"
    key            = "mikrotik/terraform.tfstate"
    region         = "${var.region}"
    encrypt        = true
    dynamodb_table = "${var.dynamodb_table_name}"
  }

  required_providers {
    routeros = {
      source = "terraform-routeros/routeros"
      version = "1.81.1"
    }
		aws = {
      source = "hashicorp/aws"
      version = "5.94.1"
    }
		time = {
      source = "hashicorp/time"
      version = "0.9.1"
    }
  }
}