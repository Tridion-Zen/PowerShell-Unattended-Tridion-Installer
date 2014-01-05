param ($wwwTridionInstalled)
#oto.200.cma.ps1

write-host "200 Content Manager" -foregroundcolor yellow

if ($wwwTridionInstalled) {
	write-host "SDL Tridion website already exist, will not reinstall." -foregroundcolor red
	return
}

# copy licenses from install dir to user dir: licDir
write-host "Installing license files: `nCopy from" $installLcDir "`nCopy to  " $tcmLicDir
copy-item -path $installLcDir -filter *.xml -destination $tcmProgDir -recurse -force

$dir = split-path $myinvocation.invocationname
$log = [System.IO.Path]::Combine($dir, "Install Content Manager_" + (Get-Date -Format "HHmmssMMddyyyy") + ".log")

  $params = " ACCEPT_EULA=true "
# $params += " INSTALLLOCATION=$tcmProgDir "
# $params += " WEBLOCATION=$tcmWebDir "
  $params += " LICENSE_PATH=$tcmLicDir\license.xml "
  $params += " CD_LICENSE_PATH=$tcmLicDir\cd_licenses.xml "
# $params += " DB_SERVER=$dbServer "
# $params += " DB_NAME=$dbCM "   
# $params += " DB_USER=$dbUser "
  $params += " DB_PASSWORD=$dbPassword "
# 'DB_TYPE'
# $params += " WEB_PORT=$tcmPort "
# 'WEB_DESCRIPTION' 
# 'WEB_IP'
 
# $params += " SYSTEM_ACCOUNT_NAME=$mtsUsername "
# $params += " SYSTEM_ACCOUNT_DOMAIN=$mtsDomain "
  $params += " SYSTEM_ACCOUNT_PASSWORD=$mtsPassword "
 
# 'LEGACY_VISIBLE'
$params += ' cm_RemovedFeatures="FeatureBusinessConnector" '  
# 'Documentation_SelectedFeatures'
# 'OnlineMarketing_SelectedFeatures'
# 'PostInstaller_SelectedFeatures'
# 'cm_SelectedFeatures'
# 'CMECore_SelectedFeatures'
# 'CMEGui_SelectedFeatures'
# 'SpellChecker_SelectedFeatures'
# 'TemplateBuilder_SelectedFeatures'
# 'Documentation_SelectedFeatures'
# 'ExperienceManager_SelectedFeatures'

$params += ' TranslationManager_SelectedFeatures= '
$params += ' OutboundEmail_SelectedFeatures= '
# $params += ' SDLTridionUGC_SelectedFeatures= '
# $params += ' ExternalContentLibrary_SelectedFeatures= '

$cmd = """$installCMDir\sdltridion2013cm.exe"" -s $params"

write-host "`nCreating installer batch: `nBatchfile" $batchInstall "`nCommand  " $cmd
"$cmd" | out-file $batchInstall -encoding "default"

$folder = (get-childitem env:temp).value
write-host "`nStarting batch installer: `nLogfolder" $folder "`nPlease wait approx. 5 minutes.`nNote: server will automatically reboot after installation of SDL Tridion."
& $batchInstall
