Invoke-WebRequest -Uri “https://github.com/microsoft/winget-cli/releases/download/v-0.2.10191-preview/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle” -OutFile “C:\temp\WinGet.appxbundle“

Add-AppxPackage “C:\temp\WinGet.appxbundle”