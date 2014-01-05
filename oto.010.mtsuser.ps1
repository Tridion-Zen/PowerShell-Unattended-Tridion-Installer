# oto.000.mtsuser.ps1

write-host "010 Local account" -foregroundcolor yellow

$adsi = [adsi] "WinNT://$env:computername,computer"
$account = $adsi.Children | where { $_.schemaclassname -eq 'user' -and $_.name -eq $mtsUsername}
if ($account) {
    write-host "Found MTSUser =" $account.name "("$account.fullname")"
	write-host "MTSUser already exist, will not recreate." -foregroundcolor red
} else {
    $account = $adsi.create("User", $mtsUsername)
    $account.setinfo()
}

$account.setpassword($mtsPassword)
$account.fullname = $mtsFullname
$account.description = $mtsDescription
$account.userflags = 64 + 65536 # Can't change pwd, don't expire pwd
$account.setinfo()
write-host "Setting password for" $mtsUsername "to" $mtsPassword
