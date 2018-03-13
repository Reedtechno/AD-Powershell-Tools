#NAME:  CrossDomains.ps1
#AUTHOR: David Reed, @ReedTechno
#LASTEDIT: 3/13/2018

# Provide FQDN of remote host
$RemoteHost = ''
# Provide Remote Domain Credentials.  ie. domain\username
$cred = Get-Credential


# Sets your Remote Host as a trusted host in WinRM Client Config.  By default, the client will block WinRM access to host that is not on the same domain.
Set-WSManInstance -ResourceURI winrm/config/client -ValueSet @{TrustedHosts=$RemoteHost}

#Create a remote powershell session
$sess = New-PSSession -ComputerName $RemoteHost -Credential $cred
Enter-PSSession $sess



# Close Session
Exit-PSSession 

