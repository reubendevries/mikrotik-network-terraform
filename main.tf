module terraform-aws-setup {
	source = "./modules/terraform-aws-setup"
	project = var.project
}

module terraform-aws-state {
	source = "./modules/terraform-aws-state"
	
	project = var.project
}

module "terraform-routeros-dns" {
  source = "./modules/terraform-routeros-dns"
  
  network_devices = {
    gateway = {
      ip            = "192.168.20.1"
      name          = "gateway"
      comment       = "Gateway Router CRS326"
      is_dns_server = true
    }
    core = {
      ip            = "192.168.20.2"
      name          = "core"
      comment       = "Core Router CCR2004"
      is_dns_server = false
    }
    access = {
      ip            = "192.168.20.3"
      name          = "access"
      comment       = "Access Switch CRS328"
      is_dns_server = false
    }
  }

  network_segments = local.network_segments
  domain_name     = "devriesfamily.lan"  # Or your preferred domain
  
  external_dns_servers = [
    "1.1.1.1",  # Cloudflare
    "8.8.8.8"   # Google
  ]
}

module "terraform-routeros-network" {
  source = "./modules/terraform-routeros-network"
  
  network_segments = local.network_segments
  telus_wan_interface = "ether1"
  
  # Optionally override default SFP port configurations
  crs326_sfp_ports = {
    sfp_plus1 = "sfp-sfpplus1"
    sfp_plus2 = "sfp-sfpplus2"
  }
}

module "terraform-routeros-wifi" {
  source = "./modules/terraform-routeros-wifi"
  
  network_segments = local.network_segments
  bridge_name     = module.terraform-routeros-network.bridge_names
  wifi_passwords  = {
    home_wifi_password  = data.aws_secretsmanager_secret_version.home_wifi_password.secret_string
    guest_wifi_password = data.aws_secretsmanager_secret_version.guest_wifi_password.secret_string
    iot_wifi_password   = data.aws_secretsmanager_secret_version.iot_wifi_password.secret_string
  }
  cap_ax_macs    = var.cap_ax_macs
}

module "terraform-routeros-firewall" {
  source = "./modules/terraform-routeros-firewall"
  
  network_segments = local.network_segments
  printer_ip = "192.168.30.100"
  server_networks = ["192.168.30.0/24"]
  wifi_networks = module.wifi.wifi_networks
}


module "terraform-routeros-backup" {
  source = "./modules/terraform-routeros-backup"
  
  bucket_name = local.backup_bucket_name
  aws_region = var.aws_region
}

module "terraform-routeros-monitoring" {
  source = "./modules/terraform-routeros-monitoring"
  
  network_segments = local.network_segments
  log_bucket_name = local.log_bucket_name
  alert_email     = var.email_address
}