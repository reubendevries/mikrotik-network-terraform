resource "routeros_ip_firewall_filter" "established" {
  chain            = "forward"
  connection_state = "established,related"
  action           = "accept"
  comment          = "Allow established connections"
}

# DMZ Rules
resource "routeros_ip_firewall_filter" "dmz_internet" {
  chain         = "forward"
  src_address   = var.network_segments.dmz.network
  out_interface = "ether1" # WAN interface
  action        = "accept"
  comment       = "DMZ to Internet"
}

resource "routeros_ip_firewall_filter" "dmz_isolation" {
  chain       = "forward"
  src_address = var.network_segments.dmz.network
  dst_address = join(",", [
    for k, v in var.network_segments : v.network if k != "dmz"
  ])
  action  = "drop"
  comment = "Block DMZ access to other networks"
}

# Management Network Rules
resource "routeros_ip_firewall_filter" "mgmt_to_devices" {
  chain       = "forward"
  src_address = var.network_segments.management.network
  protocol    = "tcp"
  dst_port    = "22,23,80,443,8291" # Common management ports
  action      = "accept"
  comment     = "Management access to network devices"
}

resource "routeros_ip_firewall_filter" "mgmt_internet" {
  chain         = "forward"
  src_address   = var.network_segments.management.network
  out_interface = "ether1"
  in_interface  = "!${var.wifi_networks["management"]}"
  action        = "accept"
  comment       = "Management to Internet (ethernet only)"
}

# Home Network Rules
resource "routeros_ip_firewall_filter" "home_internet" {
  chain         = "forward"
  src_address   = var.network_segments.home.network
  out_interface = "ether1"
  action        = "accept"
  comment       = "Home to Internet"
}

resource "routeros_ip_firewall_filter" "home_to_servers" {
  chain       = "forward"
  src_address = var.network_segments.home.network
  dst_address = join(",", var.server_networks)
  action      = "accept"
  comment     = "Home to Servers"
}

resource "routeros_ip_firewall_filter" "home_to_printer" {
  chain       = "forward"
  src_address = var.network_segments.home.network
  dst_address = var.printer_ip
  action      = "accept"
  comment     = "Home to Printer"
}

# Guest Network Rules
resource "routeros_ip_firewall_filter" "guest_internet" {
  chain         = "forward"
  src_address   = var.network_segments.guest.network
  out_interface = "ether1"
  in_interface  = var.wifi_networks["guest"]
  action        = "accept"
  comment       = "Guest to Internet (WiFi only)"
}

resource "routeros_ip_firewall_filter" "guest_to_printer" {
  chain       = "forward"
  src_address = var.network_segments.guest.network
  dst_address = var.printer_ip
  action      = "accept"
  comment     = "Guest to Printer"
}

resource "routeros_ip_firewall_filter" "guest_isolation" {
  chain       = "forward"
  src_address = var.network_segments.guest.network
  dst_address = join(",", [
    for k, v in var.network_segments : v.network if k != "guest"
  ])
  dst_address_list = "!${var.printer_ip}"
  action           = "drop"
  comment          = "Block Guest access to other networks except printer"
}

# IoT Network Rules
resource "routeros_ip_firewall_filter" "iot_internet" {
  chain         = "forward"
  src_address   = var.network_segments.iot.network
  out_interface = "ether1"
  in_interface  = var.wifi_networks["iot"]
  action        = "accept"
  comment       = "IoT to Internet (WiFi only)"
}

resource "routeros_ip_firewall_filter" "iot_isolation" {
  chain       = "forward"
  src_address = var.network_segments.iot.network
  dst_address = join(",", [
    for k, v in var.network_segments : v.network if k != "iot"
  ])
  action  = "drop"
  comment = "Block IoT access to other networks"
}

# NAT Rules
resource "routeros_ip_firewall_nat" "masquerade" {
  chain         = "srcnat"
  out_interface = "ether1"
  action        = "masquerade"
  comment       = "NAT for Internet access"
}

# Address Lists for Additional Security
resource "routeros_ip_firewall_address_list" "management_devices" {
  list = "management_devices"
  address = join(",", [
    "192.168.20.1/32", # CRS326
    "192.168.20.2/32", # CCR2004
    "192.168.20.3/32"  # CRS328
  ])
  comment = "Network management devices"
}

# Layer 7 Protocol Filtering
resource "routeros_ip_firewall_layer7_protocol" "blocked_protocols" {
  name    = "blocked-protocols"
  regexp  = "^.+(youtube|netflix|spotify).com"
  comment = "Blocked services for guest network"
}

resource "routeros_ip_firewall_filter" "guest_protocol_restriction" {
  chain           = "forward"
  src_address     = var.network_segments.guest.network
  layer7_protocol = routeros_ip_firewall_layer7_protocol.blocked_protocols.name
  action          = "drop"
  comment         = "Block specific protocols for guest network"
}

# modules/firewall/main.tf

# Anti-spoofing protection
resource "routeros_ip_firewall_filter" "anti_spoofing" {
  chain        = "input"
  src_address  = "192.168.0.0/16"
  in_interface = "ether1" # WAN interface
  action       = "drop"
  comment      = "Anti-spoofing protection"
}

# Secure services configuration
resource "routeros_ip_service" "secure_services" {
  for_each = toset(["www-ssl", "api-ssl"])

  numbers     = each.key
  address     = var.network_segments.management.network
  disabled    = false
  certificate = "self-signed" # Replace with your certificate
}

# Additional security measures
resource "routeros_ip_firewall_filter" "block_invalid" {
  chain            = "forward"
  connection_state = "invalid"
  action           = "drop"
  comment          = "Drop invalid connections"
}

resource "routeros_ip_firewall_filter" "block_bogons" {
  chain       = "input"
  src_address = "0.0.0.0/8,127.0.0.0/8,224.0.0.0/3"
  action      = "drop"
  comment     = "Drop bogon addresses"
}

# Rate limiting for management access
resource "routeros_ip_firewall_filter" "management_rate_limit" {
  chain            = "input"
  dst_address      = var.network_segments.management.network
  protocol         = "tcp"
  dst_port         = "22,443"
  connection_limit = "30,32"
  action           = "drop"
  comment          = "Rate limit management access"
}

# Port scan detection
resource "routeros_ip_firewall_filter" "port_scan_detection" {
  chain            = "input"
  protocol         = "tcp"
  tcp_flags        = "syn"
  connection_limit = "30,32"
  action           = "drop"
  comment          = "Drop potential port scans"
}

# Default drop rule (should be last)
resource "routeros_ip_firewall_filter" "default_drop" {
  chain   = "forward"
  action  = "drop"
  comment = "Default drop rule"
}
