# modules/backup/templates/verify-backup.tpl
:log info "Verifying backup for ${router_name}"
:local lastBackup [/file find name~"backup"]
:if ([:len $lastBackup] = 0) do={
    :log error "Backup verification failed for ${router_name}"
    :error "Backup verification failed"
}
