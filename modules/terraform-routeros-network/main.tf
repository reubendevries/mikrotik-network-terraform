# modules/network/main.tf
# CRS326 Configuration (Gateway Router)
resource "routeros_interface_bridge" "crs326_bridge" {
  name           = "bridge-crs326"
  protocol_mode  = "rstp"
  comment        = "CRS326 Main Bridge"
}

# Internet input from Telus Router
resource "routeros_interface_bridge_port" "telus_wan" {
  bridge    = routeros_interface_bridge.crs326_bridge.name
  interface = var.telus_wan_interface
  pvid      = 1
  comment   = "WAN from Telus Router"
}

# SFP+ connection to CCR2004
resource "routeros_interface_bridge_port" "crs326_to_ccr2004" {
  bridge    = routeros_interface_bridge.crs326_bridge.name
  interface = var.crs326_sfp_ports.sfp_plus1
  pvid      = 1
  comment   = "Connection to CCR2004"
}

# CCR2004 Configuration (Core Router)
resource "routeros_interface_bridge" "ccr2004_bridge" {
  name           = "bridge-ccr2004"
  protocol_mode  = "rstp"
  comment        = "CCR2004 Main Bridge"
}

# SFP+ connection from CRS326
resource "routeros_interface_bridge_port" "ccr2004_from_crs326" {
  bridge    = routeros_interface_bridge.ccr2004_bridge.name
  interface = var.ccr2004_sfp_ports.sfp_plus1
  pvid      = 1
  comment   = "Connection from CRS326"
}

# SFP+ connection to CRS328
resource "routeros_interface_bridge_port" "ccr2004_to_crs328" {
  bridge    = routeros_interface_bridge.ccr2004_bridge.name
  interface = var.ccr2004_sfp_ports.sfp_plus2
  pvid      = 1
  comment   = "Connection to CRS328"
}

# CRS328 Configuration (Access Switch)
resource "routeros_interface_bridge" "crs328_bridge" {
  name           = "bridge-crs328"
  protocol_mode  = "rstp"
  comment        = "CRS328 Main Bridge"
}

# SFP+ connection from CCR2004
resource "routeros_interface_bridge_port" "crs328_from_ccr2004" {
  bridge    = routeros_interface_bridge.crs328_bridge.name
  interface = var.crs328_sfp_ports.sfp_plus1
  pvid      = 1
  comment   = "Connection from CCR2004"
}

# VLAN Configurations for each router
resource "routeros_interface_vlan" "crs326_vlans" {
  for_each = var.network_segments
  
  name      = "crs326-vlan-${each.key}"
  vlan_id   = each.value.vlan_id
  interface = routeros_interface_bridge.crs326_bridge.name
  comment   = "CRS326 ${each.value.purpose}"
}

resource "routeros_interface_vlan" "ccr2004_vlans" {
  for_each = var.network_segments
  
  name      = "ccr2004-vlan-${each.key}"
  vlan_id   = each.value.vlan_id
  interface = routeros_interface_bridge.ccr2004_bridge.name
  comment   = "CCR2004 ${each.value.purpose}"
}

resource "routeros_interface_vlan" "crs328_vlans" {
  for_each = var.network_segments
  
  name      = "crs328-vlan-${each.key}"
  vlan_id   = each.value.vlan_id
  interface = routeros_interface_bridge.crs328_bridge.name
  comment   = "CRS328 ${each.value.purpose}"
}

# IP Address configurations
resource "routeros_ip_address" "crs326_vlan_addresses" {
  for_each = var.network_segments
  
  address   = cidrhost(each.value.network, 1)
  interface = routeros_interface_vlan.crs326_vlans[each.key].name
  network   = each.value.network
}

resource "routeros_ip_address" "ccr2004_vlan_addresses" {
  for_each = var.network_segments
  
  address   = cidrhost(each.value.network, 2)
  interface = routeros_interface_vlan.ccr2004_vlans[each.key].name
  network   = each.value.network
}

resource "routeros_ip_address" "crs328_vlan_addresses" {
  for_each = var.network_segments
  
  address   = cidrhost(each.value.network, 3)
  interface = routeros_interface_vlan.crs328_vlans[each.key].name
  network   = each.value.network
}

# DHCP Server configurations
resource "routeros_ip_pool" "vlan_pools" {
  for_each = var.network_segments
  
  name    = "pool-${each.key}"
  ranges  = ["${cidrhost(each.value.network, 10)}-${cidrhost(each.value.network, 250)}"]
}

resource "routeros_ip_dhcp_server" "vlan_dhcp" {
  for_each = var.network_segments
  
  name          = "dhcp-${each.key}"
  interface     = routeros_interface_vlan.ccr2004_vlans[each.key].name
  address_pool  = routeros_ip_pool.vlan_pools[each.key].name
  lease_time    = "8h"
}

# DHCP Network configurations
resource "routeros_ip_dhcp_server_network" "vlan_networks" {
  for_each = var.network_segments
  
  address    = each.value.network
  gateway    = cidrhost(each.value.network, 2)
  dns_server = "1.1.1.1,1.0.0.1"
  domain     = "${each.key}.local"
}
