<# To execute  the scripts in powershell

& ".\merge.ps1" 

#>

##-===========================================
## create [tfs_caller_script.sql]
##-===========================================
remove-item ".\Releases\[Module1]\[tfs_caller_script.sql]" -Force -Recurse
remove-item ".\Releases\[Module1]\[tfs_caller_script_grants.sql]" -Force -Recurse

Get-Content ".\z_WIP\CallerScripts\header.sql" | Set-Content ".\Releases\[Module1]\[tfs_caller_script.sql]"
Get-Content ".\z_WIP\CallerScripts\sv_main.sql" | Add-Content ".\Releases\[Module1]\[tfs_caller_script.sql]"
Get-Content ".\z_WIP\CallerScripts\hs_main.sql" | Add-Content ".\Releases\[Module1]\[tfs_caller_script.sql]"
Add-content -path ".\Releases\[Module1]\[tfs_caller_script.sql]" -value "spool off"

##-===========================================
## create [tfs_caller_script_grants.sql]
##-===========================================
Get-Content ".\z_WIP\CallerScripts\*grants.sql" | Set-Content ".\Releases\[Module1]\[tfs_caller_script_grants.sql]"


