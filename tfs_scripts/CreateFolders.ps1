<# To execute  the scripts in powershell

& ".\CreateFolders.ps1" 

#>

remove-item ".\Releases" -Force -Recurse
remove-item ".\Schema1" -Force -Recurse
remove-item ".\Schema2" -Force -Recurse
remove-item ".\z_WIP" -Force -Recurse

new-item -Path ".\Releases\" -Name Module1 -ItemType directory

new-item -Path ".\Schema1\" -Name Packages -ItemType directory
new-item -Path ".\Schema1\" -Name Tables -ItemType directory
new-item -Path ".\Schema1\" -Name SQL -ItemType directory
new-item -Path ".\Schema1\" -Name Views -ItemType directory

new-item -Path ".\Schema2\" -Name Packages -ItemType directory
new-item -Path ".\Schema2\" -Name Tables -ItemType directory
new-item -Path ".\Schema2\" -Name SQL -ItemType directory
new-item -Path ".\Schema2\" -Name Views -ItemType directory

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

#==============================================================================
Add-content -Path ".\Releases\Module1\tfs_caller_script.sql" @"
-- Instructions to execute the script
-- Please send output logfile in email back to xxx_xxx@xxx.com

-- Create Log File
spool xxx.txt

prompt
prompt Creating table table1
prompt ======================================
prompt
@"..\..\Schema1\Tables\table1.sql"
prompt
prompt Creating table table2
prompt ===================================
prompt
@"..\..\Schema1\Tables\table2.sql"

spool off
"@
#==============================================================================
Add-content -Path ".\z_WIP\Schema1\sh1_init.sql" @"
prompt All init data here
prompt ======================
"@

Add-content -Path ".\z_WIP\Schema1\sh1_vw.sql" @"
prompt All views
prompt ======================
"@

Add-content -Path ".\z_WIP\Schema1\sh1_table1.tab" @"
prompt  create table table1
prompt ======================
"@

Add-content -Path ".\z_WIP\Schema1\sh1_table2.tab" @"
prompt  create table table2
prompt ======================
"@

Add-content -Path ".\z_WIP\Schema1\sh1_run_template.sql" @"
prompt Creating table1
prompt ================
prompt
@@sh1_table1.tab
prompt Creating table2
prompt ================
prompt
@@sh1_table2.tab
prompt
prompt Creating package
prompt ================
prompt
@@pk_package1.pkb
prompt
prompt creating views
prompt ================
prompt
@@sh1_vw.sql
prompt
prompt INSERTING init data
prompt ======================
prompt
@@sh1_init.sql
"@

#==============================================================================
Add-content -Path ".\z_WIP\Schema2\sh2_init.sql" @"
prompt All init data here
prompt ======================
"@

Add-content -Path ".\z_WIP\Schema2\sh2_vw.sql" @"
prompt All views
prompt ======================
"@

Add-content -Path ".\z_WIP\Schema2\sh2_table1.tab" @"
prompt  create table table1
prompt ======================
"@

Add-content -Path ".\z_WIP\Schema2\sh2_table2.tab" @"
prompt  create table table2
prompt ======================
"@

Add-content -Path ".\z_WIP\Schema2\sh2_run_template.sql" @"
prompt Creating table1
prompt ================
prompt
@@sh2_table1.tab
prompt Creating table2
prompt ================
prompt
@@sh2_table2.tab
prompt
prompt Creating package
prompt ================
prompt
@@pk_package1.pkb
prompt
prompt creating views
prompt ================
prompt
@@sh2_vw.sql
prompt
prompt INSERTING init data
prompt ======================
prompt
@@sh2_init.sql
"@