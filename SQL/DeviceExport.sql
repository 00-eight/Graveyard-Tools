USE OMEssentials
GO


SELECT d.DeviceName,
	d.IdNodeOrServiceTag,
	dt.NameForEnum AS DeviceType
FROM dbo.Device d
JOIN dbo.DeviceGroupToDevice dgd
ON d.DeviceId = dgd.IdDevice
JOIN dbo.DeviceType dt
ON d.DeviceType = dt.Id
GROUP BY d.DeviceName, d.IdNodeOrServiceTag, dt.NameForEnum
