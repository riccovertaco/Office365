####### Déclaration de variables générales #######
[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.VisualBasic") 
$Domaine =  [Microsoft.VisualBasic.Interaction]::InputBox( "Saisir le nom du domaine Office 365 que vous voulez gérer", "Nom de domaine Office 365", "Adatumdup7")
$LiveCred = Get-Credential -Credential eric@toto.com

####### Connexion WAAD #######
Import-Module msonline
Connect-MsolService -Credential $LiveCred

####### Connexion Exchange Online #######
$SessionExchangeOnline = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://outlook.office365.com/powershell-liveid/" -Credential $LiveCred -Authentication Basic -AllowRedirection
Import-PSSession $SessionExchangeOnline -AllowClobber

####### Connexion SharePoint Online #######
Import-Module Microsoft.Online.SharePoint.PowerShell
$url= "https://"+$Domaine+"-admin.sharepoint.com"
Connect-SPOService -Url $url -Credential $LiveCred

####### Connexion Lync Online #######
Import-Module LyncOnlineConnector
$sessionLyncOnline = New-CsOnlineSession -Credential $LiveCred
Import-PSSession $sessionLyncOnline

####### Connexion RMS Online #######
Import-Module AADRM
Connect-AadrmService -Credential $LiveCred