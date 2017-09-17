<# To execute  the scripts in powershell

& ".\CreateFolders.ps1" 

Author : Vidya Thotangare
Version : 1.0
Purpose: This script will create folder templates in current directory along with sample script files. 
	 - Folders created for local scrips: z_WIP 
	 - Folders created for TFS upload : Releases
	 - All the Schema folders will be replicated from z_WIP
#>

remove-item ".\Releases" -Force -Recurse
remove-item ".\Schema1" -Force -Recurse
remove-item ".\Schema2" -Force -Recurse
remove-item ".\z_WIP" -Force -Recurse

new-item -Path ".\Releases\" -Name Module1 -ItemType directory

new-item -Path ".\z_WIP\" -Name Schema1 -ItemType directory
new-item -Path ".\z_WIP\" -Name Schema2 -ItemType directory
new-item -Path ".\z_WIP\" -Name CallerScripts -ItemType directory

#==============================================================================
Add-content -Path ".\z_WIP\CallerScripts\header.sql" @"
-- Instructions to execute the script
-- Please send output logfile in email back to xxx_xxx@xxx.com

-- Create Log File
spool xxx.txt
"@

Add-content -Path ".\z_WIP\CallerScripts\footer.sql" @"

spool off

"@

#==============================================================================
#Add-content -Path ".\Releases\Module1\tfs_caller_script.sql" @"
#-- Instructions to execute the script
#-- Please send output logfile in email back to xxx_xxx@xxx.com
#
#-- Create Log File
#spool xxx.txt
#
#prompt
#prompt Creating table table1
#prompt ======================================
#prompt
#@"..\..\Schema1\Tables\table1.sql"
#prompt
#prompt Creating table table2
#prompt ===================================
#prompt
#@"..\..\Schema1\Tables\table2.sql"
#
#spool off
#"@
#==============================================================================
Add-content -Path ".\z_WIP\Schema1\sh1_init.sql" @"
prompt All init1 data here
prompt ======================
"@

Add-content -Path ".\z_WIP\Schema1\view1.vw" @"
prompt create view view11
prompt ======================
"@

Add-content -Path ".\z_WIP\Schema1\view2.vw" @"
prompt create view view12
prompt ======================
"@

Add-content -Path ".\z_WIP\Schema1\table1.tab" @"
prompt  create table table11
prompt ======================
"@

Add-content -Path ".\z_WIP\Schema1\table2.tab" @"
prompt  create table table12
prompt ======================
"@

Add-content -Path ".\z_WIP\Schema1\pkgspec.pks" @"
prompt  create package pkg1
prompt ========================
"@

Add-content -Path ".\z_WIP\Schema1\pkgbody.pkb" @"
prompt  create package body pkg1
prompt =========================
"@

Add-content -Path ".\z_WIP\Schema1\sh1_run.sql" @"
prompt Creating table table1
prompt =======================
prompt
@@table1.tab
prompt Creating table table2
prompt ================
prompt
@@table2.tab
prompt
prompt Creating package pkg1
prompt ================
prompt
@@pkgspec.pks
prompt
prompt Creating package body pkg1
prompt ================
prompt
@@pkgbody.pkb
prompt
prompt creating views11
prompt ================
prompt
@@view1.vw
prompt
prompt creating views12
prompt ================
prompt
@@view2.vw
prompt
prompt INSERTING init data
prompt ======================
prompt
@@sh1_init.sql
"@

#==============================================================================
Add-content -Path ".\z_WIP\Schema2\sh2_init.sql" @"
prompt All init1 data here
prompt ======================
"@

Add-content -Path ".\z_WIP\Schema2\view1.vw" @"
prompt create view view21
prompt ======================
"@

Add-content -Path ".\z_WIP\Schema2\view2.vw" @"
prompt create view view22
prompt ======================
"@

Add-content -Path ".\z_WIP\Schema2\table1.tab" @"
prompt  create table table21
prompt ======================
"@

Add-content -Path ".\z_WIP\Schema2\table2.tab" @"
prompt  create table table22
prompt ======================
"@

Add-content -Path ".\z_WIP\Schema2\pkgspec.pks" @"
prompt  create package pkg2
prompt ========================
"@

Add-content -Path ".\z_WIP\Schema2\pkgbody.pkb" @"
prompt  create package body pkg2
prompt =========================
"@

Add-content -Path ".\z_WIP\Schema2\sh2_run.sql" @"
prompt Creating table table21
prompt =======================
prompt
@@table1.tab
prompt Creating table table22
prompt ================
prompt
@@table2.tab
prompt
prompt Creating package pkg2
prompt ================
prompt
@@pkgspec.pks
prompt
prompt Creating package body pkg2
prompt ================
prompt
@@pkgbody.pkb
prompt
prompt creating views21
prompt ================
prompt
@@view1.vw
prompt
prompt creating views22
prompt ================
prompt
@@view2.vw
prompt
prompt INSERTING init data
prompt ======================
prompt
@@sh1_init.sql
"@