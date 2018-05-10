#----------------------------------------------------------------------##
# Module Name : AuditServers.ps1
# Created : 11.11.2016
# Created by : Gisli Gudmundsson# LinkedIN : https://is.linkedin.com/in/gisli-gudmundsson-11a77639
# License Usage : #   This code can be used for private use only
#   You may modify this code and distribute
##----------------------------------------------------------------------##
Import-Module ActiveDirectory
Import-Module C:\DynamicDocumentation\Dependencies\DEPMSSQLActions.psm1 -Force

#OU is not needed in this scenario#$OU = "OU=Departments,DC=tstdomain,DC=com"$Environment = "production"functionsetDateStamp($DateParam){
    if($DateParam-ne$null){
        #2016-11-11 17:00:10
        [string]$DateStamp = ([System.Management.ManagementDateTimeConverter]::ToDateTime($DateParam)).ToString("yyyy-MM-dd HH:mm:ss")
    }else{
        #Create a fake date if it is not found
        $DateStamp = "1901-01-01 00:00:00"
    }
    return$DateStamp
}

functiongetOSInformation(){
    #Get All servers in Active Directory
    $DNSHostNames = Get-ADComputer -Filter * | Select-Object DNSHostName
    foreach($DNSHostName in $DNSHostNames){
        #Check if the server is online
        if(Test-Connection -ComputerName $DNSHostName.DNSHostName -Quiet){

            $OSInfos = Get-WmiObject -Class Win32_OperatingSystem -Namespace root/cimv2 -ComputerName $DNSHostName.DNSHostName | Select-Object BootDevice, BuildNumber, BuildType, Caption, CodeSet, CountryCode,CurrentTimeZone,Description,InstallDate,LastBootUpTime,OSArchitecture,SerialNumber,ServicePackMajorVersion,ServicePackMinorVersion,SystemDrive,TotalVirtualMemorySize
            $BiosInfos = Get-WmiObject -Class Win32_BIOS -Namespace root/cimv2 -ComputerName $DNSHostName.DNSHostName | Select-Object SMBIOSBIOSVersion, Manufacturer, Name, SerialNumber, Version, ReleaseDate, Status
            $ProcessorInfos = Get-WmiObject -Class Win32_Processor -Namespace root/cimv2 -ComputerName $DNSHostName.DNSHostName | Select-Object Caption, DeviceID, Manufacturer, MaxClockSpeed, Name, SocketDesignation, CurrentVoltage,NumberOfCores,NumberOfEnabledCore,NumberOfLogicalProcessors,VirtualizationFirmwareEnabled

            $InstallDate = setDateStamp -DateParam $OSInfos.InstallDate
            $LastBootUpTime  = setDateStamp -DateParam $OSInfos.LastBootUpTime
            $BiosReleaseDate  = setDateStamp -DateParam $BiosInfos.BiosReleaseDate    

            addMSSQLOSInformation `
            -ServerName $DNSHostName.DNSHostName `
            -OS_BootDevice $OSInfos.BootDevice `
            -OS_BuildNumber $OSInfos.BuildNumber `
            -OS_BuildType $OSInfos.BuildType `            -OS_Caption $OSInfos.Caption `            -OS_CodeSet $OSInfos.CodeSet `
            -OS_CountryCode $OSInfos.CountryCode `            -OS_CurrentTimeZone $OSInfos.CurrentTimeZone `
            -OS_Description $OSInfos.Description `            -OS_InstallDate $InstallDate `            -OS_LastBootUpTime $LastBootUpTime `
            -OS_Architecture $OSInfos.Architecture `            -OS_SerialNumber $OSInfos.SerialNumber `
            -OS_ServicePackMajorVersion $OSInfos.ServicePackMajorVersion `            -OS_ServicePackMinorVersion $OSInfos.ServicePackMinorVersion `            -OS_SystemDrive $OSInfos.SystemDrive `            -OS_TotalVirtualMemorySize $OSInfos.TotalVirtualMemorySize `            -bios_SMBIOSBIOSVersion $BiosInfos.SMBIOSBIOSVersion `            -bios_Manufacturer $BiosInfos.Manufacturer `            -bios_Name $BiosInfos.Name `            -bios_SerialNumber $BiosInfos.SerialNumber `            -bios_Version $BiosInfos.Version `            -bios_ReleaseDate $BiosReleaseDate `            -bios_Status $BiosInfos.Status `            -cpu_Caption $ProcessorInfos.Caption `            -cpu_Manufacturer $ProcessorInfos.Manufacturer `            -cpu_MaxClockSpeed $ProcessorInfos.MaxClockSpeed `            -cpu_Name $ProcessorInfos.Name `            -cpu_CurrentVoltage $ProcessorInfos.CurrentVoltage `            -cpu_NumberOfCores $ProcessorInfos.NumberOfCores `            -cpu_NumberOfEnabledCore $ProcessorInfos.NumberOfEnabledCore `            -cpu_NumberOfLogicalProcessors $ProcessorInfos.NumberOfLogicalProcessors `            -cpu_VirtualizationFirmwareEnabled $ProcessorInfos.VirtualizationFirmwareEnabled `            -Environment $Environment
        }

    }
}

getOSInformation