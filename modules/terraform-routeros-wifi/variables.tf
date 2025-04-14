# modules/wifi/variables.tf
variable "network_segments" {
  description = "Network segment configurations"
  type = map(object({
    vlan_id = number
    network = string
    wifi_enabled = bool
    ethernet_only = bool
  }))
}

variable "bridge_name" {
  description = "Name of the main bridge interface"
  type        = string
}

variable "wifi_passwords" {
  description = "Passwords for WiFi networks"
  type = map(string)
  sensitive = true
}

variable "cap_ax_macs" {
  description = "MAC addresses of CAP AX devices"
  type = list(string)
}
