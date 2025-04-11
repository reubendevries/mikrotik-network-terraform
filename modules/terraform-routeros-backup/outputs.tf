# modules/backup/outputs.tf
output "backup_bucket" {
  description = "Backup bucket details"
  value = {
    name = aws_s3_bucket.mikrotik_backups.id
    arn  = aws_s3_bucket.mikrotik_backups.arn
  }
}

output "backup_scripts" {
  description = "Created backup scripts"
  value = {
    for k, v in routeros_system_script.backup_script : k => v.name
  }
}
