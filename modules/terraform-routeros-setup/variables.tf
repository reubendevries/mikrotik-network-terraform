# variables.tf
variable "aws_region" {
	type = string
  description = "AWS region"
  default     = "ca-west-1"
}

variable "crs326_ip" {
	type = string
	description = "The IP address to the crs326"
} 

variable "crs326_username" {
	type = string
	description = "The username to the crs326"
}

variable "crs326_password" {
	type = string
	description = "The password to the crs326"
}
