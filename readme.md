# Powershell SQL-TFS scripts
The purpose of these scripts is to re-align the pl/sql scripts that as per directory structures in TFS and change local caller scripts accordingly


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

## Scripts Description:
### CreateFolders.ps1: 
This script will create folder templates in current directory along with sample script files. 
- Folders created for local scrips: z_WIP 
- Folders created for TFS upload : Releases
- All the Schema folders will be replicated from z_WIP
- You can create schema folders in z_WIP and export schema objects to the respective folders using IDE's for SQL (Toad/SQL developer/PL SQL Developer)
- Files will be created as following directory structure

![scripts](/Documentation/scripts.png?raw=true)

### CreateTFSfolders.ps1
This script will loop through all schema folders in ".\z_WIP" and will copy the files to TFS respective schema\object folders
- For eg all the table scripts in .\z_WIP\<Schema'n'> will be copied to .\<Schema'n'>\Tables
- This operation will happen for init, view, Packages and Tables scripts.

### ParseTFSscript.ps1
This script will parse the script file \Releases\Module1\module1_tfs.sql and add tfs folder location prefixes (as shown above in table)

#### Commands and Order of execution in PowerShell:

```diff
- & ".\CreateFolders.ps1" 
- & ".\CreateTFSfolders.ps1" 
- & ".\ParseTFSscript.ps1"
```