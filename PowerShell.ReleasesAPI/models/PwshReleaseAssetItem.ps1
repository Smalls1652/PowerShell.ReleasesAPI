class PwshReleaseAssetItem {
    [string]$Name
    [string]$Platform
    [string]$Architecture
    [string]$FileType
    [string]$SHA256
    [string]$DownloadUrl

    [System.IO.FileInfo] DownloadFile([string]$outPath) {
        $resolvedOutPath = Resolve-Path -Path $outPath

        $downloadPath = [System.IO.Path]::Combine($resolvedOutPath.Path, $this.Name)

        $script:ProgressPreference = "SilentlyContinue"
        $null = Invoke-WebRequest -Uri $this.DownloadUrl -Method "Get" -OutFile $downloadPath -Verbose:$false
        $script:ProgressPreference = "Continue"

        $downloadedItem = Get-Item -Path $downloadPath

        switch ([string]::IsNullOrEmpty($this.SHA256)) {
            $true {
                Write-Warning "Could not verify the hash of the downloaded file. Proceed with caution!"
                break
            }

            Default {
                $downloadedItemHash = Get-FileHash -Path $downloadedItem.FullName -Algorithm "SHA256"

                if ($downloadedItemHash.Hash -ne $this.SHA256) {
                    Remove-Item -Path $downloadedItem.FullName -Force
                    throw [System.Management.Automation.ErrorRecord]::new(
                        [System.Exception]::new("The downloaded file's hash did not match."),
                        "FailedHashValidation",
                        [System.Management.Automation.ErrorCategory]::SecurityError,
                        $downloadedItemHash
                    )
                }

                break
            }
        }

        return $downloadedItem
    }
}