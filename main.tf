module terraform-aws-setup {
	source = "./modules/terraform-aws-setup"
	project = var.project
}

module terraform-aws-state {
	source = "./modules/terraform-aws-state"
	project = var.project
}