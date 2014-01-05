# oto.000.ps1
# set-executionpolicy "allsigned"

cls
write-host "000 Prerequisites" -foregroundcolor yellow

$psVersion = (get-host).version
write-host "PowerShell version =" $psVersion

$dir = split-path $myinvocation.invocationname
& "$dir\oto.000.global.vars.ps1"

$adminRole = (new-object security.principal.windowsprincipal $currAccount).isinrole([security.principal.windowsbuiltinrole]::administrator)
write-host "User =" $adminUser "; admin-rights =" $adminRole

$win32 = ([intptr]::size) -eq 4
$win64 = ([intptr]::size) -eq 8
write-host "x86 arch =" $win32 "; x64 arch =" $win64

import-module servermanager
start-sleep -seconds 2
$appServ = get-windowsfeature application-server
if ($appServ.installed -eq $false) { 
	add-windowsfeature application-server
	write-host "Added server role = APPLICATION SERVER"
    start-sleep -s 5
} else { write-host "Installed role =" $appServ.displayname }

$webServ = get-windowsfeature web-server
if ($webServ.installed -eq $false) { 
	add-windowsfeature web-server
	write-host "Added server role = WEB SERVER"
    start-sleep -s 5
} else { write-host "Installed role =" $webServ.displayname }

import-module webadministration 
start-sleep -seconds 2
$sites = get-childitem iis:\sites
$foundTridionWebsite = $false
foreach ($site in $sites) {
	$ports = $site.bindings.collection.bindinginformation
    $name = $site | select -expandproperty name
	write-host "Found website =" $name "on port" $ports
	if ($ports -eq '*:80:' -and $tcmPort -eq 80 -and $name -eq "Default Web Site") { 
        remove-item 'IIS:\Sites\Default Web Site' -confirm
	}
	if ($ports -eq ":80:" -and $tcmPort -eq 80 -and $name -like "*Tridion*") { 
        write-host "SDL Tridion website already exist on port 80, will not reinstall." -foregroundcolor red
		$foundTridionWebsite = $true
	}
}

& "$dir\oto.010.mtsuser.ps1"
& "$dir\oto.100.db.cm.ps1"
& "$dir\oto.110.db.broker.ps1"
& "$dir\oto.120.db.tm.ps1"
& "$dir\oto.200.cms.ps1" $foundTridionWebsite
& "$dir\oto.300.cd.htu.ps1"

