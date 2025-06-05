# modules/network/variables.tf
variable "network_segments" {
  description = "Network segment configurations"
  type = map(object({
    vlan_id = number
    network = string
    wifi_enabled = bool
    ethernet_only = bool
    purpose = string
  }))
	validation {
    condition     = alltrue([for k, v in var.network_segments : v.vlan_id >= 1 && v.vlan_id <= 4094])
    error_message = "VLAN IDs must be between 1 and 4094."
  }
}

variable "telus_wan_interface" {
  description = "Interface connected to Telus router"
  type = string
  default = "ether1"
}

variable "crs326_sfp_ports" {
  description = "SFP+ ports on CRS326"
  type = map(string)
  default = {
    sfp_plus1 = "sfp-sfpplus1"
    sfp_plus2 = "sfp-sfpplus2"
  }
}

variable "ccr2004_sfp_ports" {
  description = "SFP+ ports on CCR2004"
  type = map(string)
  default = {
    sfp_plus1 = "sfp-sfpplus1"
    sfp_plus2 = "sfp-sfpplus2"
  }
}

variable "crs328_sfp_ports" {
  description = "SFP+ ports on CRS328"
  type = map(string)
  default = {
    sfp_plus1 = "sfp-sfpplus1"
    sfp_plus2 = "sfp-sfpplus2"
    sfp_plus3 = "sfp-sfpplus3"
    sfp_plus4 = "sfp-sfpplus4"
  }
}
