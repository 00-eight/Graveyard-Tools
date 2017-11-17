$rootkey = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\PackageDetect\"
$subkeys = (Get-ChildItem -path $rootkey).Name
[System.Collections.ArrayList]$fsubkeys = @()

foreach ($key in $subkeys) {
	$fsubkeys.Add([regex]::Replace($key, "HKEY_LOCAL_MACHINE", "HKLM:")) | out-null
	}

foreach ($key in $fsubkeys) {

	$i++
    Write-Progress -Activity "Processing Subkeys" -Status "Percent Complete" -PercentComplete (($i / ($fsubkeys.count) * 100))
	
	$knode = Get-Item -path $key
	if ([regex]::IsMatch($knode.Property, "en-US") -eq $True) {                                        # edit en-US 
		foreach ($Property in $knode.Property) {
			$badprop = [regex]::Match($Property, ".+?en-US.+")                                         # edit en-US
			if ($badprop.value) {
				$frootkey = [regex]::Replace($knode.name, "HKEY_LOCAL_MACHINE", "HKLM:")
				Remove-ItemProperty -path $frootkey -name $badprop.value
				}
				
			}

		}
		
	}