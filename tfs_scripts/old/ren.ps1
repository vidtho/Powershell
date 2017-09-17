param([string]$f1, [string]$sfx)
<# To execute  the scripts in powershell

& ".\ren.ps1" -f1 " <Schema1 folder> " -sfx "<schema1_prefix>"
& ".\ren.ps1" -f1 " <Schema2 folder> " -sfx "<schema2_prefix>"

#>

$path = ".\z_WIP\$f1\"+$sfx+"_run_template.sql"
$path2 = ".\z_WIP\CallerScripts\"+$sfx+"_main.sql"
$gnt = ".\z_WIP\$f1\"+$sfx+"_grants.sql"

##-===========================================
## remove folders from .\scriptsNew\<Schema> folder
##-===========================================

remove-item ".\$f1\Tables\" -Force -Recurse
remove-item ".\$f1\Packages\" -Force -Recurse
remove-item ".\$f1\SQL\" -Force -Recurse
remove-item ".\$f1\Views\" -Force -Recurse

##-===========================================
## create folders in .\scriptsNew\<Schema> folder
##-===========================================
new-item -Path ".\$f1\" -Name Packages -ItemType directory
new-item -Path ".\$f1\" -Name Tables -ItemType directory
new-item -Path ".\$f1\" -Name SQL -ItemType directory
new-item -Path ".\$f1\" -Name Views -ItemType directory


##-===========================================
## copy files from z_WIP\<shcema>  folders in .\scriptsNew\<Schema> folder
##-===========================================
Copy-Item ".\z_WIP\$f1\*.tab" ".\$f1\Tables\"
Copy-Item ".\z_WIP\$f1\*.pkb" ".\$f1\Packages\"
Copy-Item ".\z_WIP\$f1\*.pks" ".\$f1\Packages\"
Copy-Item ".\z_WIP\$f1\*init.sql" ".\$f1\SQL\"
Copy-Item ".\z_WIP\$f1\*vw.sql" ".\$f1\Views\"

##-===========================================
## rename .tab files to .sql in .\scriptsNew\<Schema>\tables
##-===========================================
Dir ".\$f1\Tables\*.tab" | rename-item -newname { [io.path]::ChangeExtension($_.name, "sql") }


##-===========================================
## Replace the lines with appropirate values in z_WIP\<schema>\<suffix>_run_template.sql
##-===========================================
# Formulate Tables
$tab = "@`"..\..\$f1\Tables\"
$w1 = "\.tab"
$r1 = ".sql"

$w2 = "Tables\\"+$sfx+"_init"
$r2 = "SQL\"+$sfx+"_init"

$w3 = "Tables\\"+$sfx+"_vw"
$r3 = "Views\"+$sfx+"_vw"

$text = get-content $path 
$newText = $text -replace $w1,$r1 -replace "@@",$tab -replace "\.pks", ".pks`"" -replace "\.pkb", ".pkb`"" -replace "Tables\\pk", "Packages\pk"  -replace "\.sql", ".sql`""  -replace $w2,$r2 -replace $w3,$r3
$newText > $path2

##-===========================================
## Copy the grant file to folder z_WIP\CallerScripts
##-===========================================
Copy-Item $gnt ".\z_WIP\CallerScripts\"

