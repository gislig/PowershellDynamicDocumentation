#----------------------------------------------------------------------### Module Name : DEPMSSQLActions.psm1# Created : 27.10.2016# Created by : Gisli Gudmundsson# LinkedIN : https://is.linkedin.com/in/gisli-gudmundsson-11a77639# License Usage : #   This code can be used for private use only#   You may modify this code and distribute##----------------------------------------------------------------------##Import the SQL Server Powershell Module
Import-Module SqlServer

#Import custom made modules
Import-Module C:\DynamicDocumentation\Settings\GlobalVariables.psm1 -Force

#Usage "RunQuery -Query $Query"
function RunQuery($Query, $Environment){
    $ServerInstance = ServerInstance
    $DatabaseName = DatabaseEnvironment -Environment $Environment

    #Runs specific query that is added to the parameter
    Invoke-Sqlcmd -Query $Query -ServerInstance $ServerInstance -Database $DatabaseName
}

function RunSelectQuery($Query, $Environment){
    $ServerInstance = ServerInstance
    $DatabaseName = DatabaseEnvironment -Environment $Environment

    #Runs specific query that is added to the parameter
    return Invoke-Sqlcmd -Query $Query -ServerInstance $ServerInstance -Database $DatabaseName
}

#Usage "AddMSSQLUserCount -UserCount $Integer -UserType $StringMax50Chars -CostCenter $StringMax50Chars
function AddMSSQLUserCount($UserCount, $UserType, $CostCenter, $Environment){
    #Adds new row into the database
    $Insert_Query = "
    INSERT INTO ADUsersCount (UserCount, UserType, UserCostCenter) VALUES ('$UserCount','$UserType','$CostCenter')
    "
    #Calls the Run-Query function
    RunQuery -Query $Insert_Query -Environment $Environment
}

function addMSSQLADAlerts($UserName, $Alert, $Environment){
   #Adds new row into the database
    $Insert_Query = "
    INSERT INTO ADAlerts (UserName, Alert) VALUES ('$UserName','$Alert')
    "
    #Calls the Run-Query function
    RunQuery -Query $Insert_Query -Environment $Environment
}


function getMSQLGlobalAdmins($Environment){
    $Select_Query = "
    SELECT * FROM ADGlobalAdmins
    "
    $GlobalAdmins = RunSelectQuery -Query $Select_Query -Environment $Environment
    return $GlobalAdmins
}

#Usage "DebugShowMSSQLTable -TableName"
function DebugShowMSSQLTable($TableName, $ColumnName, $Environment){
    $Show_Query = "
    SELECT * FROM $TableName WHERE $ColumnName = 'DEBUG'
    "
    RunQuery -Query $Show_Query -Environment $Environment
}

#Usage "DebugCleanUpMSSQLUserCount -TableName $TableName -ColumnName $ColumnName -Environment $Environment"
function DebugCleanUpMSSQLUserCount($TableName, $ColumnName, $Environment){
    #Removes all data where debug row inserts has been added
    $Clean_Query = "
    DELETE FROM $TableName
    WHERE $ColumnName = 'DEBUG'
    "
    RunQuery -Query $Clean_Query -Environment $Environment
}

function addMSSQLAuditServices($ServerName, $ServiceName, $Caption, $RunningAs, $Notes, $Environment){
   #Adds new row into the database
    $Insert_Query = "
    INSERT INTO AuditServices (ServerName, ServiceName, Caption, RunningAs, Notes) VALUES ('$ServerName','$ServiceName','$Caption','$RunningAs','$Notes')
    "
    #Calls the Run-Query function
    RunQuery -Query $Insert_Query -Environment $Environment
}

function addMSSQLOSInformation($OS_BootDevice,$OS_BuildNumber,$OS_BuildType,$OS_Caption,$OS_CodeSet,$OS_CountryCode,$OS_CurrentTimeZone,$OS_Description,$OS_InstallDate,$OS_LastBootUpTime,$OS_Architecture,$OS_SerialNumber,$OS_ServicePackMajorVersion,$OS_ServicePackMinorVersion,$OS_SystemDrive,$OS_TotalVirtualMemorySize,$bios_SMBIOSBIOSVersion,$bios_Manufacturer,$bios_Name,$bios_SerialNumber,$bios_Version,$bios_ReleaseDate,$bios_Status,$cpu_Caption,$cpu_Manufacturer,$cpu_MaxClockSpeed,$cpu_Name,$cpu_CurrentVoltage,$cpu_NumberOfCores,$cpu_NumberOfEnabledCore,$cpu_NumberOfLogicalProcessors,$cpu_VirtualizationFirmwareEnabled,$Environment){
    $Insert_Query = "
    INSERT INTO OSInformation (OS_BootDevice, OS_BuildNumber, OS_BuildType, OS_Caption, OS_CodeSet, OS_CountryCode, OS_CurrentTimeZone, OS_Description, OS_InstallDate, OS_LastBootUpTime, OS_Architecture, OS_SerialNumber, OS_ServicePackMajorVersion, OS_ServicePackMinorVersion, OS_SystemDrive, OS_TotalVirtualMemorySize, bios_SMBIOSBIOSVersion, bios_Manufacturer, bios_Name, bios_SerialNumber, bios_Version, bios_ReleaseDate, bios_Status, cpu_Caption, cpu_Manufacturer, cpu_MaxClockSpeed, cpu_Name, cpu_CurrentVoltage, cpu_NumberOfCores, cpu_NumberOfEnabledCore, cpu_NumberOfLogicalProcessors, cpu_VirtualizationFirmwareEnabled) VALUES ('$OS_BootDevice','$OS_BuildNumber','$OS_BuildType','$OS_Caption','$OS_CodeSet','$OS_CountryCode','$OS_CurrentTimeZone','$OS_Description','$OS_InstallDate','$OS_LastBootUpTime','$OS_Architecture','$OS_SerialNumber','$OS_ServicePackMajorVersion','$OS_ServicePackMinorVersion','$OS_SystemDrive','$OS_TotalVirtualMemorySize','$bios_SMBIOSBIOSVersion','$bios_Manufacturer','$bios_Name','$bios_SerialNumber','$bios_Version','$bios_ReleaseDate','$bios_Status','$cpu_Caption','$cpu_Manufacturer','$cpu_MaxClockSpeed','$cpu_Name','$cpu_CurrentVoltage','$cpu_NumberOfCores','$cpu_NumberOfEnabledCore','$cpu_NumberOfLogicalProcessors','$cpu_VirtualizationFirmwareEnabled')
    "
    RunQuery -Query $Insert_Query -Environment $Environment
}

