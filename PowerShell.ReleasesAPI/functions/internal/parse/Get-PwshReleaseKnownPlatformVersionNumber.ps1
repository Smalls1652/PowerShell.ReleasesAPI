function Get-PwshReleaseKnownPlatformVersionNumber {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory)]
        [string]$PlatformString
    )

    $versionRegex = [System.Text.RegularExpressions.Regex]::new(".+?\.(?'versionNumber'\d{1,}(?>\.\d{1,}|))")
    $versionMatch = $versionRegex.Match($PlatformString)

    $platformVersion = $null
    switch ($versionMatch.Success) {
        $false {
            throw [System.Exception]::new("No version number found.")
            break
        }

        Default {
            $platformVersion = $versionMatch.Groups['versionNumber'].Value
            break
        }
    }

    return $platformVersion
}