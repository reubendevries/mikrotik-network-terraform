resource "routeros_caps_manager" "main" {
  enabled            = true
  upgrade_policy     = "suggest-same-version"
  certificate        = "auto"
  package_path      = "system"
  lock_to_caps_only = true
}

resource "routeros_caps_manager_channel" "wifi_channels" {
  name              = "main-channels"
  band              = "2ghz-b/g/n,5ghz-a/n/ac"
  extension_channel = "Ce"
  width             = "20/40/80mhz"
  tx_power         = "20"
  save             = true
}

# Create security profiles for each network
resource "routeros_interface_wireless_security" "wifi_security" {
  for_each = local.wifi_networks

  name              = "security-${each.key}"
  authentication-types = ["wpa2-psk"]
  wpa2-pre-shared-key = local.wifi_passwords[local.security_configs[each.key].password_key]
  mode               = "dynamic-keys"
}
# Create WiFi configurations for each network
resource "routeros_interface_wireless" "wifi_networks" {
  for_each = local.wifi_networks

  name           = "wifi-${each.key}"
  mode          = "ap-bridge"
  ssid          = local.security_configs[each.key].ssid
  frequency     = "2412-2472"
  band          = "2ghz-b/g/n"
  channel_width = "20/40mhz-Ce"
  security_profile = "security-${each.key}"
  disabled      = false
}

resource "routeros_caps_manager_access_list" "cap_ax_devices" {
  count            = length(var.cap_ax_macs)
  
  interface_pattern = "all"
  action           = "accept"
  comment          = "CAP AX ${count.index + 1}"
  mac_address      = var.cap_ax_macs[count.index]
  master_interface = var.bridge_name
}
