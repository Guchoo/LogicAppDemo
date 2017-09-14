#Requires -Version 3.0
#Requires -Module AzureRM.Resources
#Requires -Module Azure.Storage


#Setting default values
Param(
    [string] $ResourceGroupName = 'LogicAppDemo',
    [string] $TemplateParametersFile = 'LogicApp.parameters.test.json',
	[string] $Container = 'democontainer'
)	

function GetEnvironmentFromTemplateParameters($templateParameters)
{
	$json = Get-Content -Raw -Path $templateParameters | Out-String 
	$data = ConvertFrom-Json -InputObject $json

	return $data.parameters.paramEnvironment.value
}

#Get Storage
$Environment = GetEnvironmentFromTemplateParameters($TemplateParametersFile)
$StorageAccountName = ('LADemo' + $Environment) #add storage account name

Write-Output '', 'Setting current storage account:'
Set-AzureRmCurrentStorageAccount -StorageAccountName $StorageAccountName -ResourceGroupName $ResourceGroupName

Write-Output '', 'Creating storage container'

$container = $null
try { 
	$container = Get-AzureStorageContainer -Name $Container 
} 
catch {}
if (!$container) {
	New-AzureStorageContainer -Name $Container -Permission Off
}

Write-Output '', 'Custom scripts execution completed.'