variable "project" {
  type        = string
  description = "The project name"
}

variable "aws_region" {
  type        = string
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
  sensitive   = true
}


variable "email_address" {
  type        = string
  description = "email address for monitoring alerts"
}

variable "network_segments" {
  description = "Network segments configuration"
  type        = string
}

variable "bridge_name" {
  description = "Bridge names from the network module"
  type        = string
}

variable "wifi_passwords" {
  description = "Passwords for different WiFi networks"
  type = object({
    home_wifi_password  = string
    guest_wifi_password = string
    iot_wifi_password   = string
  })
  sensitive = true # Mark as sensitive since these are passwords
}

variable "cap_ax_macs" {
  description = "MAC addresses for CAP AX devices"
  type        = list(string) # Assuming this is a list of MAC addresses
}