#oto.100.db.cm.ps1

write-host "110 Database Content Broker" -foregroundcolor yellow

# test if content manager database exists
[reflection.assembly]::loadwithpartialname("microsoft.sqlserver.smo") | out-null
$msSql = new-object "microsoft.sqlserver.management.smo.server" $dbServer
$msDb = $msSql.Databases[$dbCB]
if ($msDb) {
	write-host "Found database = $dbCB, created on" $msDb.createdate
	write-host "Content Broker database already exist, will not recreate." -foregroundcolor red
	return
}

$dir = split-path $myinvocation.invocationname
$log = [System.IO.Path]::Combine($dir, "Install Content Data Store_" + (Get-Date -Format "HHmmssMMddyyyy") + ".log")

push-location
set-location $installDbDir

& ".\Install Content Data Store.ps1"             `
	-ni                                 `
	-dbs $dbServer -dbn $dbCB                    `
	-aun $dbAdminUser -aup $dbAdminPassword      `
	-dbun $dbUserBroker -dbup $dbPasswordBroker  
	
pop-location
