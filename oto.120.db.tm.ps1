#oto.100.db.cm.ps1

write-host "120 Database Translation Manager" -foregroundcolor yellow

# test if content manager database exists
[reflection.assembly]::loadwithpartialname("microsoft.sqlserver.smo") | out-null
$msSql = new-object "microsoft.sqlserver.management.smo.server" $dbServer
$msDb = $msSql.Databases[$dbTM]
if ($msDb) {
	write-host "Found database = $dbTM, created on" $msDb.createdate
    write-host "Translation Manager database already exist, will not recreate." -foregroundcolor red
	return
}

$dir = split-path $myinvocation.invocationname
$log = [System.IO.Path]::Combine($dir, "Install Translation Manager database_" + (Get-Date -Format "HHmmssMMddyyyy") + ".log")

push-location
set-location $installDbDir

& ".\Install Translation Manager Database.ps1"   `
	-ni                                 `
	-dbs $dbServer -dbn $dbTM                    `
	-aun $dbAdminUser -aup $dbAdminPassword      `
	-dbun $dbUserTM -dbup $dbPasswordTM  
	
pop-location
