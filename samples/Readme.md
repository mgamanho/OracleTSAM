Oracle TSAM Plus sample domains and apps
===
These sample Tuxedo containers provide applications that can be used to experiment quickly with TSAM Plus.

## Pre-requisites
Create an Oracle XE database. Full instructions [here](https://github.com/oracle/docker-images/tree/master/OracleDatabase).

        cd ../../OracleDatabase/dockerfiles
        sh buildDockerImages.sh -v 11.2.0.2 -x

Start it

        docker run --shm-size=1g -p 1521:1521 -p 8080:8080 -v <your local directory>:/u01/app/oracle/oradata oracle/database:11.2.0.2-xe

Change sys password to 'welcome1'

        docker exec oraclexe /u01/app/oracle/setPassword.sh welcome1

## How to build and run
Download the following files

* tuxedo122200_64_Linux_01_x86.zip               from http://www.oracle.com/technetwork/middleware/tuxedo/downloads/index.html
* instantclient-basic-linux.x64-12.1.0.2.0.zip   from http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html
* instantclient-precomp-linux.x64-12.1.0.2.0.zip from http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html
* instantclient-sqlplus-linux.x64-12.1.0.2.0.zip from http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html

For Tuxedo 12.2.2, you need JRE installed first. Before you can build this image, you must download the Oracle Server JRE binary and drop in folder OracleJava/java-8 and build that image.

        cd ../OracleJava/java-8
        sh build.sh

Tux 12.2.2 image needs to be built

        cd ../OracleTuxedo/dockerfiles/12.2.2
        docker build -t oracle/tuxedo:12.2.2

Also download

* bankapp.zip from http://www.oracle.com/technetwork/indexes/samplecode/tuxedo-sample-522120.html

and place in the current directory.

Build image, example

        docker build --build-arg db_ip=172.17.0.3 -t oracle/tux_bankapp -f Dockerfile.bankapp.shm .

Image arguments, passed with **--build-arg**

* **db_ip**         IP address of the running Oracle XE database container. Get with command:

        docker inspect `docker ps -a | grep oracle/database:11.2.0.2-xe | grep Up | awk '{print $1}'` | grep IPAddress
