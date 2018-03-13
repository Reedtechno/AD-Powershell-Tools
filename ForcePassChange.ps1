#NAME:  LastPassSet
#AUTHOR: David Reed, @ReedTechno
#LASTEDIT: 3/12/2018
    

$Accounts = Get-content "C:\PATH\file.txt" #List should be UPNs ie. user@domain.com
$ExportPath = "C:\PATH\File.csv"

$Results = @()
Write-Output "Number of Accounts in list: " $Accounts.Count
Foreach ($Account in $Accounts){
$User = get-aduser -filter{userprincipalname -eq $Account}
Set-ADUser -Identity $User.SamAccountName -ChangePasswordAtLogon $True -whatif
$Results += get-ADUser -Identity $User.SamAccountName -Properties * | Select-Object name, passwordlastset
}

Write-Output "Saving output to:" $ExportPath
$Results | Sort-Object passwordlastset | Export-csv $ExportPath -NoTypeInformation 

