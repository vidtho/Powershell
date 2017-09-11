Powershell TFS scripts
The purpose of these scripts is to re-align the pl/sql scripts that as per directory structures in TFS and change our caller scripts accordingly

|----------------------------------|
|   Directory structure in TFS     |
|----------------------------------|
	|
	|------<schema 1>
		|------<Packages> 
		|------<Views>
		|------<SQL>
		|------<Tables>
	|
	|------<schema 2>
		|------<Packages> 
		|------<Views>
		|------<SQL>
		|------<Tables>
	|
	|------<Releases>
		|------<Module name> 
			  |------ TFS_caller_script.sql



TFS Caller script structure [TFS_caller_script.sql]
----------------------------------------------------
prompt
prompt Creating table Table1
prompt ======================================
prompt
@"..\..\<schema>\Tables\table1.sql"
prompt
prompt Creating table Table2
prompt ===================================
prompt
@"..\..\<schema>\Tables\table2.sql"

|----------------------------------|
|  local Directory strcture        |
|----------------------------------|
	|------<z_WIP>
		|
		|------<schema1>
			|------all sqlfiles
			|------local_caller_script.sql
		|
		|------<schema2>
			|------all sqlfiles
			|------local_caller_script.sql



local Caller script structure [local_caller_script.sql]
------------------------------------------------------
prompt
prompt Creating table Table1
prompt ==========================
prompt
@@table1.tab
prompt
prompt Creating table Table2
prompt ==========================
prompt
@@table2.tab

Assumptions
------------
1. all table scripts are stored as extension ".tab"
2. all views scripts ends as "_vw.sql"
3. all init scripts ends as "_init.sql"

Instructions
------------
1. Create new folder <scripts> anywhere you want
2. Create Following folders : <Schema 1>, <Schema 2>, <Releases>, <z_WIP>. You can use Scripts folder as template
|----------------------------|
|          Scripts           |
|----------------------------|
		|
		|------<Schema1>
			|------<Packages> 
			|------<Views>
			|------<SQL>
			|------<Tables>
		|
		|------<Schema2>
			|------<Packages> 
			|------<Views>
			|------<SQL>
			|------<Tables>
		|
		|------<Releases>
			|------<Module1> 
				  |------ tfs_caller_script.sql
				  |------ tfs_caller_script_grants.sql
		|
		|------<z_WIP>
			|------<schema1>
			|------<schema2>
			|------<CallerScripts>
		|
		|------main.ps1, merge.ps1, ren.ps1

3. Open merge1.ps1 and make following modifications
	- replace <Module1> with your appropriate /Scripts/Releases/Module1 folder
	- replace <tfs_caller_script.sql> with appropriate /Scripts/Releases/Module1/tfs_caller_script.sql script name
	- replace <tfs_caller_script_grants.sql> with appropriate /Scripts/Releases/Module1/tfs_caller_script_grants.sql script name

4. Open main.ps1 and make following modifications
	- Replace <Schema1>, <Schema2> will appropirate Schema name folders
	- replace <schema1_prefix>, <schema2_prefix> with short 2/3 letter schema name .....all the caller scripts will be prefixed with this name in folder <CallerScipts>

5. Execute the script in PowerShell:
   & ".\main.ps1" 

