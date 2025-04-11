module terraform-aws-setup {
	source = "./modules/terraform-aws-setup"
	project = var.project
}

module terraform-aws-state {
	source = "./modules/terraform-aws-state"
	
	project = var.project
}

module terraform-routeros-dmz {
	source = "./modules/terraform-routeros-setup"
	crs326_ip = var.crs326_ip
	crs326_username = var.crs326_username
	crs326_password = var.crs326_password
}