$ErrorActionPreference='Stop'
$tool=Join-Path $PSScriptRoot '../tools/Import-RemediationScripts.ps1'
$temp=Join-Path ([IO.Path]::GetTempPath()) ([guid]::NewGuid().ToString())
function Assert($condition,$message) { if (-not $condition) { throw $message } }
try {
 $null=New-Item -ItemType Directory -Path $temp
 foreach ($name in @('One','Two')) {
  $dir=New-Item -ItemType Directory -Path (Join-Path $temp $name)
  [IO.File]::WriteAllText((Join-Path $dir.FullName 'detection_test.ps1'),'Write-Output "Grün"')
  [IO.File]::WriteAllText((Join-Path $dir.FullName 'remediation_test.ps1'),'exit 0')
 }
 function Invoke-MgGraphRequest { throw 'Preview must not call Graph' }
 & $tool -RepoPath $temp -Name One -WhatIf
 try { & $tool -RepoPath $temp -Name Missing -WhatIf; throw 'Missing accepted' } catch { Assert ($_.Exception.Message -like 'Unknown remediation*') 'Unknown folder validation failed' }
 $global:ImporterTestPosts=[System.Collections.Generic.List[object]]::new()
 function Get-MgContext { return @{Account='test'} }
 function Invoke-MgGraphRequest {
  param($Method,$Uri,$Body,$ContentType,$OutputType,$ErrorAction)
  if ($Method -eq 'GET') {
   if ($Uri -eq 'https://graph.microsoft.com/beta/page2') { return [pscustomobject]@{value=@([pscustomobject]@{displayName='One'})} }
   return [pscustomobject]@{value=@();'@odata.nextLink'='https://graph.microsoft.com/beta/page2'}
  }
  $global:ImporterTestPosts.Add(($Body|ConvertFrom-Json));return [pscustomobject]@{id='new'}
 }
 $result=@(& $tool -RepoPath $temp -All -Confirm:$false)
 Assert ($global:ImporterTestPosts.Count -eq 1) 'Existing record on page 2 was not skipped'
 Assert ($result[0].Status -eq 'SkippedExisting') 'Skip not reported'
 $payload=$global:ImporterTestPosts[0]
 Assert ($payload.displayName -eq 'Two') 'Wrong package imported'
 Assert ([Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($payload.detectionScriptContent)) -eq 'Write-Output "Grün"') 'Encoding lost'
 Assert ($payload.runAsAccount -eq 'system' -and -not $payload.runAs32Bit) 'Unexpected execution defaults'
 Assert (-not ($payload.PSObject.Properties.Name -contains 'assignments')) 'Unexpected assignment'
 [IO.File]::WriteAllText((Join-Path $temp 'Two/detection_second.ps1'),'exit 0')
 try { & $tool -RepoPath $temp -Name Two -WhatIf;throw 'Ambiguous accepted' } catch { Assert ($_.Exception.Message -like '*exactly one*') 'Ambiguous scripts accepted' }
 Write-Host 'PASS: offline preview, unknown and ambiguous folders, paginated duplicates, UTF-8, no assignments'
} finally { Remove-Variable ImporterTestPosts -Scope Global -ErrorAction SilentlyContinue; Remove-Item -LiteralPath $temp -Recurse -Force }
