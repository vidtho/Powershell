<# To execute  the scripts in powershell

& ".\main.ps1" 

#>


& ".\ren.ps1" -f1 "[Schema1]" -sfx "[schema1_prefix]"
& ".\ren.ps1" -f1 "[Schema2]" -sfx "[schema2_prefix]"
& ".\merge.ps1" 