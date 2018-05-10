#----------------------------------------------------------------------##
# Powershell Script Name : Debug-sql.ps1
# Created : 27.10.2016
# Created by : Gisli Gudmundsson# LinkedIN : https://is.linkedin.com/in/gisli-gudmundsson-11a77639
# License Usage : 
#   This code can be used for private use only
#   You may modify this code and distribute
##----------------------------------------------------------------------#

Import-Module C:\DynamicDocumentation\Dependencies\DEPMSSQLActions.psm1 -Force -Verbose
$Environment = "production"
$DateTime = "2016-11-11 17:00:10"
$Dater = "2016-11-11"


function checkTable($TableData){
    if($TableData -eq $null){
        Write-Host "Error : Failure to retrieve table data" -ForegroundColor Red
    }else{
        $TableData
    }
}

Write-Host "`n`n"
Write-Host "Running SQL Debug Script" -ForegroundColor Yellow
Write-Host "................................"
Write-Host "1. Trying to add row to ADUsersCount table" -ForegroundColor Cyan
AddMSSQLUserCount -UserCount 50 -UserType "ServiceUsers" -CostCenter "DEBUG" -Environment $Environment
Write-Host "2. Showing debug values in ADUsersCount table" -ForegroundColor Cyan
$TableInfo = DebugShowMSSQLTable -TableName "ADUsersCount" -ColumnName "UserCostCenter" -Environment $Environment 
checkTable -TableData $TableInfo
Write-Host "3. Cleaning up debug in ADUsersCount table" -ForegroundColor Cyan
DebugCleanUpMSSQLUserCount -TableName "ADUsersCount" -ColumnName "UserCostCenter" -Environment $Environment
$TableInfo = $null

Write-Host "4. Trying to add row in AuditServices" -ForegroundColor Cyan
addMSSQLAuditServices -ServiceName "DEBUG" -Caption "DEBUG" -RunningAs "DEBUG" -Notes "DEBUG" -Environment $Environment
Write-Host "5. Trying to show tables in AuditServices" -ForegroundColor Cyan
$TableInfo = DebugShowMSSQLTable -TableName "AuditServices" -ColumnName "ServiceName" -Environment $Environment 
checkTable -TableData $TableInfo
Write-Host "6. Cleaning up debug in AuditServices table" -ForegroundColor Cyan
DebugCleanUpMSSQLUserCount -TableName "AuditServices" -ColumnName "ServiceName" -Environment $Environment
$TableInfo = $null

Write-Host "7. Trying to add row to OSInformation table" -ForegroundColor Cyan
addMSSQLOSInformation -ServerName "DEBUG" -OS_BootDevice "DEBUG" -OS_BuildNumber "DEBUG" -OS_BuildType "DEBUG" -OS_Caption "DEBUG" -OS_CodeSet "DEBUG" -OS_CountryCode "DEBUG" -OS_CurrentTimeZone "DEBUG" -OS_Description "DEBUG" -OS_InstallDate $DateTime -OS_LastBootUpTime $DateTime -OS_Architecture "DEBUG" -OS_SerialNumber "DEBUG" -OS_ServicePackMajorVersion "DEBUG" -OS_ServicePackMinorVersion "DEBUG" -OS_SystemDrive "DEBUG" -OS_TotalVirtualMemorySize "DEBUG" -bios_SMBIOSBIOSVersion "DEBUG" -bios_Manufacturer "DEBUG" -bios_Name "DEBUG" -bios_SerialNumber "DEBUG" -bios_Version "DEBUG" -bios_ReleaseDate $DateTime -bios_Status "DEBUG" -cpu_Caption "DEBUG" -cpu_Manufacturer "DEBUG" -cpu_MaxClockSpeed "DEBUG" -cpu_Name "DEBUG" -cpu_CurrentVoltage "DEBUG" -cpu_NumberOfCores "DEBUG" -cpu_NumberOfEnabledCore "DEBUG" -cpu_NumberOfLogicalProcessors "DEBUG" -cpu_VirtualizationFirmwareEnabled "DEBUG" -Environment $Environment
Write-Host "8. Showing debug values in OSInformation table" -ForegroundColor Cyan
$TableInfo = DebugShowMSSQLTable -TableName "OSInformation" -ColumnName "ServerName" -Environment $Environment 
checkTable -TableData $TableInfo
Write-Host "9. Cleaning up debug in OSInformation table" -ForegroundColor Cyan
DebugCleanUpMSSQLUserCount -TableName "OSInformation" -ColumnName "ServerName" -Environment $Environment
$TableInfo = $null

Write-Host "10. Trying to add row to SoftwareInformation table" -ForegroundColor Cyan
addMSSQLSoftwareInformation -ServerName "DEBUG" -Name "DEBUG" -HelpLink "DEBUG" -InstallDate $Dater -InstallLocation "DEBUG" -InstallSource "DEBUG" -PackageName "DEBUG" -Vendor "DEBUG" -Version "DEBUG" -Environment $Environment
Write-Host "11. Showing debug values in SoftwareInformation table" -ForegroundColor Cyan
$TableInfo = DebugShowMSSQLTable -TableName "SoftwareInformation" -ColumnName "ServerName" -Environment $Environment 
checkTable -TableData $TableInfo
Write-Host "12. Cleaning up debug in OSInformation table" -ForegroundColor Cyan
DebugCleanUpMSSQLUserCount -TableName "SoftwareInformation" -ColumnName "ServerName" -Environment $Environment
$TableInfo = $null