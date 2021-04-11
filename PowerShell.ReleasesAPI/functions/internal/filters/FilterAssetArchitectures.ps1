filter FilterAssetArchitectures {
    param(
        [string]$Architecture
    )

    if ($PSItem.Architecture -eq $Architecture) {
        $PSItem
    }
}