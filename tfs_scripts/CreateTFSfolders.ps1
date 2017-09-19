<# To execute  the scripts in powershell

& ".\CreateTFSfolders.ps1" 

Author : Vidya Thotangare
Version : 1.0
Purpose: This script will loop through all schema folders in ".\z_WIP" and will copy the files to TFS respective schema\object folders
	 - For eg all the table scripts in .\z_WIP\<Schema'n'> will be copied to .\<Schema'n'>\Tables
	 - This operation will happen for init, view, Packages and Tables scripts.

Assumptions:
	- All table scripts ends with ".tab"
	- All view scripts ends with ".vw"
	- All init scripts ends with "*init.sql"
	- All Packages scripts ends with ".pks" or ".pks"
	- All local caller scripts ends with "*run.sql"	

Things to change:
1. Change the $tfs_script variable to respective Module name [Module1] and script name
2. Change .\z_WIP\CallerScripts\header.sql with deployment instructions
#>

# -- Change the folder names here --------------------------------------------------------------
$exlist = ("CallerScripts")
$local_folder = ".\z_WIP\"

# Create TFS caller scripts
$tfs_script = ".\Releases\Module1\module1_tfs.sql"
$tfs_grants = ".\Releases\Module1\module1_tfs_grants.sql"
if (Test-Path $tfs_script) { Remove-Item $tfs_script -Force -Recurse }
Get-Content ".\z_WIP\CallerScripts\header.sql" | Set-Content "$tfs_script"

# -- End ----------------------------------------------------------------------------------

##-===========================================
## Loop through all .\z_WIP\ Schema folders
##-===========================================
ForEach ($dir in (Get-ChildItem -Path $local_folder -Exclude $exlist | Sort-Object -Descending | ?{$_.PSIsContainer})){
echo "Generating scripts for : $($dir.name)"
#echo "$($dir.fullname)"

$fullpath = "$($dir.fullname)"
$schfolder = "$($dir.name)"


    If (Test-Path -Path ".\$schfolder") { 
	remove-item ".\$schfolder" -Force -Recurse
	}
        
	## Create TFS Schema folders
	New-Item -Path ".\" -Name "$schfolder" -ItemType Directory | Out-Null
        New-Item -Path ".\$schfolder" -Name "Packages" -ItemType Directory  | Out-Null
	New-Item -Path ".\$schfolder" -Name "Tables" -ItemType Directory  | Out-Null
	New-Item -Path ".\$schfolder" -Name "Views" -ItemType Directory  | Out-Null
	New-Item -Path ".\$schfolder" -Name "SQL" -ItemType Directory | Out-Null

	## Copy files
	Copy-Item "$fullpath\*.tab" ".\$schfolder\Tables\"
	Copy-Item "$fullpath\*.pkb" ".\$schfolder\Packages\"
	Copy-Item "$fullpath\*.pks" ".\$schfolder\Packages\"
	Copy-Item "$fullpath\*init.sql" ".\$schfolder\SQL\"
	Copy-Item "$fullpath\*INS.sql" ".\$schfolder\SQL\"
	Copy-Item "$fullpath\*.vw" ".\$schfolder\Views\"

	## Copy .tab and .vw extensions
	Dir ".\$schfolder\Tables\*.tab" | rename-item -newname { [io.path]::ChangeExtension($_.name, "sql") }
	Dir ".\$schfolder\Views\*.vw" | rename-item -newname { [io.path]::ChangeExtension($_.name, "sql") }

	# Append *run.sql to the caller scripts
	Add-content -path "$tfs_script" -value "Prompt #################################"
	Add-content -path "$tfs_script" -value "Prompt Scripts for Schema $schfolder"
	Add-content -path "$tfs_script" -value "Prompt #################################"
	Add-content -path "$tfs_script" -value "Prompt "
	Get-Content "$fullpath\*run.sql" | Add-Content "$tfs_script"

	# Append *grants.sql to tfs caller scripts
	Add-content -path "$tfs_grants" -value "spool grants.txt"
	Add-content -path "$tfs_grants" -value "Prompt #################################"
	Add-content -path "$tfs_grants" -value "Prompt Scripts for Schema $schfolder"
	Add-content -path "$tfs_grants" -value "Prompt #################################"
	Add-content -path "$tfs_grants" -value "Prompt "
	Get-Content "$fullpath\*grants.sql" | Add-Content "$tfs_grants"
	Add-content -path "$tfs_grants" -value "spool off"
}

Get-Content ".\z_WIP\CallerScripts\footer.sql" | Add-Content "$tfs_script"

