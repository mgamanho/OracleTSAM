#!/bin/sh
CURDIR=`pwd`
INSTALLER=tsam122200_64_Linux_x86.zip

cd /home/oracle/Downloads
unzip -qq /home/oracle/Downloads/$INSTALLER
unzip -qq /home/oracle/Downloads/instantclient-basic-linux.x64-12.1.0.2.0.zip
unzip -qq /home/oracle/Downloads/instantclient-sqlplus-linux.x64-12.1.0.2.0.zip
mkdir -p /home/oracle/Downloads/sqlplus/bin
mv instantclient_12_1/* /home/oracle/Downloads/sqlplus/bin
PATH=/home/oracle/Downloads/sqlplus/bin:$PATH; export PATH
LD_LIBRARY_PATH=/home/oracle/Downloads/sqlplus/bin:$LD_LIBRARY_PATH; export LD_LIBRARY_PATH

echo "inventory_loc=/home/oracle/oraInventory" > /home/oracle/Downloads/oraInst.loc
echo "inst_group=oracle" >> /home/oracle/Downloads/oraInst.loc

if ! JAVA_HOME=/usr/java/default ./Disk1/install/runInstaller.sh -invPtrLoc /home/oracle/Downloads/oraInst.loc -responseFile $CURDIR/response.file -silent -waitforcompletion; then
	rm -rf /tmp/*
	rm -rf /home/oracle/OraHome_1
	JAVA_HOME=/usr/java/default ./Disk1/install/runInstaller.sh -invPtrLoc /home/oracle/Downloads/oraInst.loc -responseFile $CURDIR/response.file -silent -waitforcompletion	
fi
