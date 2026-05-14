<#
Version: 1.0
Author:
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
- Sascha Stumpler (sastu@master-client.com)
Script: Get-TemplateRemediation
Description:
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: User/Admin
Context: 32 & 64 Bit
#>

function New-LocalUserAccount {

	[CmdletBinding()]
	param (
			[Parameter(
					ValueFromPipeline = $true,
					ValueFromPipelineByPropertyName = $true
			)]
			[string] $Computer = $env:COMPUTERNAME,


			[Parameter(Mandatory = $true)]
			[string] $Name,

			[Parameter(Mandatory = $true)]
			[string] $DisplayName,

			[Parameter(Mandatory = $true)]
			[string] $Password
	)

	[ADSI] $host = [string]::Format("WinNT://{0}", $Computer)

	if (![string]::IsNullOrEmpty($Name)) {
			$user = $host.Create("User", $Name)
			if ($user -ne $null) {
					$user.SetPassword($password);
					$user.SetInfo()
			}
	}
}

function New-RandomPassword {
	[CmdletBinding()]
	param (
			[Parameter(Mandatory = $false)]
			[int] $Length = 12,

			[Parameter(Mandatory = $false)]
			[string] $RegEx = '[\w\$\%\&\/\(\)\=\?\!\\,\.\-_\:;\]\+\*\~<>\|]'
	)

	# Use a cryptographically secure RNG. Get-Random on Windows PowerShell 5.1 is backed
	# by System.Random, which is predictable and unsuitable for generating credentials
	# (especially for a LAPS-style local administrator account).
	[char[]]$allowed = [char[]](0..127) -match $RegEx
	$rng = [System.Security.Cryptography.RNGCryptoServiceProvider]::new()
	try {
		$bytes = New-Object byte[] ($Length * 4)
		$rng.GetBytes($bytes)
		$chars = for ($i = 0; $i -lt $Length; $i++) {
			$val = [BitConverter]::ToUInt32($bytes, $i * 4)
			$allowed[$val % $allowed.Length]
		}
		[string]$password = -join $chars
	}
	finally {
		$rng.Dispose()
	}
	return $password
}

$AdminAccountName = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Policies\LAPS' -Name 'AdministratorAccountName' -ErrorAction SilentlyContinue).AdministratorAccountName
If (($AdminAccountName) -and ((Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Policies\LAPS' -Name 'BackupDirectory' -ErrorAction SilentlyContinue).BackupDirectory) -ne '0' -and (Get-Item -Path ($env:windir + '\system32\laps.dll') -ErrorAction SilentlyContinue)) {
	New-LocalUserAccount -Name $AdminAccountName -DisplayName $AdminAccountName -Password (New-RandomPassword -Length 24)
}