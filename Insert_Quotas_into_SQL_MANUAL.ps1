$date = Get-Date
$date = $date.ToString("yyyy-MM-dd")
$outputfolder ="D:\Dev\Isilon\Capacity\Gathered"

function Get-Type 
{ 
    param($type) 
 
$types = @( 
'System.Boolean', 
'System.Byte[]', 
'System.Byte', 
'System.Char', 
'System.Datetime', 
'System.Decimal', 
'System.Double', 
'System.Guid', 
'System.Int16', 
'System.Int32', 
'System.Int64', 
'System.Single', 
'System.UInt16', 
'System.UInt32', 
'System.UInt64') 
 
    if ( $types -contains $type ) { 
        Write-Output "$type" 
    } 
    else { 
        Write-Output 'System.String' 
         
    } 
}


function Out-DataTable 
{ 
    [CmdletBinding()] 
    param([Parameter(Position=0, Mandatory=$true, ValueFromPipeline = $true)] [PSObject[]]$InputObject) 
 
    Begin 
    { 
        $dt = new-object Data.datatable   
        $First = $true  
    } 
    Process 
    { 
        foreach ($object in $InputObject) 
        { 
            $DR = $DT.NewRow()   
            foreach($property in $object.PsObject.get_properties()) 
            {   
                if ($first) 
                {   
                    $Col =  new-object Data.DataColumn   
                    $Col.ColumnName = $property.Name.ToString()   
                    if ($property.value) 
                    { 
                        if ($property.value -isnot [System.DBNull]) { 
                            $Col.DataType = [System.Type]::GetType("$(Get-Type $property.TypeNameOfValue)") 
                         } 
                    } 
                    $DT.Columns.Add($Col) 
                }   
                if ($property.Gettype().IsArray) { 
                    $DR.Item($property.Name) =$property.value | ConvertTo-XML -AS String -NoTypeInformation -Depth 1 
                }   
               else { 
                    $DR.Item($property.Name) = $property.value 
                } 
            }   
            $DT.Rows.Add($DR)   
            $First = $false 
        } 
    }  
      
    End 
    { 
        Write-Output @(,($dt)) 
    } 
 
} #Out-DataTable


<#
Date Info
#>

$date = Get-Date
$date = $date.ToString("yyyy-MM-dd")
$outputfolder ="D:\Dev\Isilon\Capacity\Gathered"

#

$file="D:\Dev\Isilon\Capacity\Gathered\2018-10-07\Isilon_quotas_parsed.txt"
$dbserver="SQLSERVER\INSTANCE"
$database="Isilon"
$cn = new-object System.Data.SqlClient.SqlConnection("Data Source=$dbserver;Integrated Security=SSPI;Initial Catalog=$database");
$cn.Open()
$bc = new-object ("System.Data.SqlClient.SqlBulkCopy") $cn
$bc.BatchSize = 10000;
$bc.BulkCopyTimeout = 1000
$bc.DestinationTableName = "dbo.Quotas_report_Monthly"

$data = Import-Csv $file | Out-DataTable

$bc.WriteToServer($data)
