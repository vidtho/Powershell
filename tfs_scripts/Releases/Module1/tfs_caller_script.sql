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
