# modules/network/outputs.tf
output "bridge_names" {
  description = "Names of all bridge interfaces"
  value = {
    crs326  = routeros_interface_bridge.crs326_bridge.name
    ccr2004 = routeros_interface_bridge.ccr2004_bridge.name
    crs328  = routeros_interface_bridge.crs328_bridge.name
  }
}

output "vlan_interfaces" {
  description = "VLAN interface configurations"
  value = {
    crs326  = { for k, v in routeros_interface_vlan.crs326_vlans : k => v.name }
    ccr2004 = { for k, v in routeros_interface_vlan.ccr2004_vlans : k => v.name }
    crs328  = { for k, v in routeros_interface_vlan.crs328_vlans : k => v.name }
  }
}

output "dhcp_servers" {
  description = "DHCP server configurations"
  value = {
    for k, v in routeros_ip_dhcp_server.vlan_dhcp : k => v.name
  }
}
