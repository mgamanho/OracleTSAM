Oracle TSAM Plus on Docker
===============
Sample Docker build files to facilitate installation, configuration, and environment setup for DevOps users.

## How to build and run
This project offers a sample Dockerfile for Oracle TSAM 12c (12.2.2.0.0) with rolling patch 002.

## To use
Pull the oracle github projects

	git clone https://github.com/oracle/docker-images
	git clone https://github.com/mgamanho/OracleTSAM
  
### Oracle DB image and container

Download the Oracle XE installer from [here](http://www.oracle.com/technetwork/database/database-technologies/express-edition/downloads/index.html) and copy it to

    docker-images/OracleDatabase/dockerfiles/11.2.0.2

Build and run an Oracle XE 11.2.0.2.0 container, by following [these instructions](https://github.com/oracle/docker-images/tree/master/OracleDatabase) (scroll down to **Running Oracle Database Express Edition in a Docker container**)

**Note:** the local directory in the volume mapping (**~/dockerDB**:/u01/app/oracle/oradata) must belong to an oracle/oracle user with id/group of 1000/1000.

Example:

	cd docker-images/OracleDatabase/dockerfiles
	buildDockerImage.sh -v 11.2.0.2 -x
	mkdir ~/dockerDB
 	docker run --name oraclexe --shm-size=1g -p 1521:1521 -p 8080:8080 -v ~/dockerDB:/u01/app/oracle/oradata oracle/database:11.2.0.2-xe
	# reset SYS password if necessary
	docker exec oraclexe /u01/app/oracle/setPassword.sh <new sys password>

Leave the database running in that 'exec' shell.

### Java 8 base image

Create an Oracle Java 8 base image 

	cd docker-images/OracleJava/java-8

Download the [server-jre-8u111-linux-x64.tar.gz](http://www.oracle.com/technetwork/java/javase/downloads/server-jre8-downloads-2133154.html)

	sh build.sh

### TSAM Plus

Download TSAM+: http://www.oracle.com/technetwork/middleware/tuxedo/downloads/index.html

Download TSAM+ RP002: http://aru.us.oracle.com:8080/ARU/ViewPatchRequest/process_form?aru=20939386 ([My Oracle Support link](https://support.oracle.com/epmos/faces/PatchSearchResults?searchdata=%3Ccontext+type%3D%22BASIC%22+search%3D%22%26lt%3BSearch%26gt%3B%0A%26lt%3BFilter+name%3D%26quot%3Bpatch_number%26quot%3B+op%3D%26quot%3Bis%26quot%3B+value%3D%26quot%3B25389632%26quot%3B%2F%26gt%3B%0A%26lt%3BFilter+name%3D%26quot%3Bexclude_superseded%26quot%3B+op%3D%26quot%3Bis%26quot%3B+value%3D%26quot%3Bfalse%26quot%3B%2F%26gt%3B%0A%26lt%3B%2FSearch%26gt%3B%22%2F%3E))

Download Oracle Instant Client 12.1.0.2.0 from http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html, basic and sqlplus:
* instantclient-basic-linux.x64-12.1.0.2.0.zip
* instantclient-sqlplus-linux.x64-12.1.0.2.0.zip

Make sure all these files are in mgamanho/OracleTSAM/dockerfiles, then:

	cd mgamanho/OracleTSAM/dockerfiles
	docker build -t oracle/tsam .

To run TSAM Plus:

	docker run -i -t oracle/tsam 
	# in container:
	cd OraHome_1/tsam12.2.2.0.0/bin
	./startup.sh
  
