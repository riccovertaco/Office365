 #Add references to SharePoint client assemblies and authenticate to Office 365 site – required for CSOM
        [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client")
        [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client.Runtime")
        [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client.UserProfiles")

        function Get-TimeStamp {
    
         return "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)
    
        }

        

        $sFullPath = "c:\temp\SetOD4BLocaleLog.txt"   
 
         "********************** Begin Logging Time: $(Get-TimeStamp) *******************  " | Out-File $sFullPath -Append

         
       $AdmiUrl = "https://keriagroupe-admin.sharepoint.com/"

        #Specify tenant admin
        $AdmiUser = "folder@keria.com"
        $Pass = Read-Host -Prompt "Please enter your O365 Admin password" -AsSecureString

        $Cred = New-Object System.Management.Automation.PSCredential -ArgumentList $AdmiUser, $pass
        #$Creds = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($AdmiUser,$Cred.Password)
        $Creds = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($AdmiUser,$pass)

        #$Creds = Get-Credential 
        #Configure MySite Host URL
        $SiteURL = "https://keriagroupe-my.sharepoint.com/"


        #Bind to MySite Host Site Collection
$Context = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
$Context.Credentials = $Creds

#Identify users in the Site Collection
$Users = $Context.Web.SiteUsers
$Context.Load($Users)
$Context.ExecuteQuery()

#Create People Manager object to retrieve profile data
$PeopleManager = New-Object Microsoft.SharePoint.Client.UserProfiles.PeopleManager($Context)

    Foreach ($User in $Users)
    {
    $UserProfile = $PeopleManager.GetPropertiesFor($User.LoginName)

    $Context.Load($UserProfile)
    $Context.ExecuteQuery()
    If ($UserProfile.Email -ne $null -and $userProfile.UserProfileProperties.PersonalSpace -ne "")
        {     
          
        #Write-Host "Updating OD4B site for User:" $User.LoginName -ForegroundColor Green
        #Bind to OD4B Site and change locale
        $OD4BSiteURL = $UserProfile.PersonalUrl
        $Context2 = New-Object Microsoft.SharePoint.Client.ClientContext($OD4BSiteURL)

         Foreach ($User in $OD4BSiteURL)
        {
        $Context2.Credentials = $Creds
        $Context2.ExecuteQuery()
        
        $web = $Context2.Web;
        $RegionalSettings = $Context2.Web.RegionalSettings
        $Context2.Load($web);
        $Context2.Load($RegionalSettings);
        $Context2.ExecuteQuery();       

        Write-Host $User 


        #Connect-PnPOnline –Url $OD4BSiteURL -Credentials $Cred

        $LocaleIDVar = $Context2.Web.RegionalSettings.LocaleId

        if ($LocaleIDVar -ne  "1036"){

        "User -> $OD4BSiteURL" | out-file $sFullPath -append

        Connect-SPOService -url $AdmiUrl -credential $Cred
        Set-SPOUser -site $OD4BSiteURL -LoginName $AdmiUser -IsSiteCollectionAdmin $True

        $Context2.Web.RegionalSettings.LocaleId = "1036"
        $Context2.Web.RegionalSettings.TimeZone=$Context2.Web.RegionalSettings.TimeZones.GetbyID("3");
        $Context2.Web.Update()
        $Context2.ExecuteQuery()
        }
    }  

    
    }
    
}

 "********************** End Logging Time: $(Get-TimeStamp) *******************  " | Out-File $sFullPath -Append
