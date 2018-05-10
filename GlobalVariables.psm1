#----------------------------------------------------------------------#
#
# Module Name : GlobalVariables.psm1
# Created : 27.10.2016
# Created by : Gisli Gudmundsson
# LinkedIn : https://is.linkedin.com/in/gisli-gudmundsson-11a77639
# License Usage : 
#   This code can be used for private use only
#   You may modify this code and distribute
#
#----------------------------------------------------------------------#

$ServerInstance = "TSTSQL01"

$ProdDatabaseName = "DynamicDocumentationDB"
$DevelopmentDatabaseName = "DevDynamicDocumentationDB"
$TestDatabaseName = "DevDynamicDocumentationDB"

#Returns the value of ServerInstance
function ServerInstance(){ return $ServerInstance }

#Return the value of database environment, can be production, development and test
function DatabaseEnvironment($Environment){
    $Environment = $Environment.ToLower()
    if($Environment -eq "production"){ return $ProdDatabaseName }
    if($Environment -eq "development"){ return $DevelopmentDatabaseName }
    if($Environment -eq "test"){ return $TestDatabaseName }
}