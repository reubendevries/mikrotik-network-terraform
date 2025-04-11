# modules/monitoring/main.tf
# S3 Bucket for Logs
resource "aws_s3_bucket" "mikrotik_logs" {
  bucket = var.log_bucket_name
}

resource "aws_s3_bucket_versioning" "logs_versioning" {
  bucket = aws_s3_bucket.mikrotik_logs.id
  versioning_configuration {
    status = "Enabled"
  }
}

# CloudWatch Log Groups
resource "aws_cloudwatch_log_group" "router_logs" {
  for_each = var.routers
  
  name              = "/mikrotik/${each.value.name}"
  retention_in_days = 30
}

# Router System Logging
resource "routeros_system_logging" "router_logging" {
  for_each = var.routers
  
  action    = "remote"
  remote    = "${aws_s3_bucket.mikrotik_logs.id}.s3.amazonaws.com"
  topics    = "critical,error,warning,info"
  prefix    = "${each.value.name}-audit"
}

# Interface Traffic Monitoring
resource "routeros_interface_monitor" "interface_traffic" {
  for_each = var.routers
  
  interface = "*"
  name      = "${each.value.name}-traffic"
}

# Health Monitoring
resource "routeros_system_health" "router_health" {
  for_each = var.routers
  
  name     = "${each.value.name}-health"
  interval = "1m"
}

# SNMP Configuration
resource "routeros_snmp" "router_snmp" {
  for_each = var.routers
  
  enabled        = true
  contact        = var.alert_email
  location       = "Network Core"
  trap_community = "private"
  trap_version   = 2
}

# Network Monitoring Tools
resource "routeros_tool_netwatch" "router_watch" {
  for_each = var.routers
  
  host     = each.value.ip
  interval = "30s"
  timeout  = "5s"
  up_script = <<-EOT
    :log info "Router ${each.value.name} is UP"
  EOT
  down_script = <<-EOT
    :log error "Router ${each.value.name} is DOWN"
    /tool e-mail send to="${var.alert_email}" subject="Router ${each.value.name} DOWN" body="Router ${each.value.name} is not responding"
  EOT
}

# WiFi Monitoring
resource "routeros_caps_manager_monitor" "wifi_monitor" {
  name     = "wifi-monitor"
  interval = "1m"
}

# VLAN Traffic Monitoring
resource "routeros_interface_monitor" "vlan_traffic" {
  for_each = var.network_segments
  
  interface = "vlan-${each.key}"
  name      = "vlan-${each.key}-traffic"
}

# CloudWatch Alarms
resource "aws_cloudwatch_metric_alarm" "router_health" {
  for_each = var.routers
  
  alarm_name          = "${each.value.name}-health"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name        = "StatusCheckFailed"
  namespace          = "MikrotikHealth"
  period             = "300"
  statistic          = "Maximum"
  threshold          = "0"
  alarm_description  = "Monitor router health status"
  alarm_actions      = [aws_sns_topic.router_alerts.arn]
}

# SNS Topic for Alerts
resource "aws_sns_topic" "router_alerts" {
  name = "mikrotik-alerts"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.router_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# Bandwidth Monitoring
resource "routeros_queue_simple" "bandwidth_monitor" {
  for_each = var.network_segments
  
  name      = "monitor-${each.key}"
  target    = each.value.network
  max_limit = "0/0"  # Monitor only, no limiting
}

# Syslog Configuration
resource "routeros_system_logging" "syslog" {
  for_each = var.routers
  
  action    = "disk"
  topics    = "system,critical,error,warning,info"
  prefix    = each.value.name
}

# Traffic Flow Monitoring
resource "routeros_ip_traffic_flow" "netflow" {
  enabled           = true
  interfaces        = "*"
  cache_entries     = 16384
  active_flow_timeout = "5m"
}

# Dashboard Script
resource "routeros_system_script" "monitoring_dashboard" {
  name   = "generate-dashboard"
  owner  = "admin"
  policy = ["read", "write", "policy", "test"]
  source = <<-EOT
    :local cpuLoad [/system resource get cpu-load]
    :local memoryUsed [/system resource get free-memory]
    :local uptime [/system resource get uptime]
    
    :log info "System Status Report"
    :log info "CPU Load: $cpuLoad%"
    :log info "Memory Used: $memoryUsed"
    :log info "Uptime: $uptime"
  EOT
}
