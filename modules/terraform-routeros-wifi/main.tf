# modules/wifi/main.tf
# CAPsMAN base configuration
resource "routeros_caps_manager" "main" {
  enabled            = true
  upgrade_policy     = "suggest-same-version"
  certificate        = "auto"
  package_path      = "system"
  lock_to_caps_only = true
}

# Channel configuration
resource "routeros_caps_manager_channel" "wifi_channels" {
  name              = "main-channels"
  band              = "2ghz-b/g/n,5ghz-a/n/ac"
  extension_channel = "Ce"
  width             = "20/40/80mhz"
  tx_power         = "20"
  save             = true
}

# Security configurations
resource "routeros_caps_manager_security" "wifi_security" {
  for_each = {
    home  = var.wifi_passwords["home"]
    guest = var.wifi_passwords["guest"]
    iot   = var.wifi_passwords["iot"]
  }
  
  name                 = "${each.key}-security"
  authentication_types = "wpa2-psk"
  encryption          = "aes-ccm"
  passphrase          = each.value
  save                = true
}

# WiFi configurations for allowed networks
resource "routeros_caps_manager_configuration" "wifi_networks" {
  for_each = local.wifi_networks
  
  name              = "${each.key}-wifi"
  channel           = routeros_caps_manager_channel.wifi_channels.name
  security          = routeros_caps_manager_security[each.key].name
  ssid              = local.security_configs[each.key].ssid
  vlan_id          = each.value.vlan_id
  vlan_mode        = "use-tag"
  country          = "canada"
  installation     = "indoor"
  rx_chains        = 4
  tx_chains        = 4
  save             = true
}

# CAP AX device registration
resource "routeros_caps_manager_access_list" "cap_ax_devices" {
  count            = length(var.cap_ax_macs)
  
  interface_pattern = "all"
  action           = "accept"
  comment          = "CAP AX ${count.index + 1}"
  mac_address      = var.cap_ax_macs[count.index]
  master_interface = var.bridge_name
}
