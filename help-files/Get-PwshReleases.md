---
external help file: PowerShell.ReleasesAPI-help.xml
Module Name: PowerShell.ReleasesAPI
online version:
schema: 2.0.0
---

# Get-PwshReleases

## SYNOPSIS
Get PowerShell releases

## SYNTAX

```
Get-PwshReleases [[-FilterReleaseVersion] <String>] [-NoPreReleases] [[-FilterAssetsByPlatform] <String>]
 [[-FilterAssetsByArchitecture] <String>] [[-FilterAssetsByFileType] <String>] [<CommonParameters>]
```

## DESCRIPTION
Get releases of PowerShell 6.0 and higher from the official GitHub repo.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-PwshReleases -FilterReleaseVersion "7.1" -NoPreReleases
```

Get all of the releases of PowerShell with the release version of '7.1' and filter out pre-releases.

### Example 2
```powershell
PS C:\> $pwshRelease = Get-PwshReleases -FilterReleaseVersion "7.1" -NoPreReleases -FilterAssetsByPlatform "macOS" -FilterAssetsByFileType "pkg" | Where-Object { $PSItem.Tag -eq "v7.1.3" }
PS C:\> $pwshRelease

Name           : v7.1.3 Release of PowerShell
ReleaseVersion : 7.1
Tag            : v7.1.3
ReleaseDate    : 3/11/2021 11:29:58 PM
IsPreRelease   : False
Assets         : {macOS x64 [pkg]}
ReleasePage    : https://github.com/PowerShell/PowerShell/releases/tag/v7.1.3

PS C:\> $pwshRelease.Assets[0].DownloadFile("/tmp/")

Get all of the releases of PowerShell with the release version of '7.1', filter out pre-releases, and then filter to only show assets that are for 'macOS' with a file type of 'pkg'. Then filter to get the release tag for 'v7.1.3' with 'Where-Object'. Then download the first asset to the '/tmp/' directory.

```

## PARAMETERS

### -FilterAssetsByArchitecture
Filter the architecture for the asset in a release.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterAssetsByFileType
Filter the file type for the asset in a release

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterAssetsByPlatform
Filter the platform (Commonly the operating system) for the asset in a release.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterReleaseVersion
Filter by the release version.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoPreReleases
Filter out pre-release items.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
## OUTPUTS

### PwshReleaseItem[]
## NOTES

## RELATED LINKS
