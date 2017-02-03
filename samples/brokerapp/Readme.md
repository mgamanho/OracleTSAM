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

## Connect to broker and prepare domain

    docker exec -i -t brokerapp_broker_1 /bin/bash

Create tables

    $ . ./setupdb_br.sh

Sometimes the following message may appear. Run the script again if that it the case.

    ORA-12528: TNS:listener: all appropriate instances are blocking new connections

Load all configurations

    docker exec -i -t brokerapp_broker_1 /bin/bash # if not connected already
    $ . ./setenv
    $ tmloadcf -y ubb
    $ dmloadcf -y dubb.broker
    $ tmloadrepos -i all.mif metadata.rps
    $ wsloadcf -y GWWS.deploy

## Boot domain

    docker exec -i -t brokerapp_broker_1 /bin/bash # if not connected already
    $ . ./setenv
    $ tmboot -y

## Start TSAM Plus

### Redeploy TSAM app

    docker exec -i -t brokerapp_tsamnode_1 /bin/bash
    $ cd OraHome_1/tsam12.2.2.0.0/bin
    $ ./startup.sh

Then connect to console at http://localhost:7001/console

* Go to **Deployments**
* Click on **Install** button
* In *Current Location* navigate to "localhost / home / oracle / OraHome_1 / tsam12.2.2.0.0 / deploy"
* Select the ear file you created previously, should be named tsam_wsl12c_new.ear
* Click **Next**
* Use the default and click **Next** again
* Use the defaults and click **Finish**

When deployment goes well, you can log in to TSAM at http://localhost:7001/tsam

