# oto.000.global.vars.ps1

write-host "000 Global vars" -foregroundcolor yellow

#
$global:currAccount = [security.principal.windowsidentity]::getcurrent()
$global:adminUser = $currAccount.name 
$global:adminPass = "password"

#
$rootDir = "C:\Users\Administrator\Downloads"
$global:installDbDir = "$rootDir\INSTALL\SDL Tridion 2013\Database\MSSQL"
$global:installCMDir = "$rootDir\INSTALL\SDL Tridion 2013\Content Manager"
$global:installCDDir = "$rootDir\INSTALL\SDL Tridion 2013\Content Delivery"
$global:installLcDir = "$rootDir\INSTALL\SDL Tridion 2013\Licenses"
$global:batchInstall = ".\SilentInstallTridion.cmd"

# mts user account
$global:mtsUsername = "MTSUser"
$global:mtsDomain   = $env:computername
$global:mtsAccount  = "$mtsDomain\$mtsUsername"
$global:mtsPassword = "password"
$global:mtsFullname = "Tridion MTS User"
$global:mtsDescription = "SDL Tridion Service Account"

# database
$global:dbServer = '(local)' # localhost does not work
$global:dbCM = "Tridion_cm"
$global:dbCB = "Tridion_broker"
$global:dbTM = "Tridion_tm"
$global:dbAdminUser     = "sa"
$global:dbAdminPassword = "password"
$global:dbUser     = "TCMDBUSER"
$global:dbPassword = "password"
$global:dbUserBroker     = "TCMBrokerDBUSER"
$global:dbPasswordBroker = "password"
$global:dbUserTM     = "TCMTranslationDBUSER"
$global:dbPasswordTM = "password"

# tcm
$global:tcmPort = 80
$global:tcmProgDir = "C:\Tridion"
$global:tcmWebDir  = "C:\Tridion\web"
$global:tcmLicDir  = "C:\Tridion\licenses" # note that the directory 'Licenses' is the same as the $InstallLcDir due to the recursive filecopy!

# cd
$global:httpUploadDir = "C:\inetpub\wwwroot\httpUploadTestSite"
