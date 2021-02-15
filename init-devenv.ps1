Write-Output "[Initializing dev environment...]`n"
switch ($null -ne (Get-Module -Name "PowerShell.ReleasesAPI.DevEnv")) {
    $true {
        Write-Warning "Dev environment was already loaded in. Removing from memory."
        Remove-Module -Name "PowerShell.ReleasesAPI.DevEnv" -Force
        break
    }
}

New-Module -Name "PowerShell.ReleasesAPI" -ScriptBlock {
    $scriptRoot = $PSScriptRoot

    $moduleDevPath = [System.IO.Path]::Combine($scriptRoot, "PowerShell.ReleasesAPI")
    $functionsPath = [System.IO.Path]::Combine($moduleDevPath, "functions")
    $modelsPath = [System.IO.Path]::Combine($moduleDevPath, "models")
    
    $classesInModule = Get-ChildItem -Path $modelsPath -Recurse | Where-Object { $PSItem.Extension -eq ".ps1" }
    foreach ($item in $classesInModule) {
        . "$($item.FullName)"
    }
    
    Write-Output ""
    Write-Output "- Importing all functions in project into the current PowerShell session"
    
    $functionsInModule = Get-ChildItem -Path $functionsPath -Recurse | Where-Object { $PSItem.Extension -eq ".ps1" }
    foreach ($item in $functionsInModule) {
        . "$($item.FullName)"
    }
} | Import-Module
Write-Output "`n[Dev environment initialized]"