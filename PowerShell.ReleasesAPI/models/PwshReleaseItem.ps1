class PwshReleaseItem {
    [string]$Name
    [string]$ReleaseVersion
    [string]$Tag
    [datetime]$ReleaseDate
    [bool]$IsPreRelease
    [PwshReleaseAssetItem[]]$Assets
    [string]$ReleasePage

    [PwshReleaseAssetItem[]] FilterAssetItems([string]$platform, [string]$arch, [string]$fileType) {
        $filteredData = $this.Assets

        switch ([string]::IsNullOrEmpty($platform)) {
            $false {
                $filteredData = $filteredData | Where-Object { $PSItem.Platform -eq $Platform }
                break
            }
        }

        switch ([string]::IsNullOrEmpty($arch)) {
            $false {
                $filteredData = $filteredData | Where-Object { $PSItem.Architecture -eq $arch }
                break
            }
        }

        switch ([string]::IsNullOrEmpty($fileType)) {
            $false {
                $filteredData = $filteredData | Where-Object { $PSItem.FileType -eq $fileType }
                break
            }
        }

        return $filteredData
    }
}