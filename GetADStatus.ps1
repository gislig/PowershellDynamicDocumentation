#----------------------------------------------------------------------### Module Name : GetADStatus.ps1# Created : 06.11.2016# Created by : Gisli Gudmundsson# LinkedIN : https://is.linkedin.com/in/gisli-gudmundsson-11a77639# License Usage : #   This code can be used for private use only#   You may modify this code and distribute##----------------------------------------------------------------------##
Import-Module ActiveDirectory
Import-Module C:\DynamicDocumentation\Dependencies\DEPMSSQLActions.psm1 -Force -Verbose

$OU = "OU=Departments,DC=tstdomain,DC=com"
$Environment = "production"


function getUserCount(){
    #Will get users in ad
    $OrganizationalUnits = Get-ADOrganizationalUnit -Filter * -SearchScope OneLevel -SearchBase $OU -Properties adminDescription | where { $_.adminDescription -ne $null } | select adminDescription, DistinguishedName | Sort-Object adminDescription
    foreach($OrganizationalUnit in $OrganizationalUnits){
        $OUUsers = "OU=Users," + $OrganizationalUnit.DistinguishedName
        $CostCenter = $OrganizationalUnit.adminDescription
        
        $TotalEnabledUsers = Get-ADUser -SearchBase $OUUsers -Filter * | where { $_.Enabled -eq $true}
        $TotalDisabledUsers = Get-ADUser -SearchBase $OUUsers -Filter * | where { $_.Enabled -eq $false}

        
        AddMSSQLUserCount -UserCount $TotalEnabledUsers.Count -UserType "Enabled Users" -CostCenter $CostCenter -Environment $Environment
        AddMSSQLUserCount -UserCount $TotalDisabledUsers.Count -UserType "Disabled Users" -CostCenter $CostCenter -Environment $Environment
    }
}

function getADAlerts(){
    #Will figure out who is member of domain admin group
    $DomainAdmins = Get-ADGroupMember -Identity "Domain Admins" | Get-ADUser | select SamAccountName
    $GlobalAdmins = getMSQLGlobalAdmins -Environment $Environment
    $Compare = Compare-Object -ReferenceObject $GlobalAdmins.SamAccountName -DifferenceObject $DomainAdmins.SamAccountName
    
    foreach($C in $Compare){
        $SamAccountName_Alert = $C.InputObject
        addMSSQLADAlerts -UserName $SamAccountName_Alert -Alert "USER IS ASSIGNED TO DOMAIN ADMINS" -Environment $Environment
    }

}

#Main Run the application

getADAlerts
getUserCount