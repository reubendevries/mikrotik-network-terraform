# modules/firewall/outputs.tf
output "firewall_rules" {
  description = "Created firewall rules"
  value = {
    dmz_rules = {
      internet = routeros_ip_firewall_filter.dmz_internet.id
      isolation = routeros_ip_firewall_filter.dmz_isolation.id
    }
    management_rules = {
      devices = routeros_ip_firewall_filter.mgmt_to_devices.id
      internet = routeros_ip_firewall_filter.mgmt_internet.id
    }
    home_rules = {
      internet = routeros_ip_firewall_filter.home_internet.id
      servers = routeros_ip_firewall_filter.home_to_servers.id
      printer = routeros_ip_firewall_filter.home_to_printer.id
    }
    guest_rules = {
      internet = routeros_ip_firewall_filter.guest_internet.id
      printer = routeros_ip_firewall_filter.guest_to_printer.id
      isolation = routeros_ip_firewall_filter.guest_isolation.id
    }
    iot_rules = {
      internet = routeros_ip_firewall_filter.iot_internet.id
      isolation = routeros_ip_firewall_filter.iot_isolation.id
    }
  }
}
