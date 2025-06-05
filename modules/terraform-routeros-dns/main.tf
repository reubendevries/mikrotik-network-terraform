# modules/dns/main.tf
# DNS Server Configuration
resource "routeros_ip_dns" "dns_config" {
  for_each = {
    for k, v in var.network_devices : k => v
    if v.is_dns_server
  }

  servers               = var.external_dns_servers
  allow_remote_requests = var.allow_remote_requests
}

# Static DNS Entries for Network Devices
resource "routeros_ip_dns_record" "network_devices" {
  for_each = var.network_devices

  name    = "${each.value.name}.${var.domain_name}"
  address = each.value.ip
  ttl     = var.dns_ttl
  comment = each.value.comment
  type    = "A"
}

# DNS Cache Configuration
resource "routeros_ip_dns" "dns_cache" {
  for_each = {
    for k, v in var.network_devices : k => v
    if v.is_dns_server
  }

  allow_remote_requests = var.allow_remote_requests
  cache_size        = 2048
  cache_max_ttl         = "1w"
}

# DHCP Server DNS Settings
resource "routeros_ip_dhcp_server_network" "network_segments" {
  for_each = var.network_segments

  address    = each.value.network
  dns_server = var.network_devices["gateway"].ip[0]
  gateway    = var.network_devices["gateway"].ip[0]
  domain     = var.domain_name
}

# Reverse DNS Zone Configuration
resource "routeros_ip_dns_record" "reverse_dns" {
  for_each = var.network_devices

  name    = replace(each.value.ip, "/([0-9]+).([0-9]+).([0-9]+).([0-9]+)/", "$4.$3.$2.$1.in-addr.arpa")
  address = "${each.value.name}.${var.domain_name}"
  ttl     = var.dns_ttl
  comment = "Reverse DNS for ${each.value.comment}"
  type    = "CNAME"
}
