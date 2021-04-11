filter FilterAssetFileTypes {
    param(
        [string]$FileType
    )

    if ($PSItem.FileType -eq $FileType) {
        $PSItem
    }
}