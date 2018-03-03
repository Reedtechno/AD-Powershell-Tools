    $staffResults = @()
 
    $StaffMembers = Get-content "C:\temp\phishedusers.txt"
    $StaffMembers.Count
Foreach ($StaffMember in $StaffMembers){
   $staff = get-aduser -filter{userprincipalname -eq $StaffMember}
    # Set-ADUser -Identity $Staff.SamAccountName -ChangePasswordAtLogon $True -whatif
    $staffResults += get-ADUser -Identity $Staff.SamAccountName -Properties * | Select name, passwordlastset
    }

    $staffResults | sort passwordlastset | Export-csv c:\temp\lastpasswordset.csv -NoTypeInformation 
    
