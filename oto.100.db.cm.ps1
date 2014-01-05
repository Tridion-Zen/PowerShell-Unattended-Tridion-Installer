#oto.100.db.cm.ps1

write-host "100 Database Content Manager" -foregroundcolor yellow

# test if content manager database exists
[reflection.assembly]::loadwithpartialname("microsoft.sqlserver.smo") | out-null
$msSql = new-object "microsoft.sqlserver.management.smo.server" $dbServer
$msDb = $msSql.Databases[$dbCM]
if ($msDb) {
	write-host "Found database = $dbCM, created on" $msDb.createdate
    write-host "Content Manager database already exist, will not recreate." -foregroundcolor red
	return
}

$dir = split-path $myinvocation.invocationname
$log = [System.IO.Path]::Combine($dir, "Install Content Manager database_" + (Get-Date -Format "HHmmssMMddyyyy") + ".log")
$ntAuthSys = (((New-Object System.Security.Principal.SecurityIdentifier("S-1-5-18")).Translate([System.Security.Principal.NTAccount])).Value)

push-location
set-location $installDbDir

& ".\Install Content Manager database.ps1"                  `
	-ni                                            `
	-dbs $dbServer -dbn $dbCM                               `
	-aun $dbAdminUser -aup $dbAdminPassword                 `
	-dbun $dbUser -dbup $dbPassword                         `
	-mtsusername $mtsAccount -mtsuserpassword $mtsPassword  `
	-defaulttcmadministratorusername $adminUser             `
	-defaulttcmadministratoruserpassword $adminPass         `
	-windowssystemaccountname $ntAuthSys
	
pop-location
