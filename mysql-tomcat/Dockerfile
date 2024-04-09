FROM tomcat:10-jdk17

WORKDIR /

ENV MYSQL_ROOT_PASSWORD=root-password
ENV MYSQL_DATABASE=collaboration-server
ENV MYSQL_USER=root

## Install MySQL

RUN apt-get update
RUN apt-get -y install xz-utils libaio1 libaio-dev libnuma-dev

WORKDIR /usr/local
RUN curl -SLO https://dev.mysql.com/get/Downloads/MySQL-8.3/mysql-8.3.0-linux-glibc2.28-x86_64.tar.xz
RUN tar xvf mysql-8.3.0-linux-glibc2.28-x86_64.tar.xz
RUN mv mysql-8.3.0-linux-glibc2.28-x86_64 mysql

WORKDIR /usr/local/mysql

ADD entrypoint.sh .
ADD schema.sql .
