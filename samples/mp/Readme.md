Dockerized bankapp app in MP mode, TSAM Plus enabled
===
This sample Tuxedo containers provide applications that can be used to experiment quickly with TSAM Plus.
Make sure to install docker compose as it is required.

## Pre-requisites

Create an Oracle XE database. Full instructions [here](https://github.com/oracle/docker-images/tree/master/OracleDatabase).

    cd ../../OracleDatabase/dockerfiles
    sh buildDockerImages.sh -v 11.2.0.2 -x

Start it once to create and initialize the database into a local directory

    docker run --shm-size=1g -p 1521:1521 -p 8080:8080 -v <local DB directory>:/u01/app/oracle/oradata oracle/database:11.2.0.2-xe

Once up and running, in another terminal change sys password to 'welcome1'

    docker exec oraclexe /u01/app/oracle/setPassword.sh welcome1

You can then stop this container with Ctrl-C

## How to build and run

Download the following files

* tuxedo122200_64_Linux_01_x86.zip from http://www.oracle.com/technetwork/middleware/tuxedo/downloads/index.html
* TSAM Agent RP002 from here then extract file 23628853.zip
* Tuxedo 12.2.2.0 RP014 from here then extract file 25363300.zip
* instantclient-basic-linux.x64-12.1.0.2.0.zip from http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html
* instantclient-precomp-linux.x64-12.1.0.2.0.zip from http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html
* instantclient-sqlplus-linux.x64-12.1.0.2.0.zip from http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html

For Tuxedo 12.2.2, you need JRE installed first. Before you can build this image, you must download the Oracle Server JRE binary and drop in folder OracleJava/java-8 and build that image.

    cd ../OracleJava/java-8
    sh build.sh

Tux 12.2.2 image needs to be built

    cd ../OracleTuxedo/dockerfiles/12.2.2
    docker build -t oracle/tuxedo:12.2.2 .

Also download

* bankapp.zip from http://www.oracle.com/technetwork/indexes/samplecode/tuxedo-sample-522120.html and place in the current directory.

Edit the docker-compose.yaml to specify your local DB directory

    version: '2'
      services:
        ora_db:
          image: oracle/database:11.2.0.2-xe
          shm_size: 1g
          volumes:
            - "<local DB directory>:/u01/app/oracle/oradata"
    ...
    
Run docker-compose build

    $ docker-compose build
    
Bring containers up

    $ docker-compose up -d
    
## Prepare app and test

Once containers are up and running, connect to the node that will become the master

    $ docker exec -it 1222_node1_1 /bin/bash
    [oracle@node1 bankapp]$

Create DB and users/schemas

    [oracle@node1 bankapp]$ . ./setupdb.sh
    
Compile TUXCONFIG and boot

    [oracle@node1 bankapp]$ . ./bankvar
    [oracle@node1 bankapp]$ tmloadcf -y ubb_mp
    [oracle@node1 bankapp]$ tmboot -y
    
Once booted, test with the native client

    [oracle@node1 bankapp]$ ./bankclt

To verify all nodes process requests, run "Balance Inquiry" on accounts 10000 and 80000, and other ranges if you like

    [oracle@node1 bankapp]$ tmadmin - Copyright (c) 1996-2016 Oracle.
    All Rights Reserved.
    Distributed under license by Oracle.
    Tuxedo is a registered trademark.

    > d -m SITE1

    SITE1> psc
    Service Name Routine Name Prog Name  Grp Name  ID    Machine  # Done Status
    ------------ ------------ ---------  --------  --    -------  ------ ------
    ...
    INQUIRY      INQUIRY      TLR        BANKB1     1      SITE1       2 AVAIL
    ...
    INQUIRY      INQUIRY      TLR        BANKB1     2      SITE1       1 AVAIL
    ...
    
    SITE1> d -m SITE2
    
    SITE2> psc
    Service Name Routine Name Prog Name  Grp Name  ID    Machine  # Done Status
    ------------ ------------ ---------  --------  --    -------  ------ ------
    ...
    INQUIRY      INQUIRY      TLR        BANKB2     3      SITE2       1 AVAIL
    ...
    INQUIRY      INQUIRY      TLR        BANKB2     4      SITE2       1 AVAIL
    ...
    
