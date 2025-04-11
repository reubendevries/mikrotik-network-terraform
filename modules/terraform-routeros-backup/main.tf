# modules/backup/main.tf
# S3 Bucket for backups
resource "aws_s3_bucket" "mikrotik_backups" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_versioning" "backup_versioning" {
  bucket = aws_s3_bucket.mikrotik_backups.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Lifecycle policy for backup retention
resource "aws_s3_bucket_lifecycle_configuration" "backup_lifecycle" {
  bucket = aws_s3_bucket.mikrotik_backups.id

  rule {
    id     = "backup-retention"
    status = "Enabled"

    expiration {
      days = var.retention_days
    }
  }
}

# Backup scripts for each router
resource "routeros_system_script" "backup_script" {
  for_each = var.routers
  
  name = "backup-${each.value.name}"
  owner = "admin"
  policy = ["ftp,read,write,policy,password"]
  source = templatefile("${path.module}/templates/backup-script.tpl", {
    router_name = each.value.name
    bucket_name = aws_s3_bucket.mikrotik_backups.id
    region      = var.aws_region
  })
}

# Scheduler for automated backups
resource "routeros_system_scheduler" "backup_scheduler" {
  for_each = var.routers
  
  name     = "schedule-backup-${each.value.name}"
  start_date = "Jan/01/2000"
  start_time = "00:00:00"
  interval   = "24h"
  on_event   = "/system script run backup-${each.value.name}"
  policy     = ["ftp,read,write,policy,password"]
}

# Export configuration backup script
resource "routeros_system_script" "export_config" {
  for_each = var.routers
  
  name = "export-config-${each.value.name}"
  owner = "admin"
  policy = ["ftp,read,write,policy,password"]
  source = templatefile("${path.module}/templates/export-config.tpl", {
    router_name = each.value.name
  })
}

# Pre-backup script to verify system state
resource "routeros_system_script" "pre_backup_check" {
  for_each = var.routers
  
  name = "pre-backup-check-${each.value.name}"
  owner = "admin"
  policy = ["ftp,read,write,policy,password"]
  source = templatefile("${path.module}/templates/pre-backup-check.tpl", {
    router_name = each.value.name
  })
}

# Post-backup verification script
resource "routeros_system_script" "verify_backup" {
  for_each = var.routers
  
  name = "verify-backup-${each.value.name}"
  owner = "admin"
  policy = ["ftp,read,write,policy,password"]
  source = templatefile("${path.module}/templates/verify-backup.tpl", {
    router_name = each.value.name
  })
}

# Email notification for backup status
resource "routeros_system_script" "backup_notification" {
  for_each = var.routers
  
  name = "backup-notification-${each.value.name}"
  owner = "admin"
  policy = ["ftp,read,write,policy,password"]
  source = templatefile("${path.module}/templates/backup-notification.tpl", {
    router_name = each.value.name
  })
}
