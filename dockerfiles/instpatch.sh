#!/bin/sh
CURDIR=`pwd`

ORACLE_HOME=/home/oracle/OraHome_1; export ORACLE_HOME
PATH=$ORACLE_HOME/OPatch:$PATH; export PATH
cd /home/oracle/Downloads
opatch apply 23102895.zip -invPtrLoc /home/oracle/Downloads/oraInst.loc

ORACLECLI_HOME=/home/oracle/Downloads/sqlplus; export ORACLECLI_HOME
LD_LIBRARY_PATH=$ORACLECLI_HOME/bin:$LD_LIBRARY_PATH; export LD_LIBRARY_PATH
ORACLE_HOST=172.17.0.2; export ORACLE_HOST
ORACLE_PORT=1521; export ORACLE_PORT
ORACLE_SID=XE; export ORACLE_SID
TSAM_NAME=tsam_user; export TSAM_NAME
TSAM_PASSWORD=welcome1; export TSAM_PASSWORD
cd $ORACLE_HOME/tsam12.2.2.0.0/deploy
./DatabaseUpgradeOracleRP.sh

$ORACLE_HOME/tsam12.2.2.0.0/bin/startup.sh

WL_HOME=/home/oracle/OraHome_1/tsam12.2.2.0.0/wls; export WL_HOME
$WL_HOME/oracle_common/common/bin/wlst.sh /home/oracle/Downloads/deploy.py
