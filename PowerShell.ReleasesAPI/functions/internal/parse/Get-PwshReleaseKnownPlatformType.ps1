function Get-PwshReleaseKnownPlatformType {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory)]
        [string]$PlatformString
    )

    $platformType = $null
    switch ($PlatformString) {
        "win" {
            $platformType = "Windows"
            break
        }

        "linux" {
            $platformType = "Linux"
            break
        }

        "osx" {
            $platformType = "macOS"
            break
        }

        { $PSItem -like "centos*" } {
            try {
                $platformVersionNumber = Get-PwshReleaseKnownPlatformVersionNumber -PlatformString $PlatformString -ErrorAction "Stop"
                $platformType = "centOS $($platformVersionNumber)"
            }
            catch {
                $platformType = "centOS"
            }
            break
        }

        { $PSItem -like "rhel*" } {
            try {
                $platformVersionNumber = Get-PwshReleaseKnownPlatformVersionNumber -PlatformString $PlatformString -ErrorAction "Stop"
                $platformType = "Red Hat Enterprise Linux $($platformVersionNumber)"
            }
            catch {
                $platformType = "Red Hat Enterprise Linux"
            }
            break
        }

        { $PSItem -like "debian*" } {
            try {
                $platformVersionNumber = Get-PwshReleaseKnownPlatformVersionNumber -PlatformString $PlatformString -ErrorAction "Stop"
                $platformType = "Debian $($platformVersionNumber)"
            }
            catch {
                $platformType = "Debian"
            }
            break
        }

        { $PSItem -like "ubuntu*" } {
            try {
                $platformVersionNumber = Get-PwshReleaseKnownPlatformVersionNumber -PlatformString $PlatformString -ErrorAction "Stop"
                $platformType = "Ubuntu $($platformVersionNumber)"
            }
            catch {
                $platformType = "Ubuntu"
            }
            break
        }

        Default {
            $platformType = $PlatformString
            break
        }
    }

    return $platformType
}