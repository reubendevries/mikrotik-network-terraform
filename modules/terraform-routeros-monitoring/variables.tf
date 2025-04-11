# modules/monitoring/variables.tf
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

variable "log_bucket_name" {
  description = "S3 bucket name for logs"
  type = string
}

variable "alert_email" {
  description = "Email address for alerts"
  type = string
  default = "admin@example.com"
}

variable "routers" {
  description = "Router configurations"
  type = map(object({
    name = string
    ip = string
    model = string
  }))
  default = {
    gateway = {
      name = "CRS326"
      ip = "192.168.20.1"
      model = "CRS326-24G-2S+RM"
    }
    core = {
      name = "CCR2004"
      ip = "192.168.20.2"
      model = "CCR2004-16G-2S"
    }
    access = {
      name = "CRS328"
      ip = "192.168.20.3"
      model = "CRS328-24P-4S+"
    }
  }
}
