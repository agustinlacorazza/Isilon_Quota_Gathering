

<#
General Static Variables
#>

$date = Get-Date
$date = $date.ToString("yyyy-MM-dd")
$Tools_folder = "D:\Dev\VNX\Chargeback\Tools"
$Nas_credentials = "$Tools_folder\nasdevs.txt" 
$Plink = "$Tools_folder\tools\plink.exe"
$Bashscriptsfile = "D:\Dev\VNX\Chargeback\bashscript"
$outputlog = "D:\Dev\VNX\Chargeback\Output"


function Invoke-Plink {
    param (
        [string] $ipa,
        [string] $cmd,
        [string] $usr,
        [string] $pwd,
        [string] $m
    )

    if ($cmd) {
        echo y |  D:\Dev\VNX\Audit\tools\plink.exe $usr@$ipa -pw $pwd $cmd
    } else {
        echo y |  D:\Dev\VNX\Audit\tools\plink.exe $usr@$ipa -pw $pwd -m $m
    }
	}



function Start_Gathering_Chargeback {

	Param (
        [string]$CredentialsFile
    )
	$Systems = Import-Csv $CredentialsFile

	foreach ($vnx in $Systems) {

        Write-Host "Getting info from" $vnx.System
	    $passwd = $vnx.password -replace {"$","`$"}
        $ssh1  = Invoke-Plink -ipa $vnx.IP -usr $vnx.user -pw $passwd -m $Bashscriptsfile\startdu.sh
        Write-Host " Dumping log"
        $Output1 += $ssh1
        $temp = $outputlog + "\log_$date.txt"
        Write-Output $Output1 | Out-File $temp
        }


        }

        function Start_Chargeback {
Clear-Host
$OutPut = Start_Gathering_Chargeback -CredentialsFile $Nas_credentials
Write-Host $OutPut

}


Start_Chargeback