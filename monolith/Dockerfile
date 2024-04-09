FROM tomcat:10-jdk17

EXPOSE 8080
WORKDIR /
RUN apt-get update

# CS
## Install packages
RUN apt-get install zip unzip

# File structure and installation files
RUN mkdir -p /opt/collab /opt/install
WORKDIR /opt/install
RUN curl https://share.greendelta.com/index.php/s/c1ulWTQ2NoKuZVB/download --output installer.jar
COPY lca-collaboration-server-installer.config installer.config

# Fetch the server WAR file.
WORKDIR $CATALINA_HOME
RUN rm -fR webapps/*
RUN curl https://share.greendelta.com/index.php/s/SCt0vYJU2rsDRgq/download  --output webapps/ROOT.war

## Create the directories to be able to be able to run the container in read-only.
RUN mkdir -p webapps/ROOT conf/Catalina/localhost/ROOT work/Catalina/localhost/ROOT
RUN unzip $CATALINA_HOME/webapps/ROOT.war -d webapps/ROOT
RUN rm $CATALINA_HOME/webapps/ROOT.war

COPY ./application.properties /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/application.

# DB

WORKDIR /

## Install MySQL

RUN apt-get update
RUN apt-get -y install xz-utils libaio1 libaio-dev libnuma-dev

WORKDIR /usr/local
RUN curl -SLO https://dev.mysql.com/get/Downloads/MySQL-8.3/mysql-8.3.0-linux-glibc2.28-x86_64.tar.xz
RUN tar xvf mysql-8.3.0-linux-glibc2.28-x86_64.tar.xz
RUN mv mysql-8.3.0-linux-glibc2.28-x86_64 mysql

WORKDIR /usr/local/mysql

ADD schema.sql .

# Starting the application

WORKDIR /
ADD entrypoint.sh .

USER root

CMD ["./entrypoint.sh"]