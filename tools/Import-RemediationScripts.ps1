<#
.SYNOPSIS
    Import explicitly selected remediation folders without assigning them to devices.
.DESCRIPTION
    Uses an existing Microsoft.Graph.Authentication session. Existing display names
    are skipped, not overwritten. Preview with -WhatIf. No secrets are stored.
#>
[CmdletBinding(SupportsShouldProcess, DefaultParameterSetName='Selected')]
param(
    [string]$RepoPath = (Split-Path $PSScriptRoot -Parent),
    [Parameter(Mandatory, ParameterSetName='Selected')][ValidateNotNullOrEmpty()][string[]]$Name,
    [Parameter(Mandatory, ParameterSetName='All')][switch]$All,
    [string]$Publisher = 'Jannik Reinhard',
    [ValidateSet('system','user')][string]$RunAsAccount = 'system',
    [switch]$RunAs32Bit,
    [switch]$EnforceSignatureCheck
)
$ErrorActionPreference='Stop'
$folders = @(Get-ChildItem -LiteralPath $RepoPath -Directory | Where-Object { $_.Name -notmatch '^(\.|0 -|_|tools$|tests$|assets$)' })
if (-not $All) {
    foreach ($requested in $Name) {
        if ($requested -notin $folders.Name) { throw "Unknown remediation folder: $requested" }
    }
    $folders = @($folders | Where-Object { $_.Name -in $Name })
}
# Validate the entire local selection before creating any remote objects.
$plan = @($folders | ForEach-Object {
    $folder=$_
    $detect=@(Get-ChildItem -LiteralPath $folder.FullName -File -Filter '*.ps1' | Where-Object { $_.Name -match '^detect' })
    $remediate=@(Get-ChildItem -LiteralPath $folder.FullName -File -Filter '*.ps1' | Where-Object { $_.Name -match '^remediat' })
    if ($detect.Count -ne 1 -or $remediate.Count -ne 1) {
        if (-not $All) { throw "Folder '$($folder.Name)' must contain exactly one detection and one remediation script." }
        Write-Warning "Skipping '$($folder.Name)': expected one detection and one remediation script."
    } else {
        [pscustomobject]@{ Name=$folder.Name; Detection=$detect[0].FullName; Remediation=$remediate[0].FullName }
    }
})
$existing=[System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
if ($plan.Count -gt 0 -and -not $WhatIfPreference) {
    if (-not (Get-Command Invoke-MgGraphRequest -ErrorAction SilentlyContinue)) { throw 'Install/import Microsoft.Graph.Authentication and connect before importing.' }
    if (-not (Get-MgContext)) { throw 'Connect-MgGraph -Scopes DeviceManagementScripts.ReadWrite.All first.' }
    $uri='https://graph.microsoft.com/beta/deviceManagement/deviceHealthScripts?$select=id,displayName'
    do {
        $page=Invoke-MgGraphRequest -Method GET -Uri $uri -OutputType PSObject -ErrorAction Stop
        foreach ($entry in $page.value) { $null=$existing.Add($entry.displayName) }
        $uri=$page.'@odata.nextLink'
    } while ($uri)
}
foreach ($item in $plan) {
    if ($existing.Contains($item.Name)) { Write-Output ([pscustomobject]@{Name=$item.Name;Status='SkippedExisting';Id=$null}); continue }
    if ($PSCmdlet.ShouldProcess($item.Name, 'Create Intune remediation (no assignments)')) {
        $body=@{
            displayName=$item.Name
            description="Imported from JayRHa/intune-remediation-scripts ($($item.Name))"
            publisher=$Publisher
            runAsAccount=$RunAsAccount
            runAs32Bit=[bool]$RunAs32Bit
            enforceSignatureCheck=[bool]$EnforceSignatureCheck
            detectionScriptContent=[Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes([IO.File]::ReadAllText($item.Detection)))
            remediationScriptContent=[Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes([IO.File]::ReadAllText($item.Remediation)))
        }
        $created=Invoke-MgGraphRequest -Method POST -Uri 'https://graph.microsoft.com/beta/deviceManagement/deviceHealthScripts' -Body ($body | ConvertTo-Json -Depth 5) -ContentType 'application/json' -OutputType PSObject -ErrorAction Stop
        $null=$existing.Add($item.Name)
        Write-Output ([pscustomobject]@{Name=$item.Name;Status='Created';Id=$created.id})
    }
}
