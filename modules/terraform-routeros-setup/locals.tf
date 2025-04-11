locals {
	crs326_ip = var.crs326_ip
	crs326_username = var.crs326_username
	crs326_password = var.crs326_password
	vlan_configs = {

		"dmz" = {
			vlan_id = 10
			interface = "bridge1"
			address  = "192.168.10.1/24"
			network    = "192.168.10.0"
			dhcp_range = "192.168.10.50-192.168.10.225"
		}
		
		"mgmt" = {
			vlan_id = 20
			interface = "bridge1"
			address  = "192.168.20.1/24"
			network    = "192.168.20.0"
			dhcp_range = "192.168.20.50-192.168.20.225"
		}
		
		"home" = {
			vlan_id = 30
			interface = "bridge1"
			address  = "192.168.30.1/24"
			network = "192.168.30.0"
			dhcp_range = "192.168.30.50-192.168.30.225"
		}
		
		"guest" = {
			vlan_id = 40
			interface = "bridge1"
			address  = "192.168.40.1/24"
			network = "192.168.40.0"
			dhcp_range = "192.168.40.50-192.168.40.225"
			
		}
		iot_vlan = {
			vlan_id = 50
			name = "iot"
			interface = "bridge1"
			address  = "192.168.50.1/24"
			network = "192.168.50.0"
			dhcp_range = "192.168.50.50-192.168.50.225"
		}
	}
}
