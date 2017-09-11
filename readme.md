# Powershell SQL-TFS scripts
The purpose of these scripts is to re-align the pl/sql scripts that as per directory structures in TFS and change our caller scripts accordingly


| **Directory structure in TFS**		                 |  **Local Directory strcture**
---------------------------------------------------------------- |--------------------------------------------------------------------
|     ![folder](/Documentation/tfs_fldr.png?raw=true)            |     ![folder](/Documentation/local_fldr.png?raw=true)
|    **TFS Caller script structure [TFS_caller_script.sql]**	 |     **Local Caller script structure [local_caller_script.sql]**
|    ![script](/Documentation/tfs_caller.png?raw=true)           |     ![script](/Documentation/local_caller.png?raw=true)



## Assumptions
1. all table scripts are stored as extension **.tab**
2. all views scripts ends as **_vw.sql**
3. all init scripts ends as **_init.sql**
4. all package scripts ends as **.pks or pkb** and begins with **pk_**

## Instructions
1.	Download from the url. All the file creation will happen in folder [tfs_scripts]
2.	Create following folders under tfs_scripts : [Schema 1], [Schema 2], [Releases], [z_WIP]. OR
  -	 You can execute script **CreateFolders.ps1** to create a template folder structure. Command : **& ".\CreateFolders.ps1"**
  -	 Rename the respective schema names
3.	Generate individual scripts using any SQL IDE (sql developer/Toad etc) in \tfs_scripts\z_WIP\[Schema xx]. Save the caller file as [schema1_prefix]_run_template.sql

![scripts](/Documentation/scripts.png?raw=true)


4.	Open **merge1.ps1** and make following modifications
  -	 Replace [Module1] with your appropriate /Scripts/Releases/Module1 folder
  -	 Replace [tfs_caller_script.sql] with appropriate /Scripts/Releases/Module1/tfs_caller_script.sql script name
  -	 Replace [tfs_caller_script_grants.sql] with appropriate /Scripts/Releases/Module1/tfs_caller_script_grants.sql script name

5.	 Open **main.ps1** and make following modifications
  -	Replace [Schema1], [Schema2] will appropirate Schema name folders
  -	Replace [schema1_prefix], [schema2_prefix] with short 2/3 letter schema name .....all the caller scripts will be prefixed with this name in folder [CallerScipts]

6.	 Execute the script in PowerShell:
	**& ".\main.ps1"** 
