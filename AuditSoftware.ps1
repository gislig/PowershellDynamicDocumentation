#----------------------------------------------------------------------### Module Name : AuditSoftware.ps1# Created : 11.11.2016# Created by : Gisli Gudmundsson# LinkedIN : https://is.linkedin.com/in/gisli-gudmundsson-11a77639# License Usage : #   This code can be used for private use only#   You may modify this code and distribute##----------------------------------------------------------------------##
Import-Module ActiveDirectory
Import-Module C:\DynamicDocumentation\Dependencies\DEPMSSQLActions.psm1 -Force

#OU is not needed in this scenario
#$OU = "OU=Departments,DC=tstdomain,DC=com"
$Environment = "production"

function setDateStamp($DateParam){
    if($DateParam -ne $null){
        $ParseDate = [datetime]::ParseExact($DateParam,"yyyyMMdd",$null)
        $DateStamp = Get-Date -Date $ParseDate -Format "yyyy-MM-dd"    
    }else{
        #Create a fake date if it is not found
        $DateStamp = "1901-01-01"
    }
    return $DateStamp
}

function getSoftwareInformation(){
    #Get All servers in Active Directory
    $DNSHostNames = Get-ADComputer -Filter * | Select-Object DNSHostName
    foreach($DNSHostName in $DNSHostNames){
        #Check if the server is online
        if(Test-Connection -ComputerName $DNSHostName.DNSHostName -Quiet){

            $SoftwareInfos = Get-WmiObject -Class Win32_Product -ComputerName $DNSHostName.DNSHostName | Select-Object Name,HelpLink,InstallDate,InstallLocation,InstallSource,PackageName,Vendor,Version

            foreach($SoftwareInfo in $SoftwareInfos){
                $InstallDate = $null
                $InstallDate = setDateStamp -DateParam $SoftwareInfo.InstallDate

                addMSSQLSoftwareInformation `
                -ServerName $DNSHostName.DNSHostName `                -Name $SoftwareInfo.Name `
                -HelpLink $SoftwareInfo.HelpLink `
                -InstallDate $InstallDate `
                -InstallLocation $SoftwareInfo.InstallLocation `
                -InstallSource $SoftwareInfo.InstallSource `
                -PackageName $SoftwareInfo.PackageName `
                -Vendor $SoftwareInfo.Vendor `
                -Version $SoftwareInfo.Version  `
                -Environment $Environment
            }
        }
    }
}

getSoftwareInformation