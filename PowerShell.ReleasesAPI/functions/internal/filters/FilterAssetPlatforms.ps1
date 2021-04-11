filter FilterAssetPlatforms {
    param(
        [string]$Platform
    )

    if ($PSItem.Platform -eq $Platform) {
        $PSItem
    }
}