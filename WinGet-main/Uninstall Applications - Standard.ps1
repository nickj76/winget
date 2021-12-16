<#

   Remove applications if found Standard Users


    Reference:
        https://chrislayers.com/2021/08/01/scripting-winget/


    Notes:
        Tested 02-12-2021
        Can be tested by installing Google.Chrome.Dev before running the code
        Remove the hold on the uninstalll line in production
        See no need to generate a remediation script - this should run fine on standard intune run times.

        Issue with Teams - investigate.

#>



#List of applications to uninstall from Standard user devices

$apps = @(
    @{id = "Google.Chrome.Dev" },
    @{id = "Microsoft.Office.OneNote_8wekyb3d8bbwe"}
);



Foreach ($app in $apps) 
    {
    #check if the app is already installed
    $listApp = winget list --exact --accept-source-agreements -q $app.id
    if ([String]::Join("", $listApp).Contains($app.id)) 
        {

        Write-host "Found the following application installed:" $app.id -ForegroundColor Red

        Write-Host "Uninstalling the following application" $app.id -ForegroundColor Yellow
        winget uninstall --exact --silent $app.id 
        }

    else 
        {
        Write-host "Skipping Uninstall - application not installed " $app.id -ForegroundColor Green
        }
    }
