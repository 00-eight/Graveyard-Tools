# WindbgScripts
* [pygen_kprcb](https://github.com/00-eight/Graveyard-Tools/tree/master/WindbgScripts#pygen_kprcb)
* [io3](https://github.com/00-eight/Graveyard-Tools/tree/master/WindbgScripts#io3)
* [io4](https://github.com/00-eight/Graveyard-Tools/tree/master/WindbgScripts#io4-2016)

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
19: kd> !cpuid
CP  F/M/S  Manufacturer     MHz
 0  6,79,1  GenuineIntel    2197
 1  6,79,1  GenuineIntel    2197
 2  6,79,1  GenuineIntel    2197
...
19  6,79,1  GenuineIntel    2197
```

`python pygen_kprcb.py 19 c:\debuggers\scripts\kprcb.txt`

Inside of windbg you may call the generated scriptfile 
```
2: kd> $$><c:\debuggers\scripts\kprcb.txt
                                       InterruptRequest
                                       |    InterruptRate
                                       |    |      QuantumEnd
                                       |    |      |         PeriodicCount
                                       |    |      |         |      LastTick
                                       |    |      |         |      |     DpcRoutineActive      DpcTimeCount
        KPRCB     CPU    IsrDpcStats   |    |      |         |      |     |       ActiveDpc     |    DpcTimeLimit
 ---------------- --- ---------------- |    |      |         |      |     |   ----------------  |    ------------
 fffff802b35c2180   0 0000000000000001 0 00000001  0         0   092d2c0  0   0000000000000000  0    0000000000000500
 ffffde0073a8d180   1 0000000000000001 1 00000000  1         0   092d2c0  1   ffffbe08bdd1a250  4fb  0000000000000500
 ffffde0073b4f180   2 ffffbe08bc0cebb0 1 00000001  1         0   092d2c0  1   ffffbe08bf1d7aa8  501  0000000000000500 <--
 ffffde0073c9c180   3 0000000000000001 0 00000000  0         0   092d2c0  0   0000000000000000  0    0000000000000500
 ffffde0073cd9180   4 0000000000000001 0 00000001  0         0   092d2c0  0   0000000000000000  0    0000000000000500
 ffffde0073ee1180   5 0000000000000001 0 00000001  0         0   092d2c0  0   0000000000000000  0    0000000000000500
 ffffde007402a180   6 0000000000000001 0 00000000  1         0   092d2c0  0   0000000000000000  0    0000000000000500
 ffffde0073588180   7 0000000000000001 0 00000001  0         0   092d2c0  0   0000000000000000  0    0000000000000500
 ffffde0073da3180   8 0000000000000001 0 00000002  0         0   092d2c0  0   0000000000000000  0    0000000000000500
 ffffde0074000180   9 0000000000000001 0 00000001  0         0   092d2c0  0   0000000000000000  0    0000000000000500
 ffffde0073ac7180  10 0000000000000001 0 00000002  0         0   092d2c0  0   0000000000000000  0    0000000000000500
 ffffde00742c0180  11 0000000000000001 0 00000001  0         0   092d2c0  0   0000000000000000  0    0000000000000500
 ffffde00743c9180  12 0000000000000001 0 00000001  0         0   092d2c0  0   0000000000000000  0    0000000000000500
 ffffde0074466180  13 0000000000000001 0 00000001  0         0   092d2c0  0   0000000000000000  0    0000000000000500
 ffffde0074601180  14 0000000000000001 0 00000000  1         0   092d2c0  0   0000000000000000  0    0000000000000500
 ffffde0074740180  15 0000000000000001 0 00000001  0         0   092d2c0  0   0000000000000000  0    0000000000000500
 ffffde0074106180  16 0000000000000001 0 00000002  0         0   092d2c0  0   0000000000000000  0    0000000000000500
 ffffde0074361180  17 0000000000000001 0 00000001  0         0   092d2c0  0   0000000000000000  0    0000000000000500
 ffffde0074780180  18 0000000000000001 0 00000001  0         0   092d2c0  0   0000000000000000  0    0000000000000500
 ffffde0073a40180  19 0000000000000001 0 00000001  0         0   092d2c0  0   0000000000000000  0    0000000000000500
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
0: kd> !object \Driver\LSI_SAS3i
Object: ffff9c87e56372b0  Type: (ffff9c87e3999dc0) Driver
    ObjectHeader: ffff9c87e5637280 (new version)
    HandleCount: 0  PointerCount: 22
    Directory Object: ffffc3869983d0f0  Name: LSI_SAS3i
```
Pass the drvobj as argument to io4

```
0: kd> vertarget
Windows 10 Kernel Version 14393 MP (32 procs) Free x64
Product: Server, suite: TerminalServer DataCenter SingleUserTS
Built by: 14393.2339.amd64fre.rs1_release_inmarket.180611-1502
Machine Name:
Kernel base = 0xfffff800`9827e000 PsLoadedModuleList = 0xfffff800`98584140
Debug session time: Thu Aug 30 19:15:12.068 2018 (UTC - 5:00)
System Uptime: 38 days 3:18:11.520
0: kd> $$>a<c:\my\code\graveyard-tools\windbgscripts\io4.txt ffff9c87e56372b0

Name                  Devobj                 _RAID_UNIT_EXTENSION  Port  Bus   Tgt  LUN
---------------       ----------------       --------------------  ----  ---   ---  ---
0000006d              ffff9c87e5794060       ffff9c87e57941b0      0       0    26    0
	PendingQueue:               Timeout: ffffffff

0000006c              ffff9c87e578e060       ffff9c87e578e1b0      0       0    25    0
	PendingQueue:               Timeout: ffffffff

0000006b              ffff9c87e5792060       ffff9c87e57921b0      0       0    24    0
	PendingQueue:               Timeout: 14
	   XRB                 IRP                SRB
	   ffffd800ba94c010    ffff9c8d0f5f7e10   ffff9c8d0feb4af0
	   ffffd800bb752010    ffff9c8d1079a860   ffff9c8d1079e6f0
	   ffffd800bb62e010    ffff9c8d1070fc80   ffff9c8d107a26f0
	   ffffd800bb10e010    ffff9c87e65248a0   ffff9c87e650f8c0

0000006a              ffff9c87e5796060       ffff9c87e57961b0      0       0    23    0
	PendingQueue:               Timeout: fffffffc
	   XRB                 IRP                SRB

00000069              ffff9c87e579a060       ffff9c87e579a1b0      0       0    22    0
	PendingQueue:               Timeout: ffffffff

00000068              ffff9c87e579e060       ffff9c87e579e1b0      0       0    21    0
	PendingQueue:               Timeout: 12
	   XRB                 IRP                SRB
	   ffffd800bb03c010    ffff9c8d1074b720   ffff9c8d0fa507f0
	   ffffd800bb516010    ffff9c8d127f58f0   ffff9c8d12e35970
	   ffffd800bbac8010    ffff9c8d0f5f7910   ffff9c8d107446e0
	   ffffd800bbaca010    ffff9c8d12f8a820   ffff9c8d12fe6d40

00000067              ffff9c87e57a2060       ffff9c87e57a21b0      0       0    20    0
	PendingQueue:               Timeout: fffffffd
	   XRB                 IRP                SRB

00000066              ffff9c87e5764060       ffff9c87e57641b0      0       0    19    0
	PendingQueue:               Timeout: ffffffff

00000065              ffff9c87e5768060       ffff9c87e57681b0      0       0    18    0
	PendingQueue:               Timeout: fffffffd
	   XRB                 IRP                SRB

00000064              ffff9c87e576c060       ffff9c87e576c1b0      0       0    17    0
	PendingQueue:               Timeout: 14
	   XRB                 IRP                SRB
	   ffffd800bba6a010    ffff9c8d13a116b0   ffff9c8d12f5e6b0
	   ffffd800bb7e8010    ffff9c8d13ab76b0   ffff9c8d10327950
	   ffffd800bbb9a010    ffff9c8d2873c880   ffff9c87e4f83990
	   ffffd800bb898010    ffff9c8d13a326b0   ffff9c8d12bf2710

00000063              ffff9c87e5770060       ffff9c87e57701b0      0       0    16    0
	PendingQueue:               Timeout: ffffffff

00000062              ffff9c87e5774060       ffff9c87e57741b0      0       0    15    0
	PendingQueue:               Timeout: 14
	   XRB                 IRP                SRB
	   ffffd800bb4e0010    ffff9c8d0f3237b0   ffff9c8d0f4deda0
	   ffffd800bbdd0010    ffff9c8d13cd46b0   ffff9c8d13054850
	   ffffd800bbbfa010    ffff9c8d12e10a10   ffff9c8d13852990
	   ffffd800bbb16010    ffff9c8d140f36b0   ffff9c8d13049a40
	   ffffd800bb39a010    ffff9c8d1413d6b0   ffff9c8d13bbf740
	   ffffd800bb5f4010    ffff9c8d138af6b0   ffff9c8d136cd7b0
	   ffffd800bb9c0010    ffff9c8d1381b6b0   ffff9c8d13801810
	   ffffd800bb96c010    ffff9c8d13c8e6b0   ffff9c8d130576d0
	   ffffd800bb8c4010    ffff9c8d13ab16b0   ffff9c8d12e38f40
	   ffffd800bb47c010    ffff9c8d141266b0   ffff9c8d1307bf40
	   ffffd800bb862010    ffff9c8d146afe10   ffff9c8d13d9e6c0
	   ffffd800bb5ae010    ffffa48178f8d2c0   ffff9c87e6803190
	   ffffd800bb6ee010    ffff9c8d139de6b0   ffff9c8d12e65990
	   ffffd800bb0c2010    ffff9c8d13b546b0   ffff9c8d12a78990
	   ffffd800bbcfe010    ffff9c8d12f606b0   ffff9c8d139786e0
	   ffffd800bb2d6010    ffff9c8d12f5d6b0   ffff9c8d12e826f0
	   ffffd800bb41a010    ffff9c8d13b506b0   ffff9c8d1302e900
	   ffffd800bb56a010    ffffa4817921ee10   ffff9c87e4fca8c0
	   ffffd800bb35a010    ffff9c8d1216d6b0   ffff9c8d138d2700
	   ffffd800bba82010    ffff9c8d0f5f1c60   ffff9c8d12b216d0
	   ffffd800bb960010    ffff9c8d19e9b670   ffff9c8d17fd6840
	   ffffd800b9ee8010    ffff9c8d13c0a6b0   ffff9c8d141e3690
	   ffffd800bb540010    ffff9c8d13aa06b0   ffff9c8d1295d990
	   ffffd800bb34a010    ffffa4817921ae10   ffff9c87e4fca990
	   ffffd800bb5ca010    ffff9c87e64448a0   ffff9c87e648e8c0

00000061              ffff9c87e5778060       ffff9c87e57781b0      0       0    14    0
	PendingQueue:               Timeout: f
	   XRB                 IRP                SRB
	   ffffd800bb682010    ffff9c8d1386c6b0   ffff9c8d0ed57f40
	   ffffd800bb57c010    ffff9c8d0f55be10   ffff9c87e4f9c990
	   ffffd800bb68c010    ffff9c8d12f706b0   ffff9c8d13615700
	   ffffd800bb65e010    ffff9c801df99c60   ffff9c8d1310dcd0
	   ffffd800bb0d3010    ffff9c87e64708a0   ffff9c87e6492820
	   ffffd800bb6fa010    ffff9c8d139346b0   ffff9c8d141fc7d0
	   ffffd800bb48e010    ffff9c8d12fc9680   ffffa4817b00df40
	   ffffd800b8d0d010    ffff9c8d13a386b0   ffff9c8d12db66a0
	   ffffd800bbd04010    ffff9c8d1383a6b0   ffff9c8d0ed46910
	   ffffd800bb5e4010    ffffa481786f4c80   ffff9c87e5b57f40
	   ffffd800bb868010    ffff9c8004988010   ffff9c8d19c27760
	   ffffd800bb828010    ffff9c8d1381d6b0   ffff9c8d1397c720
	   ffffd800bb850010    ffff9c8d0f527e10   ffff9c8d0f8d29e0
	   ffffd800b9174010    ffff9c8d13b636b0   ffff9c8d128bf690
	   ffffd800b953d010    ffff9c8d1389e6b0   ffff9c8d1305bd90
	   ffffd800bbaf8010    ffffa48180baac60   ffff9c8d13c54720
	   ffffd800bb4de010    ffff9c8d146476b0   ffff9c8d12fc2b40
	   ffffd800bbace010    ffff9c8d0f4d8c70   ffff9c8d136df8b0
	   ffffd800b8d26010    ffff9c8d12ff86b0   ffff9c8d127096e0
	   ffffd800bb7f8010    ffff9c8d13a506b0   ffff9c8d1480d6f0
	   ffffd800bb9dc010    ffff9c8d13044a40   ffff9c8d12fe6700
	   ffffd800bbbf6010    ffff9c8d1eaa3860   ffff9c8d14e4e730

00000060              ffff9c87e577c060       ffff9c87e577c1b0      0       0    13    0
	PendingQueue:               Timeout: 14
	   XRB                 IRP                SRB
	   ffffd800bb13f010    ffff9c8d0f22be10   ffff9c8d0f1ff6f0

0000005f              ffff9c87e5780060       ffff9c87e57801b0      0       0    12    0
	PendingQueue:               Timeout: ffffffff

0000005e              ffff9c87e5742060       ffff9c87e57421b0      0       0    11    0
	PendingQueue:               Timeout: ffffffff

0000005d              ffff9c87e5746060       ffff9c87e57461b0      0       0    10    0
	PendingQueue:               Timeout: 14
	   XRB                 IRP                SRB
	   ffffd800bb064010    ffff9c8d0f4f6960   ffff9c8d0f4f6b60
	   ffffd800bbc2c010    ffffa481786f5c80   ffff9c8d0f6916f0
	   ffffd800bb470010    ffff9c8d0f4beae0   ffff9c8d0f4eaf40

0000005c              ffff9c87e574a060       ffff9c87e574a1b0      0       0     9    0
	PendingQueue:               Timeout: ffffffff

0000005b              ffff9c87e574e060       ffff9c87e574e1b0      0       0     8    0
	PendingQueue:               Timeout: 14
	   XRB                 IRP                SRB
	   ffffd800bb668010    ffff9c8d09f99c10   ffff9c8d0d513680


Name                  Devobj                 _RAID_ADAPTER_EXTENSION  PortNumber
---------------       ----------------       --------------------     --------
RaidPort0             ffff9c87e53fa050       ffff9c87e53fa1a0         0
```