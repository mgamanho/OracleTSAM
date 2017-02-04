## Introduction

First build the Tuxedo 12.2.2 image using the instructions [here](https://github.com/oracle/docker-images/tree/master/OracleTuxedo). Make sure to download the Oracle Tuxedo 12.2.2.0 binary installer first.

This application uses TSAM Plus for monitoring. In order to build the TSAM Plus image, an Oracle DB image must also be built. The TSAM PLus and Oracle DB images are built outside of docker-compose then integrated here. See docker-compose.yaml

The TSAM Plus and Oracle DB containers are create as outlined [here](https://github.com/mgamanho/OracleTSAM). Make sure to download the required files.

Once these images are built, one step is required to place the correct Oracle DB address in the TSAM Plus configuration, this is outlined below.

Once the Tuxedo 12.2.2, TSAM Plus and Oracle DB images are built, proceed with the steps below.

## Preparing and running the Broker App Demo

### Clone repository locally and navigate to brokerapp sample directory

    git clone https://github.com/mgamanho/OracleTSAM
    cd samples/brokerapp

### Download required files

Download the following files

* TSAM Agent RP002 from [here](https://support.oracle.com/epmos/faces/PatchSearchResults?searchdata=%3Ccontext+type%3D%22BASIC%22+search%3D%22%26lt%3BSearch%26gt%3B%0A%26lt%3BFilter+name%3D%26quot%3Bpatch_number%26quot%3B+op%3D%26quot%3Bis%26quot%3B+value%3D%26quot%3B25389632%26quot%3B%2F%26gt%3B%0A%26lt%3BFilter+name%3D%26quot%3Bexclude_superseded%26quot%3B+op%3D%26quot%3Bis%26quot%3B+value%3D%26quot%3Bfalse%26quot%3B%2F%26gt%3B%0A%26lt%3B%2FSearch%26gt%3B%22%2F%3E) then extract file 23628853.zip
* Tuxedo 12.2.2.0 RP014 from [here](https://support.oracle.com/epmos/faces/PatchSearchResults?searchdata=%3Ccontext+type%3D%22BASIC%22+search%3D%22%26lt%3BSearch%26gt%3B%0A%26lt%3BFilter+name%3D%26quot%3Bpatch_number%26quot%3B+op%3D%26quot%3Bis%26quot%3B+value%3D%26quot%3B25219794%26quot%3B%2F%26gt%3B%0A%26lt%3BFilter+name%3D%26quot%3Bexclude_superseded%26quot%3B+op%3D%26quot%3Bis%26quot%3B+value%3D%26quot%3Bfalse%26quot%3B%2F%26gt%3B%0A%26lt%3B%2FSearch%26gt%3B%22%2F%3E) then extract file 25363300.zip
* instantclient-basic-linux.x64-12.1.0.2.0.zip   from http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html
* instantclient-precomp-linux.x64-12.1.0.2.0.zip from http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html
* instantclient-sqlplus-linux.x64-12.1.0.2.0.zip from http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html
* bankapp.zip from http://www.oracle.com/technetwork/indexes/samplecode/tuxedo-sample-522120.html

### Ensure database can support XA

Start the Oracle XE container

    docker run --name oraclexe --shm-size=1g -p 1521:1521 -p 8080:8080 -v ~/dockerDB:/u01/app/oracle/oradata oracle/database:11.2.0.2-xe
    $ cd $ORACLE_HOME/rdbms/admin
    $ sqlplus sys/welcome1@localhost:1521/XE as sysdba @xaview.sql

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
    
At this point you can stop the Oracle DB container and delete it (all information is persisted in the local volume).

    docker rm oraclexe

### Change connection address in TSAM domain

Start the TSAM Plus container in interactive mode

    docker run -i -t oracle/tsam
    
Use the following commands to configure the reference to the Oracle DB node for when the containers are run using docker-compose
    
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

## The demo environment is ready to use.

Access any of the nodes using *docker exec*

e.g. to log into the broker domain

    docker exec -i -t brokerapp_broker_1 /bin/bash
