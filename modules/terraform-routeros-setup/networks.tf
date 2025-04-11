resource "routeros_interface_vlan" "vlan" {
	for_each = local.vlan_configs

	name = each.key
	vlan_id = each.value.vlan_id
	interface = each.value.interface
}

resource "routeros_ip_address" "dmz_network" {
	for_each = local.vlan_configs

	address    = each.value.ip_address
	interface  = each.value.name
	network    = each.value.network

}