# bridge.tf
resource "routeros_interface_bridge" "main_bridge" {
  name = "bridge1"
  protocol_mode = "rstp"
}

resource "routeros_interface_bridge_port" "sfp_ports" {
  bridge    = routeros_interface_bridge.main_bridge.name
  interface = "sfp-sfpplus1" # Adjust interface names as needed
}
