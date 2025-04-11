# modules/dns/outputs.tf
output "dns_servers" {
  description = "List of configured DNS servers"
  value = [
    for device in var.network_devices :
    "${device.name}.${var.domain_name}" if device.is_dns_server
  ]
}

output "dns_records" {
  description = "Map of configured DNS records"
  value = {
    for name, device in var.network_devices :
    name => "${device.name}.${var.domain_name}"
  }
}

output "primary_dns_server" {
  description = "Primary DNS server IP"
  value = var.network_devices["gateway"].ip
}
