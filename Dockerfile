FROM tomcat:9-jdk17

ARG mysql_host=collaboration-server-db

WORKDIR /

# 1. Update the OS and install dependencies
RUN apt-get update
RUN apt-get install zip unzip

# File structure and installation files
RUN mkdir -p /opt/collab /opt/install
WORKDIR /opt/install
COPY lca-collaboration-server-installer-* installer.jar
COPY lca-collaboration-server-installer.config installer.config

# Copy the server WAR file.
WORKDIR $CATALINA_HOME
RUN rm -fR webapps/*
COPY lca-collaboration-server-*.war webapps/ROOT.war

# Edit the MySQL host
WORKDIR /tmp
RUN unzip $CATALINA_HOME/webapps/ROOT.war WEB-INF/classes/application.properties -d .
RUN sed -i "s/localhost:3306/$mysql_host:3306/" WEB-INF/classes/application.properties
RUN zip --update $CATALINA_HOME/webapps/ROOT.war /WEB-INF/classes/application.properties

WORKDIR $CATALINA_HOME

CMD java -jar /opt/install/installer.jar -p /opt/install/installer.config ; catalina.sh run
