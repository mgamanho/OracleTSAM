## Steps

Create TSAM and Oracle DB containers as explained [here](https://github.com/mgamanho/OracleTSAM).

### Ensure database can support XA

in Oracle XE container

    cd $ORACLE_HOME/rdbms/admin
    sqlplus sys/welcome1@localhost:1521/XE as sysdba @xaview.sql

then

    sqlplus sys/welcome1@localhost:1521/XE as sysdba
    SQL> grant select on v$xatrans$ to public;
    SQL> grant select on pending_trans$ to public;
    SQL> grant select on dba_2pc_pending to public;
    SQL> grant select on dba_pending_transactions to public;
    SQL> quit;

Increase max simultaneous connection:

    sqlplus sys/welcome1@localhost:1521/XE as sysdba
    SQL> alter system set processes=1000 scope=spfile;
    SQL> shutdown immediate;

### Change connection address in TSAM domain

    docker run -i -t oracle/tsam
    cd OraHome_1/tsam12.2.2.0.0/deploy
    mkdir tsam_wls12c
    jar xf ../tsam_wls12c.ear
    mkdir tsam
    cd tsam
    jar xf ../tsam.war
    # 172.17.0.2 is the original DB address, make sure it is in the persistence.xml file or
    # use the proper DB IP address
    sed -i "s=172.17.0.2=ora_db=g" ./WEB-INF/classes/META-INF/persistence.xml
    jar cf ../tsam.war *
    cd ..; rm -rf tsam
    jar cf ../tsam_wsl12c_new.ear *

## Build images in compose network

    docker-compose build

## Start up network

    docker-compose up -d 

## Connect to broker

    docker exec -i -t brokerapp_broker_1 /bin/bash

## Boot domain

    . ./boot.sh
