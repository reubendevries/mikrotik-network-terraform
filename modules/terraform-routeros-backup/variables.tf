# modules/backup/variables.tf
variable "bucket_name" {
  description = "Name of the S3 bucket for backups"
  type        = string
}

variable "aws_region" {
  description = "AWS region for the backup bucket"
  type        = string
}

variable "routers" {
  description = "Router configurations"
  type = map(object({
    name = string
    ip = string
    model = string
  }))
  default = {
    gateway = {
      name = "CRS326"
      ip = "192.168.20.1"
      model = "CRS326-24G-2S+RM"
    }
    core = {
      name = "CCR2004"
      ip = "192.168.20.2"
      model = "CCR2004-16G-2S"
    }
    access = {
      name = "CRS328"
      ip = "192.168.20.3"
      model = "CRS328-24P-4S+"
    }
  }
}

variable "backup_schedule" {
  description = "Backup schedule in cron format"
  type = string
  default = "0 0 * * *"  # Daily at midnight
}

variable "retention_days" {
  description = "Number of days to retain backups"
  type = number
  default = 30
}
