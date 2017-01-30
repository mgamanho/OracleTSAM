Oracle TSAM Plus sample domains and apps
===
These sample Tuxedo containers provide applications that can be used to experiment quickly with TSAM Plus.

## Pre-requisites
Create an Oracle XE database

        cd ../../OracleDatabase/dockerfiles
        sh buildDockerImages.sh -v 11.2.0.2 -x

Start it

        docker run --shm-size=1g -p 1521:1521 -p 8080:8080 -v <your local directory>:/u01/app/oracle/oradata oracle/database:11.2.0.2-xe

## How to build and run
