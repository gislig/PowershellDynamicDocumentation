#----------------------------------------------------------------------#
#
# Module Name : DEPMSSQLActions.psm1
# Created : 27.10.2016
# Created by : Gisli Gudmundsson
# LinkedIN : https://is.linkedin.com/in/gisli-gudmundsson-11a77639
# License Usage : 
#   This code can be used for private use only
#   You may modify this code and distribute
#
#----------------------------------------------------------------------#


#Import the SQL Server Powershell Module
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

#Usage "AddMSSQLUserCount -UserCount $Integer -UserType $StringMax50Chars -CostCenter $StringMax50Chars
function AddMSSQLUserCount($UserCount, $UserType, $CostCenter, $Environment){
    #Adds new row into the database
    $Insert_Query = "
    INSERT INTO ADUsersCount (UserCount, UserType, UserCostCenter) VALUES ('$UserCount','$UserType','$CostCenter')
    "
    #Calls the Run-Query function
    RunQuery -Query $Insert_Query -Environment $Environment
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