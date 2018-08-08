###########################Des-Affectation_de_licence_O365.ps1#########################
# AUTHOR  : Eric PELLOUX 
# DATE    : 11-17-2017
# WEB     : www.groupe-folder.fr
# VERSION : 1.0
#
# COMMENT :  This script is a property of Groupe folder, verify is authenticity with the get-filehash cmdlet
# 
#####################################################################
#############################VERY IMPORTANT:##########################
# Verifiy the presence of the Affectation_de_licence_O365hash.txt and check the hash
#This script has the following functionalities:#######################

#1 Ask for Admin O365 credentials
#2 Ask for user to desaffect 
#3 DesAffect 
#######################################################################


####### Déclaration de variables générales #######
$Domaine =  "toto.com"
$LiveCred = Get-Credential -Credential admin@toto.onmicrosoft.com

####### Connexion WAAD #######
Import-Module msonline
Connect-MsolService -Credential $LiveCred

####### Affectation d'une licence à un utilisateur ######

#Nom d'utilisateur
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.VisualBasic")
$user = [Microsoft.VisualBasic.Interaction]::InputBox( "Saisir le nom de l'utilisateur complet auquel vous souhaitez affecter une licence", "Nom d'utilisateur Office 365", "eric@toto.com")
#Recuperation de la licence actuelle
$lic=(get-msoluser -UserPrincipalName $user).licenses.accountskuid 
##Suppression de la licence
Set-MsolUserLicense -UserPrincipalName $user -RemoveLicenses $lic

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
