function Invoke-PwshReleaseParseAssetItem {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory)]
        [pscustomobject[]]$Assets,
        [Parameter(Position = 1)]
        [pscustomobject[]]$FileHashes
    )

    process {
        foreach ($asset in $Assets) {
            $assetFileHash = ($FileHashes | Where-Object { $PSItem.FileName -eq $asset.name }).FileHash
            $assetNameRegex = [System.Text.RegularExpressions.Regex]::new("(?>(?i)powershell)(?>-|_).+?(?>-(?>preview|(?>rc|(?>alpha|beta))).+?|)(?>\.|-)(?'platform'[a-zA-Z]+(?>\.\d{1,}(?>\.\d{1,}|)|)|)(?>\.|(?>-|_))(?'arch'.+?)\.(?'fileType'.+)")

            $assetNameMatch = $assetNameRegex.Match($asset.name)
            switch ($assetNameMatch.Success) {
                $false {
                    $assetItem = [PwshReleaseAssetItem]@{
                        "Name"         = $asset.name;
                        "Platform"     = "N/A";
                        "Architecture" = "N/A";
                        "FileType"     = "N/A";
                        "SHA256"       = $assetFileHash.FileHash
                        "DownloadUrl"  = $asset.browser_download_url;
                    }
                    break
                }

                Default {
                    $assetItem = [PwshReleaseAssetItem]@{
                        "Name"         = $asset.name;
                        "Platform"     = $assetNameMatch.Groups['platform'].Value;
                        "Architecture" = $assetNameMatch.Groups['arch'].Value;
                        "FileType"     = $assetNameMatch.Groups['fileType'].Value;
                        "SHA256"       = $assetFileHash;
                        "DownloadUrl"  = $asset.browser_download_url;
                    }
                    break
                }
            }

            $assetItem
        }
    }
}