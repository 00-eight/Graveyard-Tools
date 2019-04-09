<# +++

 Disclaimer
    :: Provided as is. Use at your own risk. 

 Params
    :: ParentComputer
    ::     If not Master specify FQDN of Master Sysvol
    ::
    :: isMaster
    ::     Bool specifys system will be the master

 Example 
    :: Run From Master Server which will host Master Copy of SYSVOL
    ::     .\sysvol.ps1 -isMaster

 Example 
    :: Run From all other servers
    :: ParentComputer is the FQDN of the Master Server
    ::     .\sysvol.ps1 -ParentComputer dc01.contoso.local


 Author - Kristian Lamb
 
---#>

Param(
    [switch]$isMaster,
    [string]$ParentComputer
)

 $verboseSetting = $VerbosePreference
 $VerbosePreference = "continue"
 Write-Verbose -Message "Sysvols.ps1 :: Started"

 $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
 $principal = New-Object Security.Principal.WindowsPrincipal $identity
 $isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
 Write-Verbose -Message "SET :: isAdmin :: $isAdmin"
 
 if (!$isadmin){
    throw [System.AccessViolationException] "[!] Access Denied: Requires Elevation"
 }

 if (!($isMaster -or $ParentComputer)){
    throw [System.Exception] "[!] Must Specify -isMaster or -ParentComputer"
 } 

 if ($isMaster -and $ParentComputer){
    throw [System.Exception] "[!] You may only specify One parameter"
 }

 $domain = ($env:USERDNSDOMAIN).ToLower()
 Write-Verbose -Message "SET :: Domain :: $domain"

 if (Test-Path -Path "C:\Windows\SYSVOL_DFSR"){
    $sysvolRoot = "C:\Windows\SYSVOL_DFSR"
    Write-Verbose -Message "SET :: sysvolRoot :: $sysvolRoot"
 }

 if (Test-Path -Path "C:\Windows\SYSVOL"){
    $sysvolRoot = "C:\Windows\SYSVOL"
    Write-Verbose -Message "SET :: sysvolRoot :: $sysvolRoot"
 }

 if (!$sysvolRoot){
    throw [System.Exception] "[!] Unable to determine path to SYSVOL"
 }

 $promotingsysvols = New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\services\DFSR\Parameters\SysVols" `
                        -Name "Promoting SysVols" `
                        -Confirm:$false `
                        -Force
 Write-Verbose -Message "REG NEW :: $promotingsysvols"
 $promoRootkey = [regex]::Replace($promotingsysvols.Name, "HKEY_LOCAL_MACHINE", "HKLM:")

 New-ItemProperty -Path $promoRootkey `
    -Name "Sysvol Information is Committed" `
    -PropertyType DWORD `
    -Value 1 `
    -Confirm:$false `
    -Force | Out-Null
 Write-Verbose -Message "REG NEW :: $promotingsysvols.Name\Sysvol Information is Committed :: DWORD :: 1"

 $promotingdomain = New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\services\DFSR\Parameters\SysVols\Promoting SysVols\" `
                        -Name $domain `
                        -Confirm:$false `
                        -Force
 Write-Verbose -Message "REG NEW :: $promotingdomain"
 $promoDomainkey = [regex]::Replace($promotingdomain.Name, "HKEY_LOCAL_MACHINE", "HKLM:")

 if ($isMaster){
     New-ItemProperty -Path $promoDomainkey `
        -Name "Is Primary" `
        -PropertyType DWORD `
        -Value 1 `
        -Confirm:$false `
        -Force | Out-Null
     Write-Verbose -Message "REG NEW :: $promotingdomain\Is Primary :: DWORD :: 1"
 } else {
      New-ItemProperty -Path $promoDomainkey `
        -Name "Is Primary" `
        -PropertyType DWORD `
        -Value 0 `
        -Confirm:$false `
        -Force | Out-Null
     Write-Verbose -Message "REG NEW :: $promotingdomain\Is Primary :: DWORD :: 0"
 }

 New-ItemProperty -Path $promoDomainkey `
    -Name "Command" `
    -Value "DcPromo" `
    -Confirm:$false `
    -Force | Out-Null
 Write-Verbose -Message "REG NEW :: $promotingdomain\Command :: REG_SZ :: DcPromo"
 
 if ($ParentComputer){
     New-ItemProperty -Path $promoDomainkey `
        -Name "Parent Computer" `
        -Value $ParentComputer `
        -Confirm:$false `
        -Force | Out-Null
     Write-Verbose -Message "REG NEW :: $promotingdomain\Parent Computer :: REG_SZ :: $ParentComputer"
 } else {
     New-ItemProperty -Path $promoDomainkey `
        -Name "Parent Computer" `
        -Confirm:$false `
        -Force | Out-Null
     Write-Verbose -Message "REG NEW :: $promotingdomain\Parent Computer :: REG_SZ :: NULL"
   }

 New-ItemProperty -Path $promoDomainkey `
    -Name "Replicated Folder Name" `
    -Value $domain `
    -Confirm:$false `
    -Force | Out-Null
 Write-Verbose -Message "REG NEW :: $promotingdomain\Replicated Folder Name :: REG_SZ :: $domain"

 New-ItemProperty -Path $promoDomainkey `
    -Name "Replicated Folder Root" `
    -Value "$sysvolRoot\Domain" `
    -Confirm:$false `
    -Force | Out-Null
 Write-Verbose -Message "REG NEW :: $promotingdomain\Replicated Folder Root :: REG_SZ :: $sysvolRoot\Domain"

 New-ItemProperty -Path $promoDomainkey `
    -Name "Replicated Folder Root Set" `
    -Value "$sysvolRoot\sysvol\$domain" `
    -Confirm:$false `
    -Force | Out-Null
 Write-Verbose -Message "REG NEW :: $promotingdomain\Replicated Folder Root Set :: REG_SZ :: $sysvolRoot\sysvol\$domain"

 New-ItemProperty -Path $promoDomainkey `
    -Name "Replicated Folder Stage" `
    -Value "$sysvolRoot\staging areas\$domain" `
    -Confirm:$false `
    -Force | Out-Null
 Write-Verbose -Message "REG NEW :: $promotingdomain\Replicated Folder Stage :: REG_SZ :: $sysvolRoot\staging areas\$domain"

 New-ItemProperty -Path $promoDomainkey `
    -Name "Replication Group Name" `
    -Value $domain `
    -Confirm:$false `
    -Force | Out-Null
 Write-Verbose -Message "REG NEW :: $promotingdomain\Replication Group Name :: REG_SZ :: $domain"

 New-ItemProperty -Path $promoDomainkey `
    -Name "Replication Group Type" `
    -Value "Domain" `
    -Confirm:$false `
    -Force | Out-Null
 Write-Verbose -Message "REG NEW :: $promotingdomain\Replication Group Type :: REG_SZ :: Domain"

 if (!(Test-Path -Path "$sysvolRoot\staging")){
    New-Item -path "$sysvolRoot\staging" `
        -ItemType Directory `
        -Confirm:$false `
        -Force | Out-Null
    Write-Verbose -Message "Mkdir :: $sysvolRoot\staging"
 }

 if (!(Test-Path -Path "$sysvolRoot\staging areas")){
    New-Item -path "$sysvolRoot\staging areas" `
        -ItemType Directory `
        -Confirm:$false `
        -Force | Out-Null
    Write-Verbose -Message "Mkdir :: $sysvolRoot\staging areas"
 }

 Write-Verbose -Message "sysvols.ps1 :: Completed"
 $VerbosePreference = $verboseSetting