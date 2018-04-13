function Get-ADGroupMemberRecursive {
    <#
    .SYNOPSIS
        Gets AD User and Computer information based on AD Group membership including nested group membership
    .DESCRIPTION
        Gets AD User and Computer information based on AD Group membership.  It will also recurse through nested groups and include all User and Computer objects that are effectively a member of the original group.  i.e Helpdesk group has HD Admins and HD Managers as nested groups.
    .PARAMETER Group
        Name or Group Object to get members from.
    .EXAMPLE
        Get-ADGroupMemberRecursive "Recipient Management" -Properties Name,Enabled,NestedGroup
    .NOTES
        Version 2018.04.13
        By David Reed, @ReedTechno
        https://github.com/Reedtechno/AD-Powershell-Tools

        Huge thanks to Matt Marchese for code review and assistance
        https://github.com/General-Gouda
    #>

    [CmdletBinding()]
    [OutputType([string])]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]$Group,

        [Parameter(Mandatory = $false)]
        $Properties = @(
            "Name",
            "Enabled",
            "SamAccountName",
            "Description",
            "NestedGroup",
            "PasswordLastSet",
            "PasswordNeverExpires",
            "PasswordNotRequired",
            "whenCreated",
            "DNSHostName",
            "OperatingSystem",
            "IPv4Address",
            "IPv6Address",
            "LastLogonDate"
        )
    )
    
    if ("NestedGroup" -in $Properties) {
        $Properties[([array]::IndexOf($Properties, "NestedGroup"))] = @{Name = 'NestedGroup'; Expression = {$RecurseGroup.name}}
    }

    Function RecurseGroup ($RecurseGroup, [Switch]$Nested) {
        
        $GroupMembers = Get-ADGroupMember $RecurseGroup
        if ($Nested -eq $false) {
            $RecurseGroup = ""
        }
        ForEach ($GroupMember in $GroupMembers) {
            $ADObject = Get-ADObject $GroupMember

            if ($ADObject.ObjectClass -eq "user") {
                $Global:AllMembers += Get-ADUser $GroupMember -Properties * | Select-Object $Properties
            }
            elseif ($ADObject.ObjectClass -eq "computer") {
                $Global:AllMembers += Get-ADComputer $GroupMember -Properties * | Select-Object $Properties
            }
            elseif ($ADObject.ObjectClass -eq "group") {
                RecurseGroup $GroupMember -Nested
            }
        }
    }
    $Global:AllMembers = @()
    try {
        $adGroup = Get-ADGroup $Group -ErrorAction Stop
        try{
            RecurseGroup $adGroup
            Return $Global:AllMembers
        } catch {
            Write-Error $_
        }
    } catch {
        Write-Error "Cannot find group: $group `n$_"
    }    
    
}