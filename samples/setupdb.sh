export ORACLE_HOME=/home/oracle/instantclient_12_1
export PATH=$ORACLE_HOME:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME:$LD_LIBRARY_PATH

sqlplus sys/$DB_PWD@$DB_IP:1521/XE as sysdba << EOF
drop user bankdb1 cascade;
drop user bankdb2 cascade;
drop user bankdb3 cascade;
create user bankdb1 identified by bankdb1;
grant connect, resource to bankdb1;
create user bankdb2 identified by bankdb2;
grant connect, resource to bankdb2;
create user bankdb3 identified by bankdb3;
grant connect, resource to bankdb3;
exit
EOF

sqlplus bankdb1/bankdb1@172.17.0.3:1521/XE @crbankdl1.ora
sqlplus bankdb2/bankdb2@172.17.0.3:1521/XE @crbankdl2.ora
sqlplus bankdb3/bankdb3@172.17.0.3:1521/XE @crbankdl3.ora

