# modules/wifi/locals.tf
data "aws_secretsmanager_secret" "wifi_passwords" {
  name = "mikrotik/devries-family-network/wifi_passwords"
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
    home  = { ssid = "Home-Network", password_key = "home" }
    guest = { ssid = "Guest-Network", password_key = "guest" }
    iot   = { ssid = "IoT-Network", password_key = "iot" }
  }

  wifi_passwords = jsondecode(data.aws_secretsmanager_secret_version.wifi_passwords.secret_string)
}
