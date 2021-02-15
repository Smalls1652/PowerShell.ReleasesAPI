function Get-PwshReleaseHeaderLinks {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory)]
        [Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject]$ResponseObject
    )

    $headerLinks = $ResponseObject.Headers.Link
    $headerLinksRegex = [System.Text.RegularExpressions.Regex]::new("<(?'uri'.+?)>; rel=`"(?'rel'.+?)`"")

    $linksMatches = $headerLinksRegex.Matches($headerLinks)
    foreach ($foundMatch in $linksMatches) {
        [PwshReleaseGitHubHeaderLink]@{
            "Rel"  = $foundMatch.Groups['rel'].Value;
            "Link" = $foundMatch.Groups['uri'].Value;
        }
    }
}