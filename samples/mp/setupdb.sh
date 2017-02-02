export ORACLE_HOME=/home/oracle/instantclient_12_1
export PATH=$ORACLE_HOME:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME:$LD_LIBRARY_PATH

sqlplus sys/$DB_PWD@$DB_IP:1521/XE as sysdba << EOF
drop user bankdb1 cascade;
drop user bankdb2 cascade;
create user bankdb1 identified by bankdb1;
grant connect, resource to bankdb1;
create user bankdb2 identified by bankdb2;
grant connect, resource to bankdb2;
exit
EOF

sqlplus bankdb1/bankdb1@$DB_IP:1521/XE @crbankdl1.ora
sqlplus bankdb2/bankdb2@$DB_IP:1521/XE @crbankdl2.ora
