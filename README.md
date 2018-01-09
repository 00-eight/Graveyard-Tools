# Graveyard-Tools
This repository will be assorted list of tools intended for use by professionals to resolve specific issues. 
* [reg_lang](https://github.com/00-eight/Graveyard-Tools#reg_langps1)
* [pygen_kprcb](https://github.com/00-eight/Graveyard-Tools#pygen_kprcb)

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

## pygen_kprcb
This is a python script used to generate a [windbg script file](https://docs.microsoft.com/en-us/windows-hardware/drivers/debugger/using-script-files)
 to help visualize information from the _KPRCB for each cpu.   

#### Installation:
This requires python3 with no additional dependencies.

#### Usage:
`python pygen_kprcb.py <ncpu> <out_file>`   
_ncpu_ is the highest number as reported by !cpuid   
*out_file* is path where you want the generated script   
   
The resulting windbg script file is for __2012 r2/8.1__, if you attempt to run against 2012/8 target 
 you will need to modify the resulting <out_file> such that the Pseudo Register for _IsrDpcStats_ & _ActiveDpc_ is initialized to 0.


__Example__ 
```
23: kd> !cpuid
CP  F/M/S  Manufacturer     MHz
 0  6,45,7  GenuineIntel    2200
 1  6,45,7  GenuineIntel    2200
 2  6,45,7  GenuineIntel    2200
...
23  6,45,7  GenuineIntel    2200
```

`python pygen_kprcb.py 23 c:\debuggers\scripts\kprcb.txt`

Inside of windbg you may call the generated scriptfile 
```
0: kd> $$><c:\debuggers\scripts\kprcb.txt
                                       InterruptRequest
                                       |    InterruptRate
                                       |    |      QuantumEnd
                                       |    |      |         PeriodicCount
                                       |    |      |         |      LastTick
                                       |    |      |         |      |     DpcRoutineActive      DpcTimeCount
        KPRCB     CPU    IsrDpcStats   |    |      |         |      |     |       ActiveDpc     |    DpcTimeLimit
 ---------------- --- ---------------- |    |      |         |      |     |   ----------------  |    ------------
 fffff80363704180 000 fffff80363be79b0 0 0000000e  1         0   101719c  0   0000000000000000  0    0000000000000500
 ffffd000ade00180 001 0000000000000001 0 0000000f  0         0   101719c  0   0000000000000000  0    0000000000000500
 ffffd000adf40180 002 0000000000000001 0 00000012  0         0   101719c  0   0000000000000000  0    0000000000000500
 ffffd000ae043180 003 0000000000000001 0 0000000f  0         0   101719c  0   0000000000000000  0    0000000000000500
 ffffd000ae1c0180 004 0000000000000001 0 00000012  0         0   101719c  0   0000000000000000  0    0000000000000500
 ffffd000ae2c3180 005 0000000000000001 0 0000000f  0         0   101719c  0   0000000000000000  0    0000000000000500
 ffffd000ae440180 006 0000000000000001 0 00000012  0         0   101719c  0   0000000000000000  0    0000000000000500
 ffffd000ae543180 007 0000000000000001 0 0000000f  0         0   101719c  0   0000000000000000  0    0000000000000500
 ffffd000ae685180 008 0000000000000001 0 00000013  0         0   101719c  0   0000000000000000  0    0000000000000500
 ffffd000ae800180 009 0000000000000001 0 0000000f  0         0   101719c  0   0000000000000000  0    0000000000000500
 ffffd000ae940180 00a 0000000000000001 0 00000012  0         0   101719c  0   0000000000000000  0    0000000000000500
 ffffd000aea43180 00b 0000000000000001 0 0000000f  0         0   101719c  0   0000000000000000  0    0000000000000500
 ffffd000aebc0180 00c 0000000000000001 0 0000000e  1         0   101719c  0   0000000000000000  0    0000000000000500
 ffffd000aecc3180 00d 0000000000000001 0 0000000f  0         0   101719c  0   0000000000000000  0    0000000000000500
 ffffd000aee40180 00e 0000000000000001 0 0000000f  0         0   101719c  0   0000000000000000  0    0000000000000500
 ffffd000aef43180 00f 0000000000000001 0 00000017  0         0   1016ed4  0   0000000000000000  0    0000000000000500 <--
 ffffd000af0c0180 010 0000000000000001 0 0000000e  1         0   101719c  0   0000000000000000  0    0000000000000500
 ffffd000af1c3180 011 0000000000000001 0 0000000f  0         0   101719c  0   0000000000000000  0    0000000000000500
 ffffd000af2c7180 012 0000000000000001 0 00000012  0         0   101719c  0   0000000000000000  0    0000000000000500
 ffffd000af3ca180 013 0000000000000001 0 0000000f  0         0   101719c  0   0000000000000000  0    0000000000000500
 ffffd000af54d180 014 0000000000000001 0 0000000e  1         0   101719c  0   0000000000000000  0    0000000000000500
 ffffd000af691180 015 0000000000000001 0 0000000f  0         0   101719c  0   0000000000000000  0    0000000000000500
 ffffd000af794180 016 0000000000000001 0 0000000e  1         0   101719c  0   0000000000000000  0    0000000000000500
 ffffd000af8d7180 017 0000000000000001 0 0000000f  0         0   101719c  0   0000000000000000  0    0000000000000500
```