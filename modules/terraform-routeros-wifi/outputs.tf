# modules/wifi/outputs.tf
output "wifi_networks" {
  description = "Configured WiFi networks"
  value = {
    home_network  = routeros_caps_manager_configuration.home-wifi.name
    guest_network = routeros_caps_manager_configuration.guest-wifi.name
    iot_network   = routeros_caps_manager_configuration.iot-wifi.name
  }
}

output "debug_wifi" {
  value = {
    raw_secret = data.aws_secretsmanager_secret_version.wifi_passwords.secret_string
    decoded_passwords = local.wifi_passwords
    security_configs = local.security_configs
    networks = local.wifi_networks
  }
  sensitive = true
}