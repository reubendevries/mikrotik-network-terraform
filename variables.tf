variable "project" {
	type = string
	description = "The project name"
}

variable "aws_region" {
	type = string
  description = "AWS region"
  default     = "ca-west-1"
}

variable "environment" {
  type        = string
  description = "Environment name"
  default     = "production"
}

variable "routeros_host" {
  type        = string
  description = "The Router OS host"
}

variable "routeros_username" {
	type        = string
	description = "The Router OS username"
}

variable "routeros_password" {
	type        = string
  description = "The Router OS password"
}

variable "cap_ax_macs" {
	type = list(string)
	description = "List of allowed MAC addresses"
}

variable "email_address" {
	type = string
	description = "email address for monitoring alerts"
}