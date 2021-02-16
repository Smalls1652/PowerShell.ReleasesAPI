$scriptRoot = $PSScriptRoot

$folderPaths = @(
    ([System.IO.Path]::Combine($scriptRoot, "\functions")),
    ([System.IO.Path]::Combine($scriptRoot, "\models"))
)

$moduleFiles = foreach ($dir in $folderPaths) {
    Get-ChildItem -Path $moduleFiles -Recurse | Where-Object { $PSItem.Extension -eq ".ps1" }
}

foreach ($moduleFile in $moduleFiles) {
    . "$($moduleFile.FullName)"
}