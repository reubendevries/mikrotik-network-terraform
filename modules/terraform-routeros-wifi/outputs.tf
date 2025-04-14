# modules/wifi/outputs.tf
output "wifi_networks" {
  description = "Configured WiFi networks"
  value = {
    home_network  = routeros_caps_manager_configuration.home-wifi.name
    guest_network = routeros_caps_manager_configuration.guest-wifi.name
    iot_network   = routeros_caps_manager_configuration.iot-wifi.name
  }
}
