<#

    Reference
        https://www.codewrecks.com/post/general/winget-update-selective/
    
    Notes
        This code is the work of Gian Maria and has been published on the above link
        This code has been tested to ensure it works on a upgrade case and a no upgrade case
        The code is missing the actual upgrade command which is

        winget upgrade --all --force --accept-package-agreements --accept-source-agreements

        The code is not proactive remediation ready, but can be with a couple of exit statements.


#>


class Software {
    [string]$Name
    [string]$Id
    [string]$Version
    [string]$AvailableVersion
}

$upgradeResult = winget upgrade | Out-String


if (!($upgradeResult -match "No installed package found matching input criteria."))
    {
    Write-Host "There is something to update" -ForegroundColor Green


    $lines = $upgradeResult.Split([Environment]::NewLine)

    # Find the line that starts with Name, it contains the header
    $fl = 0
    while (-not $lines[$fl].StartsWith("Name"))
        {
        $fl++
        }

        # Line $i has the header, we can find char where we find ID and Version
        $idStart = $lines[$fl].IndexOf("Id")
        $versionStart = $lines[$fl].IndexOf("Version")
        $availableStart = $lines[$fl].IndexOf("Available")
        $sourceStart = $lines[$fl].IndexOf("Source")

        # Now cycle in real package and split accordingly
        $upgradeList = @()
        For ($i = $fl + 1; $i -le $lines.Length; $i++) 
            {
            $line = $lines[$i]
            if ($line.Length -gt ($availableStart + 1) -and -not $line.StartsWith('-'))
                 {
                 $name = $line.Substring(0, $idStart).TrimEnd()
                 $id = $line.Substring($idStart, $versionStart - $idStart).TrimEnd()
                 $version = $line.Substring($versionStart, $availableStart - $versionStart).TrimEnd()
                 $available = $line.Substring($availableStart, $sourceStart - $availableStart).TrimEnd()
                 $software = [Software]::new()
                 $software.Name = $name;
                 $software.Id = $id;
                 $software.Version = $version
                 $software.AvailableVersion = $available;

                 $upgradeList += $software
                 }
            }

            $upgradeList | Format-Table

            #Actual upgrade command - been removed as this code needs to be rewritten for proactive remediation

            #winget upgrade --all --force --accept-package-agreements --accept-source-agreements


    }

else
    {

    Write-Host "There is nothing to upgrade" -ForegroundColor Yellow

    }



