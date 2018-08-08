###########################Affectation_de_licence_O365.ps1#########################
# AUTHOR  : Eric PELLOUX 
# DATE    : 12-14-2017
# WEB     : www.groupe-folder.fr
# VERSION : 1.2
#
# COMMENT :  This script is a property of Groupe folder, verify is authenticity with the get-filehash cmdlet
# 
#####################################################################
#############################VERY IMPORTANT:##########################
# Verifiy the presence of the Affectation_de_licence_O365hash.txt and check the hash
#This script has the following functionalities:#######################

#1 Ask for Admin O365 credentials
#2 Ask for user to affect 
#3 Ask for license
#4 Affect 
#######################################################################


####### Déclaration de variables générales #######
$Domaine =  "toto.com"
$LiveCred = Get-Credential -Credential admin@toto.onmicrosoft.com

####### Connexion WAAD #######
Import-Module msonline
Connect-MsolService -Credential $LiveCred
$skuid= (Get-MsolAccountSku).accountSkuId

#Fonction permettant de récupérer le Tenant, le domaine onmicrosoft 
function GetMSOID {
 
	$iDomain = Get-MsolDomain | where {$_.isinitial -eq $true}
 
	return $iDomain.name
}
#Domaine onmicrosoft
$sMSOID = GetMSOID($null)

#Tenant name
$xDomain = $sMSOID.split(".")
$Tenant = $xdomain[0]


#### Create array variable for Licenses and ServicesName

#Licences
$licenses = @{}
$licenses.Add('AAD_BASIC','Azure Active Directory Basic')
$licenses.Add('AAD_PREMIUM','Azure Active Directory Premium')
$licenses.Add('RIGHTSMANAGEMENT','Azure Active Directory Rights')
$licenses.Add('RIGHTSMANAGEMENT_FACULTY','Azure Active Directory Rights for Faculty')
$licenses.Add('RIGHTSMANAGEMENT_GOV','Azure Active Directory Rights for Government')
$licenses.Add('RIGHTSMANAGEMENT_STUDENT','Azure Active Directory Rights for Students')
$licenses.Add('MFA_STANDALONE','Azure Multi-Factor Authentication Premium Standalone')
$licenses.Add('EMS','Microsoft Enterprise Mobility + Security Suite')
$licenses.Add('EXCHANGESTANDARD_FACULTY','Exchange (Plan 1) for Faculty')
$licenses.Add('EXCHANGESTANDARD_STUDENT','Exchange (Plan 1) for Students')
$licenses.Add('EXCHANGEENTERPRISE_FACULTY','Exchange (Plan 2) for Faculty')
$licenses.Add('EXCHANGEENTERPRISE_STUDENT','Exchange (Plan 2) for Students')
$licenses.Add('EXCHANGEARCHIVE','Exchange Archiving')
$licenses.Add('EXCHANGEARCHIVE_FACULTY','Exchange Archiving for Faculty')
$licenses.Add('EXCHANGEARCHIVE_GOV','Exchange Archiving for Government')
$licenses.Add('EXCHANGEARCHIVE_STUDENT','Exchange Archiving for Students')
$licenses.Add('EXCHANGESTANDARD_GOV','Exchange for Government (Plan 1G)')
$licenses.Add('EXCHANGEENTERPRISE_GOV','Exchange for Government (Plan 2G)')
$licenses.Add('EXCHANGEDESKLESS','Exchange Kiosk')
$licenses.Add('EXCHANGEDESKLESS_GOV','Exchange Kiosk for Government')
$licenses.Add('EXCHANGESTANDARD','Exchange Plan 1')
$licenses.Add('EXCHANGEENTERPRISE','Exchange Plan 2')
$licenses.Add('EOP_ENTERPRISE_FACULTY','Exchange Protection for Faculty')
$licenses.Add('EOP_ENTERPRISE_GOV','Exchange Protection for Government')
$licenses.Add('EOP_ENTERPRISE_STUDENT','Exchange Protection for Student')
$licenses.Add('EXCHANGE_ONLINE_WITH_ONEDRIVE_LITE','Exchange with OneDrive for Business')
$licenses.Add('INTUNE_A','Intune')
$licenses.Add('MCOIMP_FACULTY','Lync (Plan 1) for Faculty')
$licenses.Add('MCOIMP_STUDENT','Lync (Plan 1) for Students')
$licenses.Add('MCOSTANDARD_FACULTY','Lync (Plan 2) for Faculty')
$licenses.Add('MCOSTANDARD_STUDENT','Lync (Plan 2) for Students')
$licenses.Add('MCOVOICECONF','Lync (Plan 3)')
$licenses.Add('MCOIMP_GOV','Lync for Government (Plan 1G)')
$licenses.Add('MCOSTANDARD_GOV','Lync for Government (Plan 2G)')
$licenses.Add('MCOVOICECONF_GOV','Lync for Government (Plan 3G)')
$licenses.Add('MCOINTERNAL','Lync Internal Incubation and Corp to Cloud')
$licenses.Add('MCOIMP','Skype Plan 1')
$licenses.Add('MCOSTANDARD','Skype Plan 2')
$licenses.Add('MCOVOICECONF_FACULTY','Lync Plan 3 for Faculty')
$licenses.Add('MCOVOICECONF_STUDENT','Lync Plan 3 for Students')
$licenses.Add('CRMENTERPRISE','Microsoft Dynamics CRM Online Enterprise')
$licenses.Add('CRMSTANDARD_GCC','Microsoft Dynamics CRM Online Government Professional')
$licenses.Add('CRMSTANDARD','Microsoft Dynamics CRM Online Professional')
$licenses.Add('DMENTERPRISE','Microsoft Dynamics Marketing Online Enterprise')
$licenses.Add('INTUNE_O365_STANDALONE','Mobile Device Management for Office 365')
$licenses.Add('OFFICE_BASIC','Office 365 Basic')
$licenses.Add('O365_BUSINESS','Office 365 Business')
$licenses.Add('O365_BUSINESS_ESSENTIALS','Office 365 Business Essentials')
$licenses.Add('O365_BUSINESS_PREMIUM','Office 365 Business Premium')
$licenses.Add('DEVELOPERPACK','Office 365 Developer')
$licenses.Add('DEVELOPERPACK_GOV','Office 365 Developer for Government')
$licenses.Add('EDUPACK_FACULTY','Office 365 Education for Faculty')
$licenses.Add('EDUPACK_STUDENT','Office 365 Education for Students')
$licenses.Add('EOP_ENTERPRISE','Office 365 Exchange Protection Enterprise')
$licenses.Add('EOP_ENTERPRISE_PREMIUM','Office 365 Exchange Protection Premium')
$licenses.Add('STANDARDPACK_GOV','Office 365 for Government (Plan G1)')
$licenses.Add('STANDARDWOFFPACK_GOV','Office 365 for Government (Plan G2)')
$licenses.Add('ENTERPRISEPACK_GOV','Office 365 for Government (Plan G3)')
$licenses.Add('ENTERPRISEWITHSCAL_GOV','Office 365 for Government (Plan G4)')
$licenses.Add('DESKLESSPACK_GOV','Office 365 for Government (Plan F1G)')
$licenses.Add('STANDARDPACK_FACULTY','Office 365 Plan A1 for Faculty')
$licenses.Add('STANDARDPACK_STUDENT','Office 365 Plan A1 for Students')
$licenses.Add('STANDARDWOFFPACK_FACULTY','Office 365 Plan A2 for Faculty')
$licenses.Add('STANDARDWOFFPACK_STUDENT','Office 365 Plan A2 for Students')
$licenses.Add('ENTERPRISEPACK_FACULTY','Office 365 Plan A3 for Faculty')
$licenses.Add('ENTERPRISEPACK_STUDENT','Office 365 Plan A3 for Students')
$licenses.Add('ENTERPRISEWITHSCAL_FACULTY','Office 365 Plan A4 for Faculty')
$licenses.Add('ENTERPRISEWITHSCAL_STUDENT','Office 365 Plan A4 for Students')
$licenses.Add('STANDARDPACK','Office 365 Plan E1')
$licenses.Add('STANDARDWOFFPACK','Office 365 Plan E2')
$licenses.Add('ENTERPRISEPACK','Office 365 Plan E3')
$licenses.Add('ENTERPRISEWITHSCAL','Office 365 Plan E4')
$licenses.Add('DESKLESSPACK','Office 365 Plan F1')
$licenses.Add('DESKLESSPACK_YAMMER','Office 365 Plan F1 with Yammer')
$licenses.Add('OFFICESUBSCRIPTION','Office Professional Plus')
$licenses.Add('OFFICESUBSCRIPTION_FACULTY','Office Professional Plus for Faculty')
$licenses.Add('OFFICESUBSCRIPTION_GOV','Office Professional Plus for Government')
$licenses.Add('OFFICESUBSCRIPTION_STUDENT','Office Professional Plus for Students')
$licenses.Add('WACSHAREPOINTSTD_FACULTY','Office Web Apps (Plan 1) For Faculty')
$licenses.Add('WACSHAREPOINTSTD_STUDENT','Office Web Apps (Plan 1) For Students')
$licenses.Add('WACSHAREPOINTSTD_GOV','Office Web Apps (Plan 1G) for Government')
$licenses.Add('WACSHAREPOINTENT_FACULTY','Office Web Apps (Plan 2) For Faculty')
$licenses.Add('WACSHAREPOINTENT_STUDENT','Office Web Apps (Plan 2) For Students')
$licenses.Add('WACSHAREPOINTENT_GOV','Office Web Apps (Plan 2G) for Government')
$licenses.Add('WACSHAREPOINTSTD','Office Web Apps with SharePoint Plan 1')
$licenses.Add('WACSHAREPOINTENT','Office Web Apps with SharePoint Plan 2')
$licenses.Add('ONEDRIVESTANDARD','OneDrive for Business')
$licenses.Add('ONEDRIVESTANDARD_GOV','OneDrive for Business for Government (Plan 1G)')
$licenses.Add('WACONEDRIVESTANDARD','OneDrive for Business with Office Web Apps')
$licenses.Add('WACONEDRIVESTANDARD_GOV','OneDrive for Business with Office Web Apps for Government')
$licenses.Add('PARATURE_ENTERPRISE','Parature Enterprise')
$licenses.Add('PARATURE_ENTERPRISE_GOV','Parature Enterprise for Government')
$licenses.Add('POWER_BI_STANDARD','Power BI')
$licenses.Add('POWER_BI_STANDALONE','Power BI for Office 365')
$licenses.Add('POWER_BI_STANDALONE_FACULTY','Power BI for Office 365 for Faculty')
$licenses.Add('POWER_BI_STANDALONE_STUDENT','Power BI for Office 365 for Students')
$licenses.Add('PROJECTESSENTIALS','Project Essentials')
$licenses.Add('PROJECTESSENTIALS_GOV','Project Essentials for Government')
$licenses.Add('PROJECTONLINE_PLAN_1','Project Plan 1')
$licenses.Add('PROJECTONLINE_PLAN_1_FACULTY','Project Plan 1 for Faculty')
$licenses.Add('PROJECTONLINE_PLAN_1_GOV','Project Plan 1for Government')
$licenses.Add('PROJECTONLINE_PLAN_1_STUDENT','Project Plan 1 for Students')
$licenses.Add('PROJECTONLINE_PLAN_2','Project Plan 2')
$licenses.Add('PROJECTONLINE_PLAN_2_FACULTY','Project Plan 2 for Faculty')
$licenses.Add('PROJECTONLINE_PLAN_2_GOV','Project Plan 2 for Government')
$licenses.Add('PROJECTONLINE_PLAN_2_STUDENT','Project Plan 2 for Students')
$licenses.Add('PROJECTCLIENT','Project Pro for Office 365')
$licenses.Add('PROJECTCLIENT_FACULTY','Project Pro for Office 365 for Faculty')
$licenses.Add('PROJECTCLIENT_GOV','Project Pro for Office 365 for Government')
$licenses.Add('PROJECTCLIENT_STUDENT','Project Pro for Office 365 for Students')
$licenses.Add('SHAREPOINTSTANDARD_FACULTY','SharePoint (Plan 1) for Faculty')
$licenses.Add('SHAREPOINTSTANDARD_STUDENT','SharePoint (Plan 1) for Students')
$licenses.Add('SHAREPOINTSTANDARD_YAMMER','SharePoint (Plan 1) with Yammer')
$licenses.Add('SHAREPOINTENTERPRISE_FACULTY','SharePoint (Plan 2) for Faculty')
$licenses.Add('SHAREPOINTENTERPRISE_STUDENT','SharePoint (Plan 2) for Students')
$licenses.Add('SHAREPOINTENTERPRISE_YAMMER','SharePoint (Plan 2) with Yammer')
$licenses.Add('SHAREPOINTSTANDARD_GOV','SharePoint for Government (Plan 1G)')
$licenses.Add('SHAREPOINTENTERPRISE_GOV','SharePoint for Government (Plan 2G)')
$licenses.Add('SHAREPOINTDESKLESS','SharePoint Kiosk')
$licenses.Add('SHAREPOINTSTANDARD','SharePoint Plan 1')
$licenses.Add('SHAREPOINTENTERPRISE','SharePoint Plan 2')
$licenses.Add('SMB_BUSINESS','SMB Business')
$licenses.Add('SMB_BUSINESS_ESSENTIALS','SMB Business Essentials')
$licenses.Add('SMB_BUSINESS_PREMIUM','SMB Business Premium')
$licenses.Add('VISIOCLIENT','Visio Pro for Office 365')
$licenses.Add('VISIOCLIENT_FACULTY','Visio Pro for Office 365 for Faculty')
$licenses.Add('VISIOCLIENT_GOV','Visio Pro for Office 365 for Government')
$licenses.Add('VISIOCLIENT_STUDENT','Visio Pro for Office 365 for Students')
$licenses.Add('YAMMER_ENTERPRISE_STANDALONE','Yammer Enterprise Standalone')
$licenses.Add('RIGHTSMANAGEMENT_ADHOC','Azure Rights Management Service')
$licenses.Add('ENTERPRISEPREMIUM','Office 365 Enterprise E5')

#Services
$services = @{}
$services.Add('AAD_BASIC','Azure Active Directory Basic')
$services.Add('AAD_PREMIUM','Azure Active Directory Premium')
$services.Add('MFA_PREMIUM','Azure Multi-Factor Authentication')
$services.Add('RMS_S_ENTERPRISE','Azure Information Protection')
$services.Add('RMS_S_ENTERPRISE_GOV','Azure Information Protection for Government')
$services.Add('SHAREPOINT_DUET_EDU','Duet Online for Academics')
$services.Add('SHAREPOINT_DUET_GOV','Duet Online for Government')
$services.Add('EXCHANGE_S_STANDARD','Exchange Online (Plan 1)')
$services.Add('EXCHANGE_S_STANDARD_GOV','Exchange Online (Plan 1) for Government')
$services.Add('EXCHANGE_S_ENTERPRISE','Exchange Online (Plan 2)')
$services.Add('EXCHANGE_S_ENTERPRISE_GOV','Exchange Online (Plan 2) for Government')
$services.Add('EXCHANGE_S_ARCHIVE','Exchange Online Archiving')
$services.Add('EXCHANGE_S_ARCHIVE_GOV','Exchange Online Archiving for Government')
$services.Add('EXCHANGE_S_DESKLESS','Exchange Online Kiosk')
$services.Add('EXCHANGE_S_DESKLESS_GOV','Exchange Online Kiosk for Government')
$services.Add('EOP_ENTERPRISE','Exchange Online Protection')
$services.Add('EOP_ENTERPRISE_GOV','Exchange Online Protection for Government')
$services.Add('INTUNE_A','Intune')
$services.Add('MCOIMP','Skype for Business Online (formerly Lync Online) (Plan 1)')
$services.Add('MCOIMP_GOV','Skype for Business Online (Plan 1) for Government')
$services.Add('MCOSTANDARD','Skype for Business Online (Plan 2)')
$services.Add('MCOSTANDARD_GOV','Skype for Business Online (Plan 2) for Government')
$services.Add('MCOVOICECONF','Skype for Business Online (Plan 3)')
$services.Add('MCOVOICECONF_GOV','Skype for Business Online (Plan 3) for Government')
$services.Add('CRMENTERPRISE','Microsoft Dynamics CRM Online Enterprise')
$services.Add('CRMSTANDARD_GCC','Microsoft Dynamics CRM Online Government Professional')
$services.Add('CRMSTANDARD','Microsoft Dynamics CRM Online Professional')
$services.Add('DMENTERPRISE','Microsoft Dynamics Marketing Online Enterprise')
$services.Add('MDM_SALES_COLLABORATION','Microsoft Dynamics Marketing Sales Collaboration')
$services.Add('SQL_IS_SSIM','Microsoft Power BI Information Services Plan 1')
$services.Add('BI_AZURE_P1','Microsoft Power BI Reporting and Analytics Plan 1')
$services.Add('BI_AZURE_P2','Microsoft Power BI Reporting and Analytics Plan 2')
$services.Add('NBENTERPRISE','Microsoft Social Listening Enterprise')
$services.Add('NBPROFESSIONALFORCRM','Microsoft Social Listening Professional')
$services.Add('INTUNE_O365','Mobile Device Management for Office 365')
$services.Add('OFFICE_BUSINESS','Office 365 Business')
$services.Add('OFFICESUBSCRIPTION','Office 365 ProPlus')
$services.Add('OFFICESUBSCRIPTION_GOV','Office 365 ProPlus for Government')
$services.Add('OFFICE_PRO_PLUS_SUBSCRIPTION_SMBIZ','Office 365 Small Business Subscription')
$services.Add('SHAREPOINTWAC','Office Online')
$services.Add('SHAREPOINTWAC_DEVELOPER','Office Online Developer')
$services.Add('SHAREPOINTWAC_EDU','Office Online EDU')
$services.Add('SHAREPOINTWAC_DEVELOPER_GOV','Office Online for Government Developer')
$services.Add('SHAREPOINTWAC_GOV','Office Online for Government')
$services.Add('ONEDRIVESTANDARD','OneDrive for Business (Plan 1)')
$services.Add('ONEDRIVESTANDARD_GOV','OneDrive for Business (Plan 1) for Government')
$services.Add('ONEDRIVELITE','OneDrive for Business Lite')
$services.Add('PARATURE_ENTERPRISE','Parature Enterprise')
$services.Add('PARATURE_ENTERPRISE_GOV','Parature Enterprise for Government')
$services.Add('BI_AZURE_P0','Power BI')
$services.Add('PROJECT_ESSENTIALS','Project Lite')
$services.Add('PROJECT_ESSENTIALS_GOV','Project Lite for Government')
$services.Add('SHAREPOINT_PROJECT','Project Online')
$services.Add('SHAREPOINT_PROJECT_EDU','Project Online for Academics')
$services.Add('SHAREPOINT_PROJECT_GOV','Project Online for Government')
$services.Add('PROJECT_CLIENT_SUBSCRIPTION','Project Pro for Office 365')
$services.Add('PROJECT_CLIENT_SUBSCRIPTION_GOV','Project Pro for Office 365 for Government')
$services.Add('SHAREPOINTSTANDARD','SharePoint Online (Plan 1)')
$services.Add('SHAREPOINTSTANDARD_EDU','SharePoint Online (Plan 1) for Academics')
$services.Add('SHAREPOINTSTANDARD_GOV','SharePoint Online (Plan 1) for Government')
$services.Add('SHAREPOINTENTERPRISE','SharePoint Online (Plan 2)')
$services.Add('SHAREPOINTENTERPRISE_EDU','SharePoint Online (Plan 2) for Academics')
$services.Add('SHAREPOINTENTERPRISE_GOV','SharePoint Online (Plan 2) for Government')
$services.Add('SHAREPOINT_S_DEVELOPER','SharePoint Online for Developer')
$services.Add('SHAREPOINT_S_DEVELOPER_GOV','SharePoint Online for Government Developer')
$services.Add('SHAREPOINTDESKLESS','SharePoint Online Kiosk')
$services.Add('SHAREPOINTDESKLESS_GOV','SharePoint Online Kiosk for Government')
$services.Add('VISIO_CLIENT_SUBSCRIPTION','Visio Pro for Office 365')
$services.Add('VISIO_CLIENT_SUBSCRIPTION_GOV','Visio Pro for Office 365 for Government')
$services.Add('YAMMER_ENTERPRISE','Yammer Enterprise')
$services.Add('YAMMER_EDU','Yammer for Academic For Academics')

$services.Add('FLOW_O365_P2','Flow for Office 365 P2')
$services.Add('POWERAPPS_O365_P2','PowerApps for Office 365 P2')
$services.Add('TEAMS1','Microsoft Teams')
$services.Add('PROJECTWORKMANAGEMENT','Microsoft Planner')
$services.Add('SWAY','SWAY')
$services.Add('Deskless','Microsoft StaffHub')

$services.Add('FLOW_O365_P3','Flow for Office 365 P3')
$services.Add('POWERAPPS_O365_P3','PowerApps for Office 365 P3')
$services.Add('ADALLOM_S_O365','Office 365 Advanced Security Management')
$services.Add('EQUIVIO_ANALYTICS','Office 365 Advanced eDiscovery')
$services.Add('LOCKBOX_ENTERPRISE','Customer Lockbox')
$services.Add('EXCHANGE_ANALYTICS','Microsoft MyAnalytics')
$services.Add('ATP_ENTERPRISE','Exchange Online Advanced Threat Protection (These licenses do not need to be individually assigned)')
$services.Add('MCOEV','Skype for Business Cloud PBX')
$services.Add('MCOMEETADV','Skype for Business PSTN Conferencing')


####### Affectation d'une licence à un utilisateur ######

#Nom d'utilisateur
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.VisualBasic")
$user = [Microsoft.VisualBasic.Interaction]::InputBox( "Saisir le nom de l'utilisateur complet auquel vous souhaitez affecter une licence", "Nom d'utilisateur Office 365", "eric@keria.com")


#Quelle licence
#Ouvre une fenêtre.
[reflection.assembly]::LoadWithPartialName("System.Windows.Forms")
$form1 = New-Object Windows.Forms.Form
$form1.text = "Quelle licence?"            
$form1.Size = New-Object System.Drawing.Size(200,200)
#Ajout d'un texte
$texte= New-object System.Windows.Forms.Label
$texte.Text = " Quelle licence?"
$form1.controls.add($texte)
#Liste déroulante (ComboBox).
$liste1 = New-Object System.Windows.Forms.Combobox
$liste1.Location = New-Object Drawing.Point (20,30)
$liste1.Size = New-Object System.Drawing.Size(150,30)
$liste1.DropDownStyle = "DropDownList"


foreach ($sku in $skuid)
    { 
    $ite = ""
    $ite = $sku.split(":")[1]
    $te = $licenses.GetEnumerator()|?{$_.Key -eq $ite}
            if($te.Value){
                [void] $liste1.Items.Add($te.Value)                 
            }
            else{
                [void] $liste1.Items.Add($ite)      
            }
}
$liste1.SelectedIndex = 0
#Attache le contrôle à la fenêtre
$form1.controls.add($liste1)
#Affiche la sélection.
write-host "ComboBox = " $liste1.Text
$button1 = New-Object System.Windows.Forms.Button
$button1.Text = "OK"
$button1.DialogResult = "Ok"
$Button1.Size = New-Object System.Drawing.Size(100,23)
$button1.Location = New-Object System.Drawing.Size(40,80) 
$form1.controls.add($button1)
#Affiche le tout.
$form1.ShowDialog()
#Fin.
 
##### Affectation à la carte E1#######
#FORMS_PLAN_E1#STREAM_O365_E1#Deskless#FLOW_O365_P1#POWERAPPS_O365_P1#TEAMS1#SHAREPOINTWAC#PROJECTWORKMANAGEMENT#SWAY#INTUNE_O365#YAMMER_ENTERPRISE#MCOSTANDARD#SHAREPOINTSTANDARD#EXCHANGE_S_STANDARD#FORMS_PLAN_E3#STREAM_O365_E3#Deskless#FLOW_O365_P2#POWERAPPS_O365_P2#TEAMS1#PROJECTWORKMANAGEMENT#SWAY#INTUNE_O365#YAMMER_ENTERPRISE#RMS_S_ENTERPRISE#OFFICESUBSCRIPTION#MCOSTANDARD#SHAREPOINTWAC#SHAREPOINTENTERPRISE#EXCHANGE_S_ENTERPRISE


##### Affectation à la carte E3#######
#FORMS_PLAN_E3
#STREAM_O365_E3
#Deskless
#FLOW_O365_P2
#POWERAPPS_O365_P2
#TEAMS1
#PROJECTWORKMANAGEMENT
#SWAY
#INTUNE_O365
#YAMMER_ENTERPRISE
#RMS_S_ENTERPRISE
#OFFICESUBSCRIPTION
#MCOSTANDARD
#SHAREPOINTWAC
#SHAREPOINTENTERPRISE
#EXCHANGE_S_ENTERPRISE

##### Affectation à la carte F1#######     
#FORMS_PLAN_K                    
#STREAM_O365_K                               
#FLOW_O365_S1                 
#POWERAPPS_O365_S1                           
#TEAMS1        
#Deskless                  
#MCOIMP                  
#SHAREPOINTWAC                    
#SWAY        
#INTUNE_O365          
#YAMMER_ENTERPRISE          
#SHAREPOINTDESKLESS      
#EXCHANGE_S_DESKLESS

#Recupêration du nom technique de la licence choisie
$te1licenses = $licenses.GetEnumerator()|?{$_.Value -eq $liste1.SelectedItem}

#Remise en forme de l'AccountSkuId 
$lic = ($tenant + ":" + $te1licenses.name)


#Attribution de la licence complète choisie
Set-MsolUser -UserPrincipalName $user -UsageLocation FR
Set-MsolUserLicense -UserPrincipalName $user -AddLicenses $lic


#Attribution spécifique à un client 

#Si licence E1 choisie 
if ($te1licenses.name -eq "STANDARDPACK")
   {
   $licenseE1 = New-MsolLicenseOptions -AccountSkuId $lic -DisabledPlans "FORMS_PLAN_E1","STREAM_O365_E1","Deskless", "FLOW_O365_P1","POWERAPPS_O365_P1","TEAMS1","SWAY", "MCOSTANDARD","BPOS_S_TODO_1"
   Set-MsolUserLicense -UserPrincipalName $user -licenseOptions $licenseE1
    }
#Si licence E3 choisie
elseif ($te1licenses.name -eq "ENTERPRISEPACK")
    {
    $licenseE3= New-MsolLicenseOptions -AccountSkuId $lic -DisabledPlans "FORMS_PLAN_E3","STREAM_O365_E3","Deskless", "FLOW_O365_P2","POWERAPPS_O365_P2","TEAMS1","SWAY","PROJECTWORKMANAGEMENT","RMS_S_ENTERPRISE","BPOS_S_TODO_2"
    Set-MsolUserLicense -UserPrincipalName $user -licenseOptions $licenseE3
    }
#Si licence F1 choisie
elseif ($te1licenses.name -eq "DESKLESSPACK")
    {
    $licenseF1 = New-MsolLicenseOptions -AccountSkuId $lic -DisabledPlans "FORMS_PLAN_K","STREAM_O365_K","Deskless", "FLOW_O365_S1","POWERAPPS_O365_S1","TEAMS1","Deskless","MCOIMP","SWAY","YAMMER_ENTERPRISE","BPOS_S_TODO_FIRSTLINE"
    Set-MsolUserLicense -UserPrincipalName $user -licenseOptions $licenseF1
    }
