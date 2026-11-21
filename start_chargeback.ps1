
$date = Get-Date
$date = $date.ToString("yyyy-MM-dd")
$credentialfolder = "D:\Dev\Isilon\Chargeback"
$Isilon_ARRAY02 = "$credentialfolder\ARRAY02.txt"
$Isilon_ARRAY03 = "$credentialfolder\ARRAY03.txt"
$Isilon_ARRAY05 = "$credentialfolder\ARRAY05.txt"
$Isilon_ARRAY06 = "$credentialfolder\ARRAY06.txt"
$Isi_ARRAY02 = (Get-Content $Isilon_ARRAY02 | ConvertFrom-Csv -Delimiter ";" -Header "dev","ipa","usr","pwd","typ" | Where { $_.typ -like "_ISI"})
$Isi_ARRAY03 = (Get-Content $Isilon_ARRAY03 | ConvertFrom-Csv -Delimiter ";" -Header "dev","ipa","usr","pwd","typ" | Where { $_.typ -like "_ISI"})
$Isi_ARRAY05 = (Get-Content $Isilon_ARRAY05 | ConvertFrom-Csv -Delimiter ";" -Header "dev","ipa","usr","pwd","typ" | Where { $_.typ -like "_ISI"})
$Isi_ARRAY06  = (Get-Content $Isilon_ARRAY06  | ConvertFrom-Csv -Delimiter ";" -Header "dev","ipa","usr","pwd","typ" | Where { $_.typ -like "_ISI"})

$logfolder = "D:\Dev\Isilon\Chargeback\log"


function Start_chargeback_ARRAY02 {
  foreach ($Isilon in $Isi_ARRAY02) {
  
    $pwd  = $Isilon.pwd -replace {"$","`$"} 
    $devicename_ARRAY02 = $Isilon.dev 
    $usr = $Isilon.usr 
    $ipa = $Isilon.ipa 

    $Plink  = D:\Software\plink7.exe -batch $ipa -l $usr -pw $pwd "./vpk_run_dc.sh" 
    
    $output +=  $Plink 
    
    $outfile_quotas_ARRAY02 = "$logfolder\log_chargeback_ARRAY02_$date.txt"
    Write-Output $output | Out-File $outfile_quotas_ARRAY02 
  }

}

function Start_chargeback_ARRAY03 {
  foreach ($Isilon in $Isi_ARRAY03) {
  
    $pwd  = $Isilon.pwd -replace {"$","`$"} 
    $devicename_ARRAY03 = $Isilon.dev 
    $usr = $Isilon.usr 
    $ipa = $Isilon.ipa 

    $Plink  = D:\Software\plink7.exe -batch $ipa -l $usr -pw $pwd "./vpk_run_dc.sh" 
    
    $output +=  $Plink 
    
    $outfile_quotas_ARRAY03 = "$logfolder\log_chargeback_ARRAY03_$date.txt"
    Write-Output $output | Out-File $outfile_quotas_ARRAY03
  }

}


function Start_chargeback_ARRAY05 {
  foreach ($Isilon in $Isi_ARRAY05) {
  
    $pwd  = $Isilon.pwd -replace {"$","`$"} 
    $devicename_ARRAY05 = $Isilon.dev 
    $usr = $Isilon.usr 
    $ipa = $Isilon.ipa 

    $Plink  = D:\Software\plink7.exe -batch $ipa -l $usr -pw $pwd "./vpk_run_dc.sh" 
    
    $output +=  $Plink 
    
    $outfile_quotas_ARRAY05 = "$logfolder\log_chargeback_ARRAY05_$date.txt"
    Write-Output $output | Out-File $outfile_quotas_ARRAY05
  }

}


function Start_chargeback_ARRAY06 {
  foreach ($Isilon in $Isi_ARRAY06) {
  
    $pwd  = $Isilon.pwd -replace {"$","`$"} 
    $devicename_ARRAY06 = $Isilon.dev 
    $usr = $Isilon.usr 
    $ipa = $Isilon.ipa 

    $Plink  = D:\Software\plink7.exe -batch $ipa -l $usr -pw $pwd "./vpk_run_dc.sh" 
    
    $output +=  $Plink 
    
    $outfile_quotas_ARRAY06 = "$logfolder\log_chargeback_ARRAY06_$date.txt"
    Write-Output $output | Out-File $outfile_quotas_ARRAY06 
  }

}


Start_chargeback_ARRAY02
Start_chargeback_ARRAY03
Start_chargeback_ARRAY05
Start_chargeback_ARRAY06