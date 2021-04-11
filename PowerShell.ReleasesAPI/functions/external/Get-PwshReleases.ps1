function Get-PwshReleases {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [ValidateScript(
            {
                $releaseVersionTest = [System.Text.RegularExpressions.Regex]::new("^(\d{1,}\.\d{1,})$").Match($PSItem)
                if (($releaseVersionTest.Success -eq $false) -and ($null -ne $PSItem)) {
                    throw "The provided input is in the incorrect format. An example of an acceptable input is '7.1'."
                }
                else {
                    $true
                }
            }
        )]
        [string]$FilterReleaseVersion,
        [Parameter(Position = 1)]
        [switch]$NoPreReleases,
        [Parameter(Position = 2)]
        [string]$FilterAssetsByPlatform,
        [Parameter(Position = 3)]
        [string]$FilterAssetsByArchitecture,
        [Parameter(Position = 4)]
        [string]$FilterAssetsByFileType
    )

    $releases = [System.Collections.Generic.List[PwshReleaseItem]]::new()
    $apiUri = "https://api.github.com/repos/PowerShell/PowerShell/releases"

    $paginationIsFinished = $false
    $lastPage = $null
    while ($paginationIsFinished -eq $false) {
        Write-Verbose "Getting content from '$($apiUri)'"
    
        $currentProgressPreference = $ProgressPreference
        switch ($currentProgressPreference -eq "Continue") {
            $true {
                $ProgressPreference = "SilentlyContinue"
                break
            }
        }

        try {
            $webRequest = Invoke-WebRequest -Uri $apiUri -Method "Get" -Verbose:$false -ErrorAction "Stop"
        }
        catch {
            $errorDetails = $PSItem.Exception

            $PSCmdlet.ThrowTerminatingError(
                [System.Management.Automation.ErrorRecord]::new(
                    [System.Exception]::new("An error occurred while retrieving data from the GitHub API."),
                    "GitHubApiCallError",
                    [System.Management.Automation.ErrorCategory]::ConnectionError,
                    $errorDetails
                )
            )
        }

        $ProgressPreference = $currentProgressPreference

        $apiResponseData = $webRequest.Content | ConvertFrom-Json

        Write-Verbose "Parsing response data"
        foreach ($releaseItem in $apiResponseData) {

            $releaseVersionString = Get-PwshReleaseReleaseVersion -InputString $releaseItem.tag_name

            $allHashesRegex = [System.Text.RegularExpressions.Regex]::new("#{3} SHA256 Hashes of the release artifacts\r\s+(?'hashList'(?s).+)")
            $allHashesMatch = $allHashesRegex.Match($releaseItem.body)

            $extractHashesRegex = [System.Text.RegularExpressions.Regex]::new("- (?'fileName'.+?)\n  - (?'fileHash'.+?)\n")
            $extractHashesMatches = $extractHashesRegex.Matches($allHashesMatch.Groups['hashList'].Value)

            $fileHashes = [System.Collections.Generic.List[pscustomobject]]::new()
            foreach ($item in $extractHashesMatches) {
                $fileHashes.Add(
                    [pscustomobject]@{
                        "FileName" = $item.Groups['fileName'].Value.Trim();
                        "FileHash" = $item.Groups['fileHash'].Value.Trim();
                    }
                )
            }
            $assetList = Invoke-PwshReleaseParseAssetItem -Assets $releaseItem.assets -FileHashes $fileHashes

            switch ([string]::IsNullOrEmpty($FilterAssetsByPlatform)) {
                $false {
                    $assetList = [PwshReleaseAssetItem[]]($assetList | FilterAssetPlatforms -Platform $FilterAssetsByPlatform)
                    break
                }
            }

            switch ([string]::IsNullOrEmpty($FilterAssetsByArchitecture)) {
                $false {
                    $assetList = [PwshReleaseAssetItem[]]($assetList | FilterAssetArchitectures -Architecture $FilterAssetsByArchitecture)
                    break
                }
            }

            switch ([string]::IsNullOrEmpty($FilterAssetsByFileType)) {
                $false {
                    $assetList = [PwshReleaseAssetItem[]]($assetList | FilterAssetFileTypes -FileType $FilterAssetsByFileType)
                    break
                }
            }

            $releases.Add(
                [PwshReleaseItem]@{
                    "Name"           = $releaseItem.name;
                    "ReleaseVersion" = $releaseVersionString;
                    "Tag"            = $releaseItem.tag_name;
                    "ReleaseDate"    = $releaseItem.published_at;
                    "IsPreRelease"   = $releaseItem.prerelease;
                    "Assets"         = $assetList;
                    "ReleasePage"    = $releaseItem.html_url;
                }
            )
        }

        Write-Verbose "Checking for additional pages."
        $doesLinkKeyExist = $webRequest.Headers.ContainsKey("Link")
        switch ($doesLinkKeyExist) {
            $true {
                $links = Get-PwshReleaseHeaderLinks -ResponseObject $webRequest

                $nextPageInHeaders = $links | Where-Object { $PSItem.Rel -eq "next" }
                $lastPageInHeaders = $links | Where-Object { $PSItem.Rel -eq "last" }
                switch (($null -eq $lastPage) -and ($null -ne $lastPageInHeaders)) {
                    $true {
                        Write-Verbose "Last page is '$($lastPageInHeaders.Link)'"
                        $lastPage = $lastPageInHeaders
                        break
                    }
                }

                switch (($apiUri -eq $lastPage.Link) -or ($doesLinkKeyExist -eq $false)) {
                    $true {
                        Write-Verbose "No more pages to process."
                        $paginationIsFinished = $true
                        break
                    }

                    Default {
                        Write-Verbose "Continuing to next page."
                        $apiUri = $nextPageInHeaders.Link
                        break
                    }
                }
                break
            }
        }
    }

    switch ($NoPreReleases) {
        $true {
            Write-Verbose "Filtering out pre-release items"
            $releases = $releases | Where-Object { $PSItem.IsPreRelease -ne $true }
            break
        }
    }

    switch ([string]::IsNullOrEmpty($FilterReleaseVersion)) {
        $false {
            Write-Verbose "Filtering release versions with '$($FilterReleaseVersion)'"
            $releases = $releases | Where-Object { $PSItem.ReleaseVersion -eq $FilterReleaseVersion }
            break
        }
    }

    return $releases
}