FROM oracle/serverjre:8
ENV TSAM_PKG=tsam122200_64_Linux_x86.zip

RUN yum -y install unzip gcc file libaio libXext libXrender libXtst; yum -y clean all && \
    groupadd -g 1000 oracle; useradd -b /home -m -g oracle -u 1000 -s /bin/bash oracle && \
    echo oracle:oracle | chpasswd; echo root:samplesvm | chpasswd

COPY instantclient-basic-linux.x64-12.1.0.2.0.zip instantclient-sqlplus-linux.x64-12.1.0.2.0.zip 23102895.zip install.sh instpatch.sh response.file deploy.py tsam122200_64_Linux_x86.zip /home/oracle/Downloads/

RUN chown oracle:oracle -R /home/oracle
WORKDIR /home/oracle/Downloads
USER oracle

RUN grep DB_CONNECTION response.file
RUN sh install.sh
RUN sh instpatch.sh 

RUN rm -f *.zip

USER oracle
WORKDIR /home/oracle
