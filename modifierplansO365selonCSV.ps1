$csv =import-csv "c:\scripts\Script O365\upn.csv "
$x = New-MsolLicenseOptions -AccountSkuId “toto:DESKLESSPACK” -DisabledPlans "FORMS_PLAN_K","STREAM_O365_K","Deskless", "FLOW_O365_S1","POWERAPPS_O365_S1","TEAMS1","Deskless","MCOIMP","SWAY"
foreach ($user in $csv)
{Set-MsolUserLicense -UserPrincipalName $user.upn -LicenseOptions $x
}