<# To execute  the scripts in powershell

& ".\ParseTFSscript.ps1" 

Author : Vidya Thotangare
Version : 1.0
Purpose: This script will parse the script file \Releases\Module1\module1_tfs.sql and add tfs location prefixes

#>

$tfs_script1 = ".\Releases\Module1\module1_tfs.sql"
$tfs_script2 = ".\Releases\Module1\module1_tfs2.sql"

if (Test-Path $tfs_script2) { Remove-Item $tfs_script2 -Force -Recurse }

$content = Get-Content $tfs_script1
foreach ($line in $content)
{
    if ($line.contains("Schema")){ $schema = $line.Substring(26) }
    #echo "$schema"
    
    if ($line.contains(".tab")) {
      $tab = "@`"..\..\$schema\Tables\"
      $line = $line.replace('@@', $tab)
      $line = $line.replace('.tab', ".sql")
      #echo $line
    }

    if ($line.contains(".vw")) {
      $vw = "@`"..\..\$schema\Views\"
      $line = $line.replace('@@', $vw)
      $line = $line.replace('.vw', ".sql")
      #echo $line
    }

    if (($line.contains(".pks")) -Or ($line.contains(".pkb"))) {
      $pks = "@`"..\..\$schema\Packages\"
      $line = $line.replace('@@', $pks)
      #echo $line
    }

    if (($line.contains("init.sql")) -Or ($line.contains("INS.sql"))) {
     $init = "@`"..\..\$schema\SQL\"
      $line = $line.replace('@@', $init)
      #echo $line
    }
    
    if ($line.contains("@")) { Add-content -path "$tfs_script2" -value "$line`""}
    else { Add-content -path "$tfs_script2" -value "$line"}
} 

Remove-Item $tfs_script1 -Force -Recurse
Rename-Item $tfs_script2 "module1_tfs.sql"

echo "TFS parsed caller script: $tfs_script1"