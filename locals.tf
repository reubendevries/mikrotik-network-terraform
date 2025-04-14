data "aws_caller_identity" "current" {}

locals {
  network_segments = {
    dmz = {
      vlan_id = 10
      network = "192.168.10.0/24"
      wifi_enabled = false    # DMZ - ethernet only
      ethernet_only = true
      purpose = "DMZ Network"
    }
    management = {
      vlan_id = 20
      network = "192.168.20.0/24"
      wifi_enabled = false    # Management - ethernet only
      ethernet_only = true
      purpose = "Management Network"
    }
    home = {
      vlan_id = 30
      network = "192.168.30.0/24"
      wifi_enabled = true     # Home - both WiFi and ethernet
      ethernet_only = false
      purpose = "Home Network"
    }
    guest = {
      vlan_id = 40
      network = "192.168.40.0/24"
      wifi_enabled = true     # Guest - WiFi only
      ethernet_only = false
      purpose = "Guest Network"
    }
    iot = {
      vlan_id = 50
      network = "192.168.50.0/24"
      wifi_enabled = true     # IoT - WiFi only
      ethernet_only = false
      purpose = "IoT Network"
    }
  }
  
  backup_bucket_name = "mikrotik-backups-${data.aws_caller_identity.current.account_id}"
  log_bucket_name = "mikrotik-logs-${data.aws_caller_identity.current.account_id}"
}


