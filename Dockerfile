FROM tomcat:9-jdk17

WORKDIR /

# Install packages
RUN apt-get update
RUN apt-get install zip unzip

# File structure and installation files
RUN mkdir -p /opt/collab /opt/install
WORKDIR /opt/install
RUN curl https://www.openlca.org/wp-content/uploads/2023/08/lca-collaboration-server-installer-2.0.2_2023-08-17.jar --output installer.jar
COPY lca-collaboration-server-installer.config installer.config

# Fetch the server WAR file.
WORKDIR $CATALINA_HOME
RUN rm -fR webapps/*
RUN curl https://www.openlca.org/wp-content/uploads/2023/11/lca-collaboration-server-2.0.5_2023-11-08.war  --output webapps/ROOT.war

# Create the directories to be able to be able to run the container in read-only.
RUN mkdir -p webapps/ROOT conf/Catalina/localhost/ROOT work/Catalina/localhost/ROOT
RUN unzip $CATALINA_HOME/webapps/ROOT.war -d webapps/ROOT
RUN rm $CATALINA_HOME/webapps/ROOT.war

WORKDIR $CATALINA_HOME

CMD catalina.sh run
