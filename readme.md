# Powershell SQL-TFS scripts
The purpose of these scripts is to re-align the pl/sql scripts as per directory structures in TFS and change local caller scripts accordingly


| **TFS Scripts Directory**		                         |  **Local Scripts Directory**
---------------------------------------------------------------- |--------------------------------------------------------------------
|     ![folder](/Documentation/tfs_fldr.png?raw=true)            |     ![folder](/Documentation/local_fldr.png?raw=true)
|    **TFS Caller script**	                                 |     **Local Caller script**
|    ![script](/Documentation/tfs_caller.png?raw=true)           |     ![script](/Documentation/local_caller.png?raw=true)



## Assumptions in local caller scripts
1. All table scripts ends with **.tab**
2. all views scripts ends with **.vw**
3. all init scripts ends with **_init.sql**
4. all package scripts ends with **.pks or pkb**
5. All local caller scripts ends with **run.sql**

## Instructions
1. Download the url from github.
2. Open powershell and go to [tfs_scripts] folder
3. Execute the Powershell script *CreateFolders.ps1*
	```diff
	& ".\CreateFolders.ps1" 
	```
4. Create or copy local schema folders with object scripts and caller scripts in \tfs_scripts\z_WIP\
5. Update *\tfs_scripts\z_WIP\CallerScripts\header.sql* to include deployment instructions or spool file detatils.
6. Execute the Powershell script *CreateTFSfolders.ps1*
	```diff
	& ".\CreateTFSfolders.ps1" 
	```
7. Execute the Powershell script *ParseTFSscript.ps1*
	```diff
	& ".\ParseTFSscript.ps1"
	```


## Scripts Description:
![scripts](/Documentation/scripts.png?raw=true)

#### Folders Created

|Script name | Folders generated | Description
|------------|------------------|----------
|GitHub Download | \tfs_scripts | Root folder that contains scripts
|CreateFolders.ps1 | \tfs_scripts\z_WIP <br/> \tfs_scripts\Releases  | Create template folders <br/> for generating local scripts
|CreateTFSfolders.ps1|\tfs_scripts\Schema1 <br/> \tfs_scripts\Schema2 | Create schema folders and its respective <br/> object folders as per TFS structure
|ParseTFSscript.ps1|\tfs_scripts\Releases\Module1\module1_tfs.sql | Parse the script file as per TFS structure

#### CreateFolders.ps1: 
This script will create folder templates in current directory along with sample script files. 

#### CreateTFSfolders.ps1
This script will loop through all schema folders in ".\z_WIP" and will copy the files to TFS respective schema\object folders
- For eg all the table scripts in .\z_WIP\<Schema'n'> will be copied to .\<Schema'n'>\Tables
- Similar operation will happen for init, view, Packages and Tables scripts.

#### ParseTFSscript.ps1
This script will parse the script file \Releases\Module1\module1_tfs.sql and add tfs folder location prefixes (as shown above in table)


