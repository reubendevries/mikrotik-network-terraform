data "aws_caller_identity" "current" {}
resource "time_static" created_at {}

locals {
	caller_arn = data.aws_caller_identity.current.arn
  
  is_user = can(regex("^arn:aws:iam::[0-9]{12}:user/", local.caller_arn))
  
  caller_name = local.is_user ? split("/", local.caller_arn)[1] : "terraform-admin"
	
	tags = {
		
		"Project" = "${var.project}"
		"Owner" = local.caller_name
		"Created At" = formatdate("YYYY-MM-DD", time_static.created_at.rfc3339)
		"Managed By" = "Terraform"
	}
}