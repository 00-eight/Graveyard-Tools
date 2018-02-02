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