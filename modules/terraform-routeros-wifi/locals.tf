# modules/wifi/locals.tf
locals {
  # WiFi-specific calculations or transformations
  wifi_networks = {
    for k, v in var.network_segments :
    k => v if v.wifi_enabled && !v.ethernet_only
  }
  
  security_configs = {
    home  = { ssid = "Home-Network", password_key = "home" }
    guest = { ssid = "Guest-Network", password_key = "guest" }
    iot   = { ssid = "IoT-Network", password_key = "iot" }
  }
}
