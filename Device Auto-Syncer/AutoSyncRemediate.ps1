try {
    Get-ScheduledTask | ? {$_.TaskName -eq 'PushLaunch'} | Start-ScheduledTask
    Exit 0
}
catch {
    Write-Error $_
    Exit 1
}
