function Get-OMIMSSCLogs {
<#
.SYNOPSIS
Get-OMIMSSCLogs bundle OMIMSSC Logs for support.

.DESCRIPTION
Collect logs from Appliance which are located at https://applianceip/Spectre/Logs/* and not otherwize easily bundled for support. 

.LINK
https://downloads.dell.com/FOLDER05403229M/1/OMIMSSC_7.1.0.1885_SCOM_A00.zip

.NOTES
Certificate Policy is Required and is not persistent 

.EXAMPLE
stuff
#>

    [cmdletbinding()]
    Param(
        [Parameter(Mandatory=$True,
                   HelpMessage="ApplianceIp or Hostname")]
        [ValidateNotNullOrEmpty()]
        [string]$ApplianceIp           
    )
        
    BEGIN {

    add-type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
            return true;
        }
    }
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy

    }

    PROCESS {
        $base = "https://$ApplianceIp"
        $result = Invoke-WebRequest -Uri "$base/Spectre/logs"

        foreach ($hr in $result.Links.href) {
            #write-host "$hr"
            #if ($hr -like "*.log" -or $hr -like "*.txt"){
            Write-Debug -Message "[Before] $hr"
            if ($hr -notlike "*/") {
                $resp = Invoke-WebRequest -Uri ("$base"+"$hr")
                Write-Debug -Message "[After] $hr"
                $logname = $resp.BaseResponse.ResponseUri.LocalPath.Split('/')[-1]
                $resp.RawContent > $logname
            }
        }
    }

    END {}


}