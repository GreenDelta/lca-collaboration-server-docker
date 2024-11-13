# Download and extract the server WAR file
FROM alpine:3.20 AS builder

WORKDIR /

# Install unzip
RUN apk add --no-cache --upgrade bash && \
    apk add unzip curl file

RUN mkdir ROOT
RUN curl -L https://www.openlca.org/download/lca-collaboration-server/latest  --output ROOT.war
RUN unzip ROOT.war -d ROOT

# Create the runner image
FROM tomcat:10-jdk21 AS runner

LABEL COMPANY="GreenDelta GmbH"
LABEL MAINTAINER="François Le Rall <lerall@greendelta.com>"

RUN addgroup collab && adduser --ingroup collab --disabled-login --shell /bin/sh collab

# Set up the /opt/collab directories with limited permissions
RUN mkdir -p /opt/collab/git /opt/collab/lib && \
    chown -R collab:collab /opt/collab && \
    chmod -R 750 /opt/collab

WORKDIR $CATALINA_HOME

RUN rm -rf webapps/* && \
    mkdir -p conf/Catalina/localhost/ROOT work/Catalina/localhost/ROOT && \
    chown -R collab:collab webapps conf work && \
    chmod -R 750 conf work && \
    umask 027

# Copy the server files
COPY --from=builder ROOT webapps/ROOT
COPY ./application.properties webapps/ROOT/WEB-INF/classes/application.properties
RUN chown -R collab:collab webapps/ROOT && \
    chmod -R 750 webapps/ROOT

USER collab

CMD ["catalina.sh", "run"]
