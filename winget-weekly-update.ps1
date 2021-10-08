$content = @'
winget upgrade --all --force
'@

# create custom folder and write PS script
$path = $(Join-Path $env:ProgramData CustomScripts)
if (!(Test-Path $path))
{
New-Item -Path $path -ItemType Directory -Force -Confirm:$false
}
Out-File -FilePath $(Join-Path $env:ProgramData CustomScripts\WingetUppgradeApps.ps1) -Encoding unicode -Force -InputObject $content -Confirm:$false
 
# register script as scheduled task
$Time = New-ScheduledTaskTrigger -AtLogOn
$User = "SYSTEM"
$Action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ex bypass -file `"C:\ProgramData\CustomScripts\WingetUppgradeApps.ps1`""
Register-ScheduledTask -TaskName "UpgradeApps" -Trigger $Time -User $User -Action $Action -Force
Start-ScheduledTask -TaskName "UpgradeApps"