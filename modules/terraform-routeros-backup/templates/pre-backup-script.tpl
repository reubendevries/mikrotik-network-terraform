# modules/backup/templates/pre-backup-check.tpl
:log info "Starting pre-backup check for ${router_name}"
:local cpuLoad [/system resource get cpu-load]
:local memoryFree [/system resource get free-memory]

:if ($cpuLoad > 80) do={
    :log warning "High CPU load ($cpuLoad%) during backup"
}

:if ($memoryFree < 64000000) do={
    :log warning "Low memory ($memoryFree bytes) during backup"
}
