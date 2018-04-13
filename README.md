# AD-Powershell-Tools

## Get-ADGroupMemberRecursive.ps1
Gets AD User and Computer information based on AD Group membership.  It will also recurse through nested groups and include all User and Computer objects that are effectively a member of the original group.  i.e Helpdesk group has HD Admins and HD Managers as nested groups.

## CrossDomains.ps1
Create a Remote Powershell session from a non-domain system.  Often used for managing multiple domains that don't have a trust relationship.  ie. Production laptop remoting into Test Domain DC.

