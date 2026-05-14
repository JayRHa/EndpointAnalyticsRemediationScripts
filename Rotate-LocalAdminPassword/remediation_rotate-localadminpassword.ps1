<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: rotate-localadminpassword.ps1
Description: Rotates the local administrator password with a random secure password
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    $AdminAccount = Get-LocalUser | Where-Object { $_.SID -like "S-1-5-*-500" }
    if (-not $AdminAccount) {
        Write-Error "Local administrator account not found"
        exit 1
    }

    # [System.Web.Security.Membership]::GeneratePassword is known to produce biased
    # output (and is unavailable on PowerShell 7 without System.Web). Use a CSPRNG
    # over an explicit, well-defined character set instead.
    $upper   = [char[]](65..90)
    $lower   = [char[]](97..122)
    $digits  = [char[]](48..57)
    $special = [char[]]'!@#$%^&*()-_=+[]{}'
    $charSet = $upper + $lower + $digits + $special
    $length  = 24

    function Get-SecureRandomUInt32 {
        param([System.Security.Cryptography.RandomNumberGenerator]$Rng)
        $b = New-Object byte[] 4
        $Rng.GetBytes($b)
        return [BitConverter]::ToUInt32($b, 0)
    }

    $rng = [System.Security.Cryptography.RNGCryptoServiceProvider]::new()
    try {
        # Guarantee complexity: one char from each class.
        $required = @(
            $upper[   (Get-SecureRandomUInt32 -Rng $rng) % $upper.Length   ],
            $lower[   (Get-SecureRandomUInt32 -Rng $rng) % $lower.Length   ],
            $digits[  (Get-SecureRandomUInt32 -Rng $rng) % $digits.Length  ],
            $special[ (Get-SecureRandomUInt32 -Rng $rng) % $special.Length ]
        )

        $fill = for ($i = 0; $i -lt ($length - $required.Count); $i++) {
            $charSet[ (Get-SecureRandomUInt32 -Rng $rng) % $charSet.Length ]
        }

        $all = @($required) + @($fill)

        # Fisher-Yates shuffle using CSPRNG indices.
        for ($i = $all.Count - 1; $i -gt 0; $i--) {
            $j = (Get-SecureRandomUInt32 -Rng $rng) % ($i + 1)
            $tmp = $all[$i]; $all[$i] = $all[$j]; $all[$j] = $tmp
        }

        $NewPassword = -join $all
        $SecurePassword = ConvertTo-SecureString $NewPassword -AsPlainText -Force
    }
    finally {
        $rng.Dispose()
    }

    $AdminAccount | Set-LocalUser -Password $SecurePassword -ErrorAction Stop
    Write-Output "Local administrator password has been rotated successfully"
    exit 0
}
catch {
    Write-Error "Failed to rotate password: $_"
    exit 1
}
