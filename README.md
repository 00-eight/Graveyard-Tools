# Graveyard-Tools
This repository will be assorted list of tools intended for use by IT Pro's to resolve specific issues. 

## reg_lang.ps1 
This is a script to purge references to language packs that are not installed that got incorrectly placed into the servicing components.  
  
When this happens you can see updates and or feature/role installation fail with *0x80073701 ERROR_SXS_ASSEMBLY_MISSING*

  
Inspecting the CBS.log as in the example below you can see references to __de-DE__ or German which should not be in here as we never install a language pack. 
```
	Line 3079: 2017-10-03 16:57:05, Info                  CBS    Failed to pin deployment while resolving Update: Microsoft-Windows-CoreSystem-ServerManager-Core-Package~31bf3856ad364e35~amd64~de-DE~10.0.14393.0.ServerManager-Core-MgmtProvider-Deployment-LangPack from file: (null) [HRESULT = 0x80073701 - ERROR_SXS_ASSEMBLY_MISSING]
	Line 6224: 2017-10-03 17:11:09, Info                  CBS    Failed to pin deployment while resolving Update: Microsoft-Windows-CoreSystem-ServerManager-Core-Package~31bf3856ad364e35~amd64~de-DE~10.0.14393.0.ServerManager-Core-MgmtProvider-Deployment-LangPack from file: (null) [HRESULT = 0x80073701 - ERROR_SXS_ASSEMBLY_MISSING]
```

#### Usage:

You must edit the script in two places they are marked with a _#_ comment. This is looking for a language [locale code](https://msdn.microsoft.com/en-us/library/cc233982.aspx)
The script works by purging references that contain the modified local code from the following location.  
  
```HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\PackageDetect```
  
1. You should export this key first. 
2. You then need to take ownership of this key and select Replace all child object permission entries with inheritable permission entries from this object.
3. Edit the reg_lang.ps1 in two places located with __# Replace en-US with locale 
4. Copy paste into an elevated PowerShell window. __note__ *if you have more than one locale to remove I recommend closing and reopening a new powershell window each time.*
5. Set permisions back on the registry key. 

## kpcrb.txt
This is a [windbg script file](https://docs.microsoft.com/en-us/windows-hardware/drivers/debugger/using-script-files)
 to help visualize information from the _KPCRB.  
This is a work in progress last thing todo is get the iteration loop working to change processors for data population. 
#### Installation:
Create a new folder where windbg is installed I used _scripts_ c:\debuggers\scripts and place kpcrb.txt in that location.   
#### Usage:
`$$>a<c:\debuggers\scripts\kpcrb.txt <num proc>`

