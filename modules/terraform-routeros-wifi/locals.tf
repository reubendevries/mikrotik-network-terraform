# modules/wifi/locals.tf
data "aws_secretsmanager_secret" "wifi_passwords" {
  name = "mikrotik/devries-family-network/wifi-passwords"
}

data "aws_secretsmanager_secret_version" "wifi_passwords" {
  secret_id = data.aws_secretsmanager_secret.wifi_passwords.id
}

locals {
  # WiFi-specific calculations or transformations
  wifi_networks = {
    for k, v in var.network_segments :
    k => v if v.wifi_enabled && !v.ethernet_only
  }
  
  security_configs = {
    home  = { ssid = "home", password_key = "home_wifi_password" }
    guest = { ssid = "guest", password_key = "guest_wifi_password" }
    iot   = { ssid = "guest", password_key = "iot_wifi_password" }
  }

  wifi_passwords = jsondecode(data.aws_secretsmanager_secret_version.wifi_passwords.secret_string)
}
