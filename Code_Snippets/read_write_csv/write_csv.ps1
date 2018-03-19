#  & ".\write_csv.ps1"  -pdb "vdb" -pusr "scott" -ppwd "tiger"

Param( [string]$pdb, [string]$pusr, [string]$ppwd )

$db = $pdb;
$user = $pusr;
$pw = $ppwd;

#[Reflection.Assembly]::LoadFile("C:\Oracle\product\11.2.0\client_1\ODP.NET\bin\2.x\Oracle.DataAccess.dll")

Add-Type -Path "C:\Oracle\product\11.2.0\client_1\ODP.NET\bin\2.x\Oracle.DataAccess.dll"

$constr = 'User Id=' + $user + ';Password=' + $pw + ';Data Source=' + $db
$conn= New-Object Oracle.DataAccess.Client.OracleConnection($constr)
$conn.Open()

$sql="select empno, ename, job, mgr, hiredate, sal, comm, deptno from scott.vid_emp"
$command = New-Object Oracle.DataAccess.Client.OracleCommand($sql,$conn)
$reader=$command.ExecuteReader()

# Emp file
$someArray = @()
	while($reader.Read()){
	  $row = @{}
	  $reader.GetOracleString(1).value
	  $row[$reader.GetName(0)] = $reader.GetOracleDecimal(0).value # empno
	  $row[$reader.GetName(1)] = $reader.GetOracleString(1).value  # ename
	  $row[$reader.GetName(2)] = $reader.GetOracleString(2).value  # job
	  $row[$reader.GetName(3)] = $reader.GetOracleDecimal(3).value # mgr
	  $row[$reader.GetName(4)] = $reader.GetOracleDate(4).value    # hiredate
	  $row[$reader.GetName(5)] = $reader.GetOracleDecimal(5).value # sal
	  $row[$reader.GetName(6)] = $reader.GetOracleDecimal(6).value # comm
	  $row[$reader.GetName(7)] = $reader.GetOracleDecimal(7).value # deptno

	  $someArray += new-object psobject -property $row  
	}

$someArray | Select empno, ename, job, mgr, hiredate, sal, comm, deptno |export-csv  -NoTypeInformation C:\data_files\emp_txt.csv
$someArray | Select empno, ename, job, mgr, hiredate, sal, comm, deptno |export-csv  -NoTypeInformation -Path C:\data_files\emp_pip.txt -Delimiter "|"
#======================================================================================================================================
$sql="select deptno, dname, loc from scott.vid_dept"
$command = New-Object Oracle.DataAccess.Client.OracleCommand($sql,$conn)
$reader=$command.ExecuteReader()

# Dept file
$someArray = @()
	while($reader.Read()){
	  $row = @{}
	  $reader.GetOracleString(1).value
	  $row[$reader.GetName(0)] = $reader.GetOracleDecimal(0).value # deptno
	  $row[$reader.GetName(1)] = $reader.GetOracleString(1).value  # dname
	  $row[$reader.GetName(2)] = $reader.GetOracleString(2).value  # loc

	  $someArray += new-object psobject -property $row  
	}

$conn.Close()
$someArray | Select deptno, dname, loc |export-csv  -NoTypeInformation C:\data_files\dept_txt.csv
$someArray | Select deptno, dname, loc |export-csv  -NoTypeInformation -Path C:\data_files\dept_pip.txt -Delimiter "|"