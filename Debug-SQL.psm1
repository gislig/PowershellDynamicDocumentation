#----------------------------------------------------------------------#
#
# Powershell Script Name : Debug-sql.ps1
# Created : 27.10.2016
# Created by : Gisli Gudmundsson
# LinkedIN : https://is.linkedin.com/in/gisli-gudmundsson-11a77639
# License Usage : 
#   This code can be used for private use only
#   You may modify this code and distribute
#
#----------------------------------------------------------------------#

Import-Module C:\DynamicDocumentation\Dependencies\DEPMSSQLActions.psm1 -Force -Verbose
$Environment = "production"

Write-Host "`n`n"
Write-Host "Running SQL Debug Script" -ForegroundColor Yellow
Write-Host "................................"
Write-Host "1. Trying to add row to ADUsersCount table" -ForegroundColor Cyan
AddMSSQLUserCount -UserCount 50 -UserType "ServiceUsers" -CostCenter "DEBUG" -Environment $Environment
Write-Host "2. Showing debug values in ADUsersCount table" -ForegroundColor Cyan
$TableInfo = DebugShowMSSQLTable -TableName "ADUsersCount" -ColumnName "UserCostCenter" -Environment $Environment
if($TableInfo -eq $null){
    Write-Host "Error : Failure to retrieve table data" -ForegroundColor Red
}else{
    $TableInfo
}
Write-Host "3. Cleaning up debug in ADUsersCount table" -ForegroundColor Cyan
DebugCleanUpMSSQLUserCount -TableName "ADUsersCount" -ColumnName "UserCostCenter" -Environment $Environment