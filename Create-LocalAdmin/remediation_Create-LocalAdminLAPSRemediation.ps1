<#
Version: 1.0
Author: 
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
- Simon Skotheimsvik (skotheimsvik.no)
Script: Create-LocalAdmin
Description: Add a local admin with a randomized password, ensuring that we do not have an account with a static password across all devices before Windows LAPS takes effect.
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.1: Init
Run as: Admin
Context: 64 Bit
#> 

$localAdminName = ""

# Generate the password using a cryptographically secure RNG. Get-Random on Windows
# PowerShell 5.1 (the default on Intune-managed endpoints) is backed by System.Random,
# which is NOT cryptographically secure and is predictable. RNGCryptoServiceProvider
# (or RandomNumberGenerator on .NET Core) provides unbiased, unpredictable bytes.
$charSet = [char[]](((65..90) + (97..122) + (48..57) + (35..38) + (40..47)) | ForEach-Object { [char]$_ })
$length = 35
$rng = [System.Security.Cryptography.RNGCryptoServiceProvider]::new()
try {
    $bytes = New-Object byte[] ($length * 4)
    $rng.GetBytes($bytes)
    $chars = for ($i = 0; $i -lt $length; $i++) {
        # Use a 32-bit unsigned value and modulo into the charset. Bias is negligible for
        # this charset size relative to UInt32.MaxValue.
        $val = [BitConverter]::ToUInt32($bytes, $i * 4)
        $charSet[$val % $charSet.Length]
    }
    $password = (-join $chars) | ConvertTo-SecureString -AsPlainText -Force
}
finally {
    $rng.Dispose()
}

$Localadmingroupname = $((Get-LocalGroup -SID "S-1-5-32-544").Name)

New-LocalUser "$localAdminName" -Password $password -FullName "$localAdminName" -Description "LAPS account"
Add-LocalGroupMember -Group $Localadmingroupname -Member "$localAdminName"
