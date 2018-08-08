### Enter your input on Line 10 OU that contain all users that need to change user principal name on it 
 
 
Import-Module ActiveDirectory 
 
$ENterDomain = Read-Host 'What is the your routable domain? ie contoso.com' 
  
$routableDomain = $EnterDomain 
 
$users = Get-ADUser -Filter {UserPrincipalName -like '*'} -SearchBase "OU=Users,DC=toto,DC=fr" 
foreach ($user in $users) { 
    $userName = $user.UserPrincipalName.Split('@')[0] 
    $UPN = $userName + "@" + $routableDomain 
     
    Write-Host $user.Name $user.UserPrincipalName $UPN 
 
    $user | Set-ADUser -UserPrincipalName $UPN
    }