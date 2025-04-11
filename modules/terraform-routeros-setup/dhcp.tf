# dhcp.tf
resource "routeros_ip_dhcp_server" "dhcp_server" {
	for_each = local.vlan_configs

	name = format("dhcp-%s", each.key)
	interface = format("%s", each.key)
	lease_time = "1d"
	address_pool = format("%s_pool", each.key)
}

resource "routeros_ip_pool" "ip_pool" {
  for_each = local.vlan_configs

	name    = format("%s_pool", each.key)
  ranges  = [each.value.dhcp_range]
}
