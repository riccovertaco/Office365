#
#.SYNOPSIS ./Update-msolUpn.ps1
#PowerShell script to automate this task to change the all Office 365 user accounts with user@domain.onmicrosoft.com. to user@domain.com
#Install Azure AD modules from http://technet.microsoft.com/library/jj151815.aspx before running this.
#
 
#Get Modules
$env:PSModulePath=$env:PSModulePath+";"+"C:\Program Files (x86)\Microsoft SDKs\Windows Azure\PowerShell"
$env:PSModulePath=$env:PSModulePath+";"+"C:\Windows\System32\WindowsPowerShell\v1.0\Modules\"
Import-Module MSOnline
 
Get-Credential "eric@toto.com" | Export-Clixml C:\folder\scripts\totocred.xml #Store Credentials
 
#$count = 1 #For Testing the first result
 
$cred = Import-Clixml C:\folder\scripts\totocred.xml
 
Connect-MsolService -Credential $cred
 
Get-MsolUser -All | Select-Object UserPrincipalName, Title, DisplayName, IsLicensed | export-csv –path C:\folder\scripts\folder_MSOL_Users_BeforeUpdate.csv
 
Get-MsolUser -All |
 Where { $_.UserPrincipalName.ToLower().EndsWith("onmicrosoft.com") } |
 ForEach {
 #if($count -eq 1) #For Testing the first result
 # {
 $upnVal = $_.UserPrincipalName.Split("@")[0] + "@toto.com"
 Write-Host "Changing UPN value from: "$_.UserPrincipalName" to: " $upnVal -ForegroundColor Magenta
 Set-MsolUserPrincipalName -ObjectId $_.ObjectId -NewUserPrincipalName ($upnVal)
 $count++
 # }
 }
 
Get-MsolUser -All | Select-Object UserPrincipalName, Title, DisplayName, IsLicensed | export-csv –path C:\folder\scripts\folder_MSOL_Users_AfterUpdate.csv