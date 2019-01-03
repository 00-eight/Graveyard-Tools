USE OMEssentials
GO

/*
tables
 [OMEssentials].[dbo].[DiscoveryConfiguration] AS dc
 [OMEssentials].[dbo].[DiscoveryConfigurationGroup] AS dcg
 [OMEssentials].[dbo].[DiscoveryConfigurationGroupToDiscoveryConfiguration] AS dcgtodc

cols:
 dc.Address
 dc.SubnetMask
 dcg.GroupName

*/

SELECT dc.Address, dc.SubnetMask, dcg.GroupName
FROM dbo.DiscoveryConfigurationGroupToDiscoveryCOnfiguration AS dcgtodc
JOIN dbo.DiscoveryConfigurationGroup AS dcg
ON dcgtodc.IdDiscoveryConfigurationGroup = dcg.Id
JOIN dbo.DiscoveryConfiguration AS dc
ON dc.Id = dcgtodc.IdDiscoveryConfiguration
ORDER BY GroupName;