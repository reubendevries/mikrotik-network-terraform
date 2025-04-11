:local backupName "${router_name}-$[/system clock get date]-$[/system clock get time]"
:local backupFile ($backupName . ".backup")
:local exportFile ($backupName . ".rsc")

# Run pre-backup check
/system script run pre-backup-check-${router_name}

# Create binary backup
/system backup save name=$backupFile

# Export configuration
/export file=$exportFile

# Upload to S3
/tool fetch url="s3://${bucket_name}/$backupFile" src-path=$backupFile upload=yes
/tool fetch url="s3://${bucket_name}/$exportFile" src-path=$exportFile upload=yes

# Verify backup
/system script run verify-backup-${router_name}

# Send notification
/system script run backup-notification-${router_name}

# Clean up local files
/file remove $backupFile
/file remove $exportFile
