<#	
	===============================================================================================================
	 Created on:   	10/16/2018 
	 Created by:   	Agustin Lacorazza
	 Filename:     	Isilon Quotas Gathering, Parse all the information Module & Insert into SQL DB | Isilon_Get_Quotas.psm1 
	--------------------------------------------------------------------------------------------------
	 Description:  Module to gathering capacity information and parse the same for EMC Isilon devices
	==============================================================================================================

#>



# |  Only Change this two Variables and Plink Info  | 



$Outputfolder = "D:\Dev\Isilon\Capacity\Gathered"
$credentialfolder = "D:\Dev\Isilon\Capacity\Devices"


<# --------------------- Don't change this below -------------------------- #> 
$date = Get-Date
$date = $date.ToString("yyyy-MM-dd")
$rawoutputfolder = "$Outputfolder\$date\raw"
$Isilon_ARRAY01 = "$credentialfolder\ARRAY01.txt"
$Isilon_ARRAY02 = "$credentialfolder\ARRAY02.txt"
$Isilon_ARRAY03 = "$credentialfolder\ARRAY03.txt"
$Isilon_ARRAY04 = "$credentialfolder\ARRAY04.txt"
$Isilon_ARRAY05 = "$credentialfolder\ARRAY05.txt"
$Isilon_ARRAY06 = "$credentialfolder\ARRAY06.txt"
$outfile_quotas_Japan = "$outputfolder\$date\Isilon_Quotas_ARRAY01.txt"
$outfile_quotas_ARRAY02  = "$outputfolder\$date\Isilon_Quotas_ARRAY02.txt"
$outfile_quotas_ARRAY03 = "$outputfolder\$date\Isilon_Quotas_ARRAY03.txt"
$outfile_quotas_ARRAY04 = "$outputfolder\$date\Isilon_Quotas_ARRAY04.txt"
$outfile_quotas_ARRAY05 = "$outputfolder\$date\Isilon_Quotas_ARRAY05.txt"
$outfile_quotas_ARRAY06 = "$outputfolder\$date\Isilon_Quotas_ARRAY06.txt"
$Isilon_quotas_raw_temp = "$rawoutputfolder"
$Isilon_quotas_parsed = "$Outputfolder\$date\parsed"
$Isi_ARRAY01 = (Get-Content $Isilon_ARRAY01 | ConvertFrom-Csv -Delimiter ";" -Header "dev","ipa","usr","pwd","typ" | Where { $_.typ -like "_ISI"})
$Isi_ARRAY02 = (Get-Content $Isilon_ARRAY02 | ConvertFrom-Csv -Delimiter ";" -Header "dev","ipa","usr","pwd","typ" | Where { $_.typ -like "_ISI"})
$Isi_ARRAY03 = (Get-Content $Isilon_ARRAY03 | ConvertFrom-Csv -Delimiter ";" -Header "dev","ipa","usr","pwd","typ" | Where { $_.typ -like "_ISI"})
$Isi_ARRAY04 = (Get-Content $Isilon_ARRAY04 | ConvertFrom-Csv -Delimiter ";" -Header "dev","ipa","usr","pwd","typ" | Where { $_.typ -like "_ISI"})
$Isi_ARRAY05 = (Get-Content $Isilon_ARRAY05 | ConvertFrom-Csv -Delimiter ";" -Header "dev","ipa","usr","pwd","typ" | Where { $_.typ -like "_ISI"})
$Isi_ARRAY06  = (Get-Content $Isilon_ARRAY06  | ConvertFrom-Csv -Delimiter ";" -Header "dev","ipa","usr","pwd","typ" | Where { $_.typ -like "_ISI"})
$merged = "$outputfolder\$date\merged\merged_$((Get-Date).ToString('yyyy-MM-dd')).txt"
$merged2 =  "$outputfolder\$date\merged\merged_$((Get-Date).ToString('yyyy-MM-dd'))_2.txt"
$merged3 = "$outputfolder\$date\merged\merged_$((Get-Date).ToString('yyyy-MM-dd'))_3.txt"
$Isilon_quotas_merged = "$outputfolder\$date\Isilon_Quotas_Parsed_$((Get-Date).ToString('yyyy-MM-dd')).txt"

<# ----------------------------------------------- #>

New-Item -ItemType Directory -Path "$outputfolder\$((Get-Date).ToString('yyyy-MM-dd'))"
New-Item -ItemType Directory -Path "$outputfolder\$((Get-Date).ToString('yyyy-MM-dd'))\raw"
New-Item -ItemType Directory -Path "$outputfolder\$((Get-Date).ToString('yyyy-MM-dd'))\parsed"
New-Item -ItemType Directory -Path "$outputfolder\$((Get-Date).ToString('yyyy-MM-dd'))\merged"


<#  
Functions to gather all the information and parse the same 
#>

<#    JAPAN ISILON DISABLED !! 

function Get_Isilon_Quotas_ARRAY01 {
  foreach ($Isilon in $Isi_ARRAY01) {
  
    $pwd  = $Isilon.pwd -replace {"$","`$"} 
    $devicename_JAP = $Isilon.dev 
    $usr = $Isilon.usr 
    $ipa = $Isilon.ipa 

    $Plink = D:\Software\plink7.exe -batch $ipa -l $usr -pw $pwd "isi quota list -z --format csv" 
    
    $output +=  $Plink 
    
    $outfile_quotas_Japan = "$rawoutputfolder\Isilon_Quotas_ARRAY01.txt"
    Write-Output $output | Out-File $outfile_quotas_Japan  
  }

$Isilon_Japan_Quotas_Raw = Get-Content $outfile_quotas_Japan

$Isilon_Japan_Quotas_Raw |foreach {$_ +  ",$date,$devicename_JAP"}
Write-Output $Isilon_Japan_Quotas_Raw |foreach {$_ +  ",$date,$devicename_JAP"} | Out-File $Isilon_quotas_raw_temp\Isilon_Quotas_ARRAY01_raw.txt


.{
    "Type,AppliesTo,Path,Snap,Hard,Soft,Adv,Used,date,device"
    Get-Content $Isilon_quotas_raw_temp\Isilon_Quotas_ARRAY01_raw.txt  | Select-Object -Skip 1
} |
Set-Content $Isilon_quotas_parsed\Isilon_Quotas_ARRAY01_parsed.txt


	 }
#>


function Get_Isilon_Quotas_ARRAY02 {
  foreach ($Isilon in $Isi_ARRAY02) {
  
    $pwd  = $Isilon.pwd -replace {"$","`$"} 
    $devicename_ARRAY02 = $Isilon.dev 
    $usr = $Isilon.usr 
    $ipa = $Isilon.ipa 

    $Plink  = D:\Software\plink7.exe -batch $ipa -l $usr -pw $pwd "isi quota list -z --format csv" 
    
    $output +=  $Plink 
    
    $outfile_quotas_ARRAY02 = "$rawoutputfolder\Isilon_Quotas_ARRAY02.txt"
    Write-Output $output | Out-File $outfile_quotas_ARRAY02 
  }

$Isilon_ARRAY02_Quotas_Raw = Get-Content $outfile_quotas_ARRAY02 

$Isilon_ARRAY02_Quotas_Raw  |foreach {$_ +  ",$date,$devicename_ARRAY02"}
Write-Output $Isilon_ARRAY02_Quotas_Raw  |foreach {$_ +  ",$date,$devicename_ARRAY02"} | Out-File $Isilon_quotas_raw_temp\Isilon_Quotas_ARRAY02_raw.txt


.{
    "Type,AppliesTo,Path,Snap,Hard,Soft,Adv,Used,date,device"
    Get-Content $Isilon_quotas_raw_temp\Isilon_Quotas_ARRAY02_raw.txt  | Select-Object -Skip 1
} |
Set-Content $Isilon_quotas_parsed\Isilon_Quotas_ARRAY02_parsed.txt


	 }

function Get_Isilon_Quotas_ARRAY03 {
  foreach ($Isilon in $Isi_ARRAY03) {
  
    $pwd  = $Isilon.pwd -replace {"$","`$"} 
    $devicename_ARRAY03 = $Isilon.dev 
    $usr = $Isilon.usr 
    $ipa = $Isilon.ipa 

    $Plink  = D:\Software\plink7.exe -batch $ipa -l $usr -pw $pwd "isi quota list -z --format csv" 
    
    $output +=  $Plink 
    
    $outfile_quotas_ARRAY03 = "$rawoutputfolder\Isilon_Quotas_ARRAY03.txt"
    Write-Output $output | Out-File $outfile_quotas_ARRAY03
  }

$Isilon_ARRAY03_Quotas_Raw = Get-Content $outfile_quotas_ARRAY03 

$Isilon_ARRAY03_Quotas_Raw  |foreach {$_ +  ",$date,$devicename_ARRAY03"}
Write-Output $Isilon_ARRAY03_Quotas_Raw  |foreach {$_ +  ",$date,$devicename_ARRAY03"} | Out-File $Isilon_quotas_raw_temp\Isilon_Quotas_ARRAY03_raw.txt


.{
    "Type,AppliesTo,Path,Snap,Hard,Soft,Adv,Used,date,device"
    Get-Content $Isilon_quotas_raw_temp\Isilon_Quotas_ARRAY03_raw.txt  | Select-Object -Skip 1
} |
Set-Content $Isilon_quotas_parsed\Isilon_Quotas_ARRAY03_parsed.txt


	 }

function Get_Isilon_Quotas_ARRAY04 {
  foreach ($Isilon in $Isi_ARRAY04) {
  
    $pwd  = $Isilon.pwd -replace {"$","`$"} 
    $devicename_ARRAY04 = $Isilon.dev 
    $usr = $Isilon.usr 
    $ipa = $Isilon.ipa 

    $Plink  = D:\Software\plink7.exe -batch $ipa -l $usr -pw $pwd "isi quota list -z --format csv" 
    
    $output +=  $Plink 
    
    $outfile_quotas_ARRAY04 = "$rawoutputfolder\Isilon_Quotas_ARRAY04.txt"
    Write-Output $output | Out-File $outfile_quotas_ARRAY04
  }

$Isilon_ARRAY04_Quotas_Raw = Get-Content $outfile_quotas_ARRAY04

$Isilon_ARRAY04_Quotas_Raw  |foreach {$_ +  ",$date,$devicename_ARRAY04"}
Write-Output $Isilon_ARRAY04_Quotas_Raw  |foreach {$_ +  ",$date,$devicename_ARRAY04"} | Out-File $Isilon_quotas_raw_temp\Isilon_Quotas_ARRAY04_raw.txt


.{
    "Type,AppliesTo,Path,Snap,Hard,Soft,Adv,Used,date,device"
    Get-Content $Isilon_quotas_raw_temp\Isilon_Quotas_ARRAY04_raw.txt  | Select-Object -Skip 1
} |
Set-Content $Isilon_quotas_parsed\Isilon_Quotas_ARRAY04_parsed.txt


	 }

function Get_Isilon_Quotas_ARRAY05 {
  foreach ($Isilon in $Isi_ARRAY05) {
  
    $pwd  = $Isilon.pwd -replace {"$","`$"} 
    $devicename_ARRAY05 = $Isilon.dev 
    $usr = $Isilon.usr 
    $ipa = $Isilon.ipa 

    $Plink  = D:\Software\plink7.exe -batch $ipa -l $usr -pw $pwd "isi quota list -z --format csv" 
    
    $output +=  $Plink 
    
    $outfile_quotas_ARRAY05 = "$rawoutputfolder\Isilon_Quotas_ARRAY05.txt"
    Write-Output $output | Out-File $outfile_quotas_ARRAY05
  }
$Isilon_ARRAY05_Quotas_Raw = Get-Content $outfile_quotas_ARRAY05

$Isilon_ARRAY05_Quotas_Raw  |foreach {$_ +  ",$date,$devicename_ARRAY05"}
Write-Output $Isilon_ARRAY05_Quotas_Raw  |foreach {$_ +  ",$date,$devicename_ARRAY05"} | Out-File $Isilon_quotas_raw_temp\Isilon_Quotas_ARRAY05_raw.txt


.{
    "Type,AppliesTo,Path,Snap,Hard,Soft,Adv,Used,date,device"
    Get-Content $Isilon_quotas_raw_temp\Isilon_Quotas_ARRAY05_raw.txt  | Select-Object -Skip 1
} |
Set-Content $Isilon_quotas_parsed\Isilon_Quotas_ARRAY05_parsed.txt


	 }

function Get_Isilon_Quotas_ARRAY06 {
  foreach ($Isilon in $Isi_ARRAY06) {
  
    $pwd  = $Isilon.pwd -replace {"$","`$"} 
    $devicename_ARRAY06= $Isilon.dev 
    $usr = $Isilon.usr 
    $ipa = $Isilon.ipa 

    $Plink  = D:\Software\plink7.exe -batch $ipa -l $usr -pw $pwd "isi quota list -z --format csv" 
    
    $output +=  $Plink 
    
    $outfile_quotas_ARRAY06 = "$rawoutputfolder\Isilon_Quotas_ARRAY06.txt"
    Write-Output $output | Out-File $outfile_quotas_ARRAY06
  }

$Isilon_ARRAY06_Quotas_Raw = Get-Content $outfile_quotas_ARRAY06

$Isilon_ARRAY06_Quotas_Raw  |foreach {$_ +  ",$date,$devicename_ARRAY06"}
Write-Output $Isilon_ARRAY06_Quotas_Raw  |foreach {$_ +  ",$date,$devicename_ARRAY06"} | Out-File $Isilon_quotas_raw_temp\Isilon_Quotas_ARRAY06_raw.txt


.{
    "Type,AppliesTo,Path,Snap,Hard,Soft,Adv,Used,date,device"
    Get-Content $Isilon_quotas_raw_temp\Isilon_Quotas_ARRAY06_raw.txt  | Select-Object -Skip 1
} |
Set-Content $Isilon_quotas_parsed\Isilon_Quotas_ARRAY06_parsed.txt


	 }

<# 
End data collection 
#>	


<# 
Merge all data into one big file 
#>	
function Merge_all_parsed {

Get-ChildItem $Isilon_quotas_parsed -include *.txt -rec | ForEach-Object {gc $_; ""} | out-file $merged
Set-Content -Path "$merged2" -Value (get-content -Path "$merged" | Select-String -Pattern 'Type,AppliesTo,Path,Snap,Hard,Soft,Adv,Used,date,device' -NotMatch)
(get-content $merged2) | where {$_ -ne ""} | out-file $Isilon_quotas_merged
<#{
    "Type,AppliesTo,Path,Snap,Hard,Soft,Adv,Used,date,device"
    Get-Content $merged3 | Select-Object -Skip 1
} | Set-Content $Isilon_quotas_merged 
#>

}


<#   
Insert Quotas parsed To SQL
#>

function Insert_to_SQL {

 
# Database variables 
$sqlserver = "SQLSERVER\INSTANCE" 
$database = "Isilon" 
$table = "dbo.Quotas_Monthly" 
  
# CSV variables
$date = Get-Date
$date = $date.ToString("yyyy-MM-dd")
$outputfolder ="D:\Dev\Isilon\Capacity\Gathered\$date" 
$csvfile = "$outputfolder\Isilon_Quotas_Parsed_$((Get-Date).ToString('yyyy-MM-dd')).txt"
$csvdelimiter = "," 
$FirstRowColumnNames = $false 
  
################### No need to modify anything below ################### 
Write-Host "Script started..." 
$elapsed = [System.Diagnostics.Stopwatch]::StartNew()  
[void][Reflection.Assembly]::LoadWithPartialName("System.Data") 
[void][Reflection.Assembly]::LoadWithPartialName("System.Data.SqlClient") 
  
# 50k worked fastest and kept memory usage to a minimum 
$batchsize = 50000 
  
# Build the sqlbulkcopy connection, and set the timeout to infinite 
$connectionstring = "Data Source=$sqlserver;Integrated Security=true;Initial Catalog=$database;" 
$bulkcopy = New-Object Data.SqlClient.SqlBulkCopy($connectionstring, [System.Data.SqlClient.SqlBulkCopyOptions]::TableLock) 
$bulkcopy.DestinationTableName = $table 
$bulkcopy.bulkcopyTimeout = 0 
$bulkcopy.batchsize = $batchsize 
  
# Create the datatable, and autogenerate the columns. 
$datatable = New-Object System.Data.DataTable 
  
# Open the text file from disk 
$reader = New-Object System.IO.StreamReader($csvfile) 
$columns = (Get-Content $csvfile -First 1).Split($csvdelimiter) 
if ($FirstRowColumnNames -eq $true) { $null = $reader.readLine() } 
  
foreach ($column in $columns) {  
    $null = $datatable.Columns.Add() 
} 
  
# Read in the data, line by line, not column by column 
while (($line = $reader.ReadLine()) -ne $null)  { 
    
    $null = $datatable.Rows.Add($line.Split($csvdelimiter)) 
 
# Import and empty the datatable before it starts taking up too much RAM, but  
# after it has enough rows to make the import efficient. 
    $i++; if (($i % $batchsize) -eq 0) {  
        $bulkcopy.WriteToServer($datatable)  
        Write-Host "$i rows have been inserted in $($elapsed.Elapsed.ToString())." 
        $datatable.Clear()  
    }  
}  
  
# Add in all the remaining rows since the last clear 
if($datatable.Rows.Count -gt 0) { 
    $bulkcopy.WriteToServer($datatable) 
    $datatable.Clear() 
} 
  
# Clean Up 
$reader.Close(); $reader.Dispose() 
$bulkcopy.Close(); $bulkcopy.Dispose() 
$datatable.Dispose() 
  
Write-Host "Script complete. $i rows have been inserted into the database." 
Write-Host "Total Elapsed Time: $($elapsed.Elapsed.ToString())" 
# Sometimes the Garbage Collector takes too long to clear the huge datatable. 
[System.GC]::Collect()


}


Function  Start_Gathering_Quotas {
	Get_Isilon_Quotas_ARRAY01
	Get_Isilon_Quotas_ARRAY02
	Get_Isilon_Quotas_ARRAY03
	Get_Isilon_Quotas_ARRAY04
	Get_Isilon_Quotas_ARRAY05
	Get_Isilon_Quotas_ARRAY06
	Merge_all_parsed
    Insert_to_SQL
	 }



Start_Gathering_Quotas
	
