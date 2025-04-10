data "aws_caller_identity" "current" {}
resource "time_static" created_at {}

locals {
	bucket_name = "mikrotik-network-tf-state-devries-family"
	
	dynamodb_table_name = "terraform-state-lock"

	state_bucket_logging = {
  	enabled = true
  	target_bucket = "miktrotik-network-tf-state-logs"
  	target_prefix = "terraform-state-logs/"
	}

	noncurrent_version_expiration = 90

	trusted_principals = [
  	"arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/terraform-admin",
  	"arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/github-actions-role"
	]
	
	caller_arn = data.aws_caller_identity.current.arn
  
  is_user = can(regex("^arn:aws:iam::[0-9]{12}:user/", local.caller_arn))
	
	caller_name = local.is_user ? split("/", local.caller_arn)[1] : "terraform-admin"
	
	
	mfa_delete_enabled = true

	tags = {
		"Project" = "${var.project}"
		"Owner" = local.caller_name
		"Created At" = formatdate("YYYY-MM-DD", time_static.created_at.rfc3339)
		"Managed By" = "Terraform"
	}

	role_name = "terraform-state-management-role"
	policy_name_prefix = "tf-state"
}