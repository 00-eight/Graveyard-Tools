# WindbgScripts
* [pygen_kprcb](https://github.com/00-eight/Graveyard-Tools/tree/master/WindbgScripts#pygen_kprcb)
* [io3](https://github.com/00-eight/Graveyard-Tools/tree/master/WindbgScripts#io3)

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

## Io3 (2012 R2)

```
6: kd> !object \driver\megasas
Object: ffffe000ec7deb90  Type: (ffffe000ec772c60) Driver
    ObjectHeader: ffffe000ec7deb60 (new version)
    HandleCount: 0  PointerCount: 10
    Directory Object: ffffc000948cdb40  Name: megasas
```
Pass the drvobj as argument to io3
```
6: kd> $$>a<c:\debuggers\scripts\io3.txt ffffe000ec7deb90

Name                  Devobj                 _RAID_UNIT_EXTENSION  Port  Bus   Tgt  LUN
---------------       ----------------       --------------------  ----  ---   ---  ---
[Name]                ffffe000ed67b060       ffffe000ed67b1b0      2       1    64    0
	PendingQueue:               Timeout: ffffffff

[Name]                ffffe000ed67d060       ffffe000ed67d1b0      2       1     5    0
	PendingQueue:               Timeout: ffffffff

[Name]                ffffe000ed605060       ffffe000ed6051b0      2       1     4    0
	PendingQueue:               Timeout: ffffffff

[Name]                ffffe000ed607060       ffffe000ed6071b0      2       1     3    0
	PendingQueue:               Timeout: ffffffff

[Name]                ffffe000ed609060       ffffe000ed6091b0      2       1     2    0
	PendingQueue:               Timeout: ffffffff

[Name]                ffffe000ed64d060       ffffe000ed64d1b0      2       1     1    0
	PendingQueue:               Timeout: ffffffff

[Name]                ffffe000ed612060       ffffe000ed6121b0      2       1     0    0
	PendingQueue:               Timeout: 1e
	   XRB                 IRP                SRB
	   ffffd000a0fca010    ffffec01d5a56010   ffffec01d55e8b70
	   ffffd000a0ff1010    ffffec01d5b7f390   ffffec01d5a2adb0
	   ffffd000a20ec010    ffffe6002fc72a10   ffffea015a2de980
	   ffffd000a2204010    ffffe401b4a57cf0   ffffe401b45ef880
	   ffffd0009ef41010    ffffec01d5b2c410   ffffe6002fe2c100
	   ffffd000a21a6010    ffffec01d5b79b60   ffffec01d5acd340
	   ffffd000a21af010    ffffec01d5b9d480   ffffec01d5b9d7a0


Name                  Devobj                 _RAID_ADAPTER_EXTENSION  PortNumber
---------------       ----------------       --------------------     --------
[Name]                ffffe000ed64f050       ffffe000ed64f1a0         2
```

## Io4 (2016)

```
6: kd> !object \driver\megasas
Object: ffffe000ec7deb90  Type: (ffffe000ec772c60) Driver
    ObjectHeader: ffffe000ec7deb60 (new version)
    HandleCount: 0  PointerCount: 10
    Directory Object: ffffc000948cdb40  Name: megasas
```
Pass the drvobj as argument to io3

```
2: kd> $$>a<c:\debuggers\scripts\io4.txt ffffbe08bd1b3b80

Name                  Devobj                 _RAID_UNIT_EXTENSION  Port  Bus   Tgt  LUN
---------------       ----------------       --------------------  ----  ---   ---  ---
00000042              ffffbe08bd195060       ffffbe08bd1951b0      2       1    64    0
	PendingQueue:               Timeout: ffffffff

00000041              ffffbe08bd198060       ffffbe08bd1981b0      2       1     0    0
	PendingQueue:               Timeout: ffffffff


Name                  Devobj                 _RAID_ADAPTER_EXTENSION  PortNumber
---------------       ----------------       --------------------     --------
RaidPort2             ffffbe08bd1df050       ffffbe08bd1df1a0         2
```