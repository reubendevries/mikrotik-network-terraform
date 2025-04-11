resource "routeros_ip_firewall_filter" "dmz_internet_only" {
  chain         = "forward"
  src_address   = "192.168.10.0/24"
  dst_address   = "!192.168.10.0/24"
  action        = "accept"
  out_interface = "ether1" # Assuming ether1 is WAN
}

# Management Network Rules
resource "routeros_ip_firewall_filter" "mgmt_device_access" {
  chain       = "forward"
  src_address = "192.168.20.0/24"
  action      = "accept"
}

# Home Network Rules
resource "routeros_ip_firewall_filter" "home_network_access" {
  chain       = "forward"
  src_address = "192.168.30.0/24"
  action      = "accept"
}

# Guest Network Rules
resource "routeros_ip_firewall_filter" "guest_internet_printer" {
  chain       = "forward"
  src_address = "192.168.40.0/24"
  dst_address = "!192.168.0.0/16"
  action      = "accept"
}

# IOT Network Rules
resource "routeros_ip_firewall_filter" "iot_internet_only" {
  chain       = "forward"
  src_address = "192.168.50.0/24"
  dst_address = "!192.168.0.0/16"
  action      = "accept"
}