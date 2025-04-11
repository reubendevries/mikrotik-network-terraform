# modules/wifi/outputs.tf
output "wifi_networks" {
  description = "Configured WiFi networks"
  value = {
    home_network  = routeros_caps_manager_configuration.home-wifi.name
    guest_network = routeros_caps_manager_configuration.guest-config.name
    iot_network   = routeros_caps_manager_configuration.iot-config.name
  }
}
