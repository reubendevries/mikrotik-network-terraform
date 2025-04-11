# modules/firewall/variables.tf
variable "network_segments" {
  description = "Network segment configurations"
  type = map(object({
    vlan_id = number
    network = string
    wifi_enabled = bool
    ethernet_only = bool
    purpose = string
  }))
}

variable "printer_ip" {
  description = "IP address of the network printer"
  type = string
}

variable "server_networks" {
  description = "List of server network ranges"
  type = list(string)
}

variable "wifi_networks" {
  description = "WiFi network configurations"
  type = map(string)
}

variable "management_ports" {
  description = "Ports allowed for management access"
  type = list(string)
  default = ["22", "443", "8291"]  # Common management ports
}

variable "rate_limit_connections" {
  description = "Maximum number of connections for rate limiting"
  type = number
  default = 30
}
