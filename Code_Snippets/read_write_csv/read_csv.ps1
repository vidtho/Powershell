#  & ".\read_csv.ps1"  -pdb "vdb" -pusr "scott" -ppwd "tiger"

Param( [string]$pdb, [string]$pusr, [string]$ppwd )


$filename = "dept_txt.csv"
$fullpath = "C:\data_files\$filename"
echo $fullpath

$db = $pdb;
$user = $pusr;
$pw = $ppwd;

Add-Type -Path "C:\Oracle\product\11.2.0\client_1\ODP.NET\bin\2.x\Oracle.DataAccess.dll"

$constr = 'User Id=' + $user + ';Password=' + $pw + ';Data Source=' + $db
$conn= New-Object Oracle.DataAccess.Client.OracleConnection($constr)
$conn.Open()

##============================================================================================
## Insert one row at a time
#$fileContents = Import-Csv -Path $fullpath
#foreach ($line in $fileContents)
#{
#  $insert_stmt = 'insert into scott.vid_dept(deptno, dname, loc) Values ('+ $($line."DEPTNO") + ',''' + $($line."DNAME") + ''',''' + $($line."LOC") +''')'
#
#  # Create your command
#  $cmd = $conn.CreateCommand()
#  $cmd.CommandText = $insert_stmt
#
#  # Invoke the Insert statement
#  $cmd.ExecuteNonQuery()
#}


##==================================================================
## Bulk insert


$dept = Import-Csv -Path $fullpath	# import CSV

# Create empty arrays
$deptno = New-Object int[] $dept.Count
$dname = New-Object string[] $dept.Count
$dloc = New-Object string[] $dept.Count
$index = 0

#Populate the arrays with data
foreach ($d in $dept) {
    $deptno[$index] = $d.DEPTNO; 
    $dname[$index] = $d.DNAME;
    $dloc[$index] = $d.LOC;
    $index++
}
# echo $deptno
# echo $dname
# echo $dloc

# Create your command
$cmd = New-Object Oracle.DataAccess.Client.OracleCommand("insert into scott.vid_dept(deptno, dname, loc) Values (:1, :2, :3)",$conn)

# Create Parameters
$idParam = $cmd.Parameters.Add(":DEPTNO", [Oracle.DataAccess.Client.OracleDbType]::Int32)
$nameParam = $cmd.Parameters.Add(":DNAME", [Oracle.DataAccess.Client.OracleDbType]::Varchar2)
$locParam = $cmd.Parameters.Add(":LOC", [Oracle.DataAccess.Client.OracleDbType]::Varchar2)

# Assign the parameters to individual arrays
$idParam.Value = $deptno; $nameParam.Value = $dname; $locParam.Value = $dloc;

# Mention the bulk record count
$cmd.ArrayBindCount = $dept.Count

# Execute the query
$trans = $conn.BeginTransaction()
$cmd.ExecuteNonQuery()
$trans.Commit() 


$conn.Close()