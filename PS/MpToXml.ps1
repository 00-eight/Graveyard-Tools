param($mpFilePath,$outputDirectory)

$assembly = [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.EnterpriseManagement.OperationsManager")

$mp = new-object Microsoft.EnterpriseManagement.Configuration.ManagementPack($mpFilePath)

$mpWriter = new-object Microsoft.EnterpriseManagement.Configuration.IO.ManagementPackXmlWriter($outputDirectory)

$mpWriter.WriteManagementPack($mp)