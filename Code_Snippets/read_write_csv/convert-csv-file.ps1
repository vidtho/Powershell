<# Command to execute
------------------
& ".\convert-csv-file.ps1" 

Author : Vidya Thotangare
Version : 1.0
Purpose: This script will transform the csv file with filters and convert it to pipe seperated file

#>

# Edit these locations/parameters
$itn = "48"
$pvt = "03312018"
$run = "1"

$dloc = "H:\vid_workarea\slr_se_ov_nusa\out_files"
$sloc = "H:\vid_workarea\slr_se_ov_nusa\source"

$se_path = "$sloc\Gdb20180331.csv"
$ov_path = "$sloc\Ovation03-31-2018.csv"
$nu_dtsrc = "$sloc\axs_slr_nusa_template.txt"
$nu_clsrc = "$sloc\axs_slr_nusa_template.ctl"

#====================================================================================
$se_dtfile = "axs_se2_external_feed_" + $itn + "_" + $pvt + "_" + $run + ".txt"
$se_ctlfile = "axs_se2_external_feed_" + $itn + "_" + $pvt + "_" + $run + ".ctl"
$ov_dtfile = "axs_ovation_policy_info_" + $itn + "_" + $pvt + "_" + $run + ".txt"
$ov_ctlfile = "axs_ovation_policy_info_" + $itn + "_" + $pvt + "_" + $run + ".ctl"
$nu_dtfile = "axs_slr_nusa_" + $itn + "_" + $pvt + "_" + $run + ".txt"
$nu_ctlfile = "axs_slr_nusa_" + $itn + "_" + $pvt + "_" + $run + ".ctl"

$se_dpath = "$dloc\$se_dtfile"
$se_cpath = "$dloc\$se_ctlfile"
$ov_dpath = "$dloc\$ov_dtfile"
$ov_cpath = "$dloc\$ov_ctlfile"
$nu_dpath = "$dloc\$nu_dtfile"
$nu_cpath = "$dloc\$nu_ctlfile"

if (Test-Path $se_dpath) { Remove-Item $se_dpath -Force -Recurse }
if (Test-Path $se_cpath) { Remove-Item $se_cpath -Force -Recurse }
if (Test-Path $ov_dpath) { Remove-Item $ov_dpath -Force -Recurse }
if (Test-Path $ov_cpath) { Remove-Item $ov_cpath -Force -Recurse }
if (Test-Path $nu_dpath) { Remove-Item $nu_dpath -Force -Recurse }
if (Test-Path $nu_cpath) { Remove-Item $nu_cpath -Force -Recurse }

echo "SE File creation : $(get-date -f 'yyyy-MM-dd HH:mm:ss')..................."
# SE File Creation
#===================
Import-Csv $se_path | Select -SkipLast 1 | convertto-csv -NoTypeInformation -Delimiter "|" | % { $_ -replace '"', ""} | % { $_ -replace ' 0', "0"} | % { $_ -replace '\|\.00', "|0.00"} | out-file $se_dpath -fo -en ascii 


$CSVData = Import-Csv $se_dpath -Delimiter "|"
$TotalCV += ($CSVData.CURRENT_VALUE | Measure-Object -Sum).sum
$TotalCW += ($CSVData.CUMULATIVE_WITHDRAWALS | Measure-Object -Sum).sum
$TotalCol = ($CSVData | get-member -type NoteProperty).count
$TotalRows = @($CSVData).count

echo "Total cval = $TotalCV"
echo "Total cwth = $TotalCW "
echo "Total cols = $TotalCol "
echo "Total rows = $TotalRows"

Add-content -path $se_cpath -value "Table_Name|Col_Name|Col_Value|Col_Type|Data_Type"
Add-content -path $se_cpath -value "axs_se2_external_feed|CURRENT_VALUE|$TotalCV|S|SLR_SUPP"
Add-content -path $se_cpath -value "axs_se2_external_feed|CUMULATIVE_WITHDRAWALS|$TotalCW|S|SLR_SUPP"
Add-content -path $se_cpath -value "axs_se2_external_feed|All_Rows|$TotalRows|C|SLR_SUPP"
Add-content -path $se_cpath -value "axs_se2_external_feed|All_Cols|$TotalCol|C|SLR_SUPP"

echo "Ovation File creation: $(get-date -f 'yyyy-MM-dd HH:mm:ss').................."
# Ovation File Creation
#========================
$header = 'POLICY','GROUP INDICATOR','ISSUE STATE','RESIDENCE STATE','PLAN','QUAL'

Get-Content $ov_path -Encoding Default | Select-Object -Skip 1 | convertFrom-csv -UseCulture -Header $header | convertto-csv -NoTypeInformation -Delimiter "|" | % { $_ -replace '"', ""} | out-file $ov_dpath -fo -en ascii

$CSVData = Import-Csv $ov_path 
#$CSVData[0].psobject.Properties | foreach { $_.Name }
$DistSC = $CSVData.'ORIG ISSUE STATE' | Select-Object -Unique | Measure-Object | select -expand Count
$DistGC = $CSVData.'G/I' | Select-Object -Unique | Measure-Object | select -expand Count
$TotalCol = ($CSVData | get-member -type NoteProperty).count
$TotalRows = @($CSVData).count

echo "DistCount Issue state = $DistSC"
echo "DistCount Group indicator = $DistGC "
echo "Total cols =  $TotalCol "
echo "Total rows = $TotalRows"

Add-content -path $ov_cpath -value "Table_Name|Col_Name|Col_Value|Col_Type|Data_Type"
Add-content -path $ov_cpath -value "axs_ovation_policy_info_$pvt|ISSUE STATE|$DistSC|DC|SLR_SUPP"
Add-content -path $ov_cpath -value "axs_ovation_policy_info_$pvt|GROUP INDICATOR|$DistGC|DC|SLR_SUPP"
Add-content -path $ov_cpath -value "axs_ovation_policy_info_$pvt|All_Rows|$TotalRows|C|SLR_SUPP"
Add-content -path $ov_cpath -value "axs_ovation_policy_info_$pvt|All_Cols|$TotalCol|C|SLR_SUPP"

echo "NUSA files copy: $(get-date -f 'yyyy-MM-dd HH:mm:ss').................."
# NUSA files copy
#========================
Copy-Item $nu_dtsrc "$nu_dpath"
Copy-Item $nu_clsrc "$nu_cpath"