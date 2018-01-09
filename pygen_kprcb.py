# Python3 script to generate windbg command script for visualizing _KPRCB information
# Version 1.1
# Author: Kristian Lamb
# This is provided "AS IS" with no warranties or rights.


import os,sys

try:
	ncpu = int(sys.argv[1])
	out_file = sys.argv[2]
except:
	print("--> ERROR: You must provide number of cpu's and outputfile")
	print("--> usage: python <script.py> <ncpu> <dest_file>")
	print("\t   python pygen_kprcb.py 31 c:\debuggers\scripts\kprcb.txt")
	sys.exit(1)
	
a = '''
$$
$$ =============================================================================
$$ _KPCRB info
$$
$$ Version: 1.0
$$
$$ Note: Create a folder called Scripts where WinDBG is installed and save the script there.
$$
$$ Compatibility: Win32/Win64.
$$
$$ Usage: $$><c:\debuggers\scripts\kpcrb.txt
$$
$$ Kristian Lamb
$$
$$ All my scripts are provided "AS IS" with no warranties, and confer no rights. 
$$ =============================================================================
$$
.printf "                                       InterruptRequest\\n"
.printf "                                       |    InterruptRate\\n"
.printf "                                       |    |      QuantumEnd\\n"
.printf "                                       |    |      |         PeriodicCount\\n"
.printf "                                       |    |      |         |      LastTick\\n"
.printf "                                       |    |      |         |      |     DpcRoutineActive      DpcTimeCount\\n"
.printf "        KPRCB     CPU    IsrDpcStats   |    |      |         |      |     |       ActiveDpc     |    DpcTimeLimit\\n"
.printf " ---------------- --- ---------------- |    |      |         |      |     |   ----------------  |    ------------\\n"
$$
$$ Pull out data from KPRCB and print formated row
'''
b = '''
r $t1 = @$prcb
r $t8 = @@(@$prcb->LegacyNumber)
r $t9 = @@(@$prcb->IsrDpcStats)
r $t10 = @@(@$prcb->InterruptRequest)
r $t11 = @@(@$prcb->InterruptRate)
r $t12 = @@(@$prcb->QuantumEnd)
r $t13 = @@(@$prcb->PeriodicCount)
r $t14 = @@(@$prcb->LastTick)
r $t15 = @@(@$prcb->DpcRoutineActive)
r $t2 = @@(@$prcb->DpcData)
r $t16 = @@(((nt!_KDPC_DATA *)@$t2)->ActiveDpc)
r $t17 = @@(@$prcb->DpcTimeCount)
r $t18 = @@(@$prcb->DpcTimeLimit)
.printf " %p %3d %p %1p %08p  %1p         %1p   %07p  %1p   %p  %1p    %p\\n",$t1,$t8,$t9,$t10,$t11,$t12,$t13,$t14,$t15,$t16,$t17,$t18
'''

def create_script(file):
	try:
		with open(file, "w") as f:
			f.write(a)
			for i in range(0,ncpu+1):
				f.write("~{:d}s".format(i))
				f.write(b)
	except IOError:
		print("An IOError has occurred!")
		sys.exit(2)

if not os.path.isfile(out_file):
	create_script(out_file)
	print("--> %s created successfully" % out_file)
	sys.exit(0)
if os.path.isfile(out_file):
	user_answer = input("--> Do you want to overwrite %s [Y/N]\n--> " % out_file)
	if user_answer.upper() == "Y":
		create_script(out_file)
		print("--> %s created successfully" % out_file)
		sys.exit(0)
	else:
		print("--> Operation canceled by user")
		sys.exit(0)
