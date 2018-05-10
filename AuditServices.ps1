#----------------------------------------------------------------------##
# Module Name : AuditServices.ps1
# Created : 08.11.2016
# Created by : Gisli Gudmundsson
# LinkedIN : https://is.linkedin.com/in/gisli-gudmundsson-11a77639
# License Usage : 
#   This code can be used for private use only
#   You may modify this code and distribute
##----------------------------------------------------------------------##
Import-Module ActiveDirectory
Import-Module C:\DynamicDocumentation\Dependencies\DEPMSSQLActions.psm1 -Force

#OU is not needed in this scenario#$OU = "OU=Departments,DC=tstdomain,DC=com"$Environment = "production"#This will set the default max days for the service to be required to change password$MaxDays = 30

#Get All servers in Active Directory$DNSHostNames = Get-ADComputer -Filter * | Select-Object DNSHostName
foreach($DNSHostName in $DNSHostNames){
    #Check if the server is online
    if(Test-Connection -ComputerName $DNSHostName.DNSHostName -Quiet){
        #Capture All Services running on server
        $Services = Get-WmiObject Win32_Service -ComputerName $DNSHostName.DNSHostName | Select-Object Name, Caption, StartName, Started | where { $_.StartName -notlike "NT Authority*" -and $_.StartName -notlike "*LocalSystem*" -and $_.StartName -notlike "*NT Service*" }
        foreach($Service in $Services){
            #Audit the service user and add it to the database
            if($Service.StartName -ne$null){
                $UserName = $Services.StartName -split "\\"
                $User = Get-ADUser $UserName[1] -Properties UserPrincipalName, PasswordLastSet | select UserPrincipalName, PasswordLastSet
                $GetDays = New-TimeSpan -Start $User.PasswordLastSet -End (Get-Date)
                $DaysCounted = $GetDays.Days
                $Notes = ""
                if($DaysCounted-gt$MaxDays){
                    
                    $Notes = "User has not change password for at least "+ $DaysCounted + " days, max days are $MaxDays"
                }
            
                addMSSQLAuditServices -ServerName $DNSHostName.DNSHostName -ServiceName $Service.Name -Caption $Service.Caption -RunningAs $Service.StartName -Notes $Notes -Environment $Environment
            }
        }
    }
}