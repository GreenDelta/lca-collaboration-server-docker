FROM tomcat:10-jdk17

# OpenSearch

WORKDIR /usr/local

RUN wget https://artifacts.opensearch.org/releases/bundle/opensearch/2.13.0/opensearch-2.13.0-linux-x64.tar.gz
RUN tar -xvf opensearch-2.13.0-linux-x64.tar.gz
RUN mv opensearch-2.13.0 opensearch

WORKDIR /usr/local/opensearch
RUN bin/opensearch-plugin remove opensearch-security
COPY opensearch.yml config/

CMD ["./opensearch-tar-install.sh"]
