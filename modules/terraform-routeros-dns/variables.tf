variable "network_devices" {
  description = "Map of network devices and their DNS configurations"
  type = map(object({
    ip          = string
    name        = string
    comment     = string
    is_dns_server = bool
  }))
  default = {
    gateway = {
      ip            = "192.168.20.1"
      name          = "gateway"
      comment       = "Gateway Router CRS326"
      is_dns_server = true
    }
    core = {
      ip            = "192.168.20.2"
      name          = "core"
      comment       = "Core Router CCR2004"
      is_dns_server = false
    }
    access = {
      ip            = "192.168.20.3"
      name          = "access"
      comment       = "Access Switch CRS328"
      is_dns_server = false
    }
  }
}

variable "domain_name" {
  description = "Local domain name for internal network"
  type        = string
  default     = "local"
}

variable "external_dns_servers" {
  description = "List of external DNS servers"
  type        = list(string)
  default     = ["1.1.1.1", "8.8.8.8"]
}

variable "network_segments" {
  description = "Network segment configurations"
  type = map(object({
    vlan_id      = number
    network      = string
    wifi_enabled = bool
    ethernet_only = bool
    purpose      = string
  }))
}

variable "allow_remote_requests" {
  description = "Allow remote DNS requests"
  type        = bool
  default     = true
}

variable "dns_ttl" {
  description = "TTL for DNS records"
  type        = string
  default     = "1d"
}
