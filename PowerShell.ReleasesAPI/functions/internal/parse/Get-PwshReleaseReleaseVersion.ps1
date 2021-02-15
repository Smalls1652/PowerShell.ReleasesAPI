function Get-PwshReleaseReleaseVersion {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory)]
        [string]$InputString
    )

    $releaseVersionRegex = [System.Text.RegularExpressions.Regex]::new("v(?'releaseVersion'(?'majorRelease'\d{1,})\.(?'minorRelease'\d{1,}))")
    $releaseVersionMatch = $releaseVersionRegex.Match($InputString)

    $releaseVersion = $releaseVersionMatch.Groups['releaseVersion'].Value

    return $releaseVersion
}