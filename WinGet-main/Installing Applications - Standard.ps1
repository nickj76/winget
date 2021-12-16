<#
    Install the following default applications
    
    Reference
         https://chrislayers.com/2021/08/01/scripting-winget/

    Updated 02-12-2021

    Testing

    Remove the Google.Chrome.Dev entry in production.
    Remove the hold on the install lines in production.
    See no need to generate a remediation script - this should run fine on standard intune run times.

    Microsoft.Office is already installed so it should bug out - but further testing required.

#>



#Need to install Microsoft office via this but so far testing has proven problematic - There are 3 different versions
$apps = @(
    @{name = "Google.Chrome" },
    @{name = "Microsoft.Office"},  
    @{name = "Microsoft.BingNews_8wekyb3d8bbwe" }, 
    @{name = "Microsoft.CompanyPortal_8wekyb3d8bbwe" }, 
    @{name = "Microsoft.WindowsTerminal"; source = "msstore" }, 
    @{name = "Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe" }, 
    @{name = "Microsoft.Todos_8wekyb3d8bbwe" }, 
    @{name = "Microsoft.WindowsNotepad_8wekyb3d8bbwe" }
);



Foreach ($app in $apps) 
    {
    #check if the app is already installed
    $listApp = winget list --exact --accept-source-agreements -q $app.name
    if (![String]::Join("", $listApp).Contains($app.name)) 
        {


        if ($app.source -ne $null) 
            {
            #accept source agreements is new and needs to be tested
            Write-Host "Installing the following application from a dedicated source" $app.name $app.source -ForegroundColor Yellow
            #winget install --exact --silent --accept-source-agreements $app.name --source $app.source
             }
        else 
            {
            #accept source agreements is new and needs to be tested
            Write-Host "Installing the following application" $app.name -ForegroundColor Yellow
            #winget install --exact --silent --accept-source-agreements $app.name 
            }
         }
    else {
        Write-host "Skipping Install of already installed " $app.name -ForegroundColor Green
        }
}
