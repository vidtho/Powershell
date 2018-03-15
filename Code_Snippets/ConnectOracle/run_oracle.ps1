#  & ".\run_oracle.ps1"  -pdb "dbhr" -pusr "scott" -ppwd "tiger"

Param( [string]$pdb, [string]$pusr, [string]$ppwd )

$database = $pdb;
$user = $pusr;
$pw = $ppwd;
# =================================================================================================================
# Execute a script file in Powershell

$outfile = "sql-output.txt"
$scriptfile = "@test1.sql"

& 'C:\Oracle\product\11.2.0\client_1\BIN\sqlplus.exe' -s $user/$pw@$database  $scriptfile
#& 'C:\Oracle\product\11.2.0\client_1\BIN\sqlplus.exe' -s $user/$pw@$database  $scriptfile | out-file $outfile
# =================================================================================================================
# Get sql script data to a variable

$sqlQuery = @"
		set NewPage none
		set heading off
		set feedback off
		SELECT username FROM dba_users where rownum < 5;
		exit
"@

$sqlOutput = $sqlQuery | sqlplus -silent $user/$pw@$database 
echo $sqlOutput

# =================================================================================================================
# Pass Parameter to sql script

$sqlvar1= "dba_roles"
$scriptfile2 = "@test2.sql"

& 'C:\Oracle\product\11.2.0\client_1\BIN\sqlplus.exe' -s $user/$pw@$database  $scriptfile2 $sqlvar1