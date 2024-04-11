FROM tomcat:10-jdk17

# ENV SERVER_SERVLET_CONTEXT_PATH=/cs-fat

EXPOSE 8080

RUN apt-get update
RUN apt-get -y install unzip xz-utils libaio1 libnuma-dev libncurses5 sudo

RUN mkdir -p /opt/install
WORKDIR /opt/install

# install MySQL
RUN curl -SL https://dev.mysql.com/get/Downloads/MySQL-8.3/mysql-8.3.0-linux-glibc2.17-x86_64-minimal.tar.xz -o mysql.tar.xz
RUN tar xvf mysql.tar.xz
RUN mv mysql-8.3.0-linux-glibc2.17-x86_64-minimal mysql
RUN rm mysql.tar.xz

# install OpenSearch
RUN curl -SL https://artifacts.opensearch.org/releases/bundle/opensearch/2.13.0/opensearch-2.13.0-linux-x64.tar.gz -o search.tar.gz
RUN tar -xvf search.tar.gz
RUN mv opensearch-2.13.0 search
RUN rm search.tar.gz
RUN rm /opt/install/search/config/opensearch.yml
COPY ./opensearch.yml /opt/install/search/config

# create an OpenSearch user (we cannot run it as root)
RUN useradd -ms /bin/bash search_usr
RUN chmod -R a+rwx /opt/install/search

# install the CS
WORKDIR $CATALINA_HOME
RUN rm -fR webapps/*
RUN curl https://share.greendelta.com/index.php/s/SCt0vYJU2rsDRgq/download  -o webapps/ROOT.war

RUN mkdir -p webapps/ROOT conf/Catalina/localhost/ROOT work/Catalina/localhost/ROOT
RUN unzip $CATALINA_HOME/webapps/ROOT.war -d webapps/ROOT
RUN rm $CATALINA_HOME/webapps/ROOT.war
RUN rm $CATALINA_HOME/webapps/ROOT/WEB-INF/classes/application.properties
COPY ./application.properties $CATALINA_HOME/webapps/ROOT/WEB-INF/classes/application.properties

# RUN sed -i -e 's/<base href="\/"\/>/<base href="\/cs-fat" \/>/' ./webapps/ROOT/WEB-INF/classes/static/*.html

# copy other resources
WORKDIR /opt/install
COPY ./schema.sql schema.sql
COPY ./run.sh run.sh
RUN chmod +x run.sh
CMD ./run.sh
