# A container with all contained

It is of course not recommended, but the `Dockerfile` in this folder will
build a container that includes everything:

* a MySQL database server
* an OpenSearch server
* and the openLCA Collaboration Server

Building the container should work just like this:

```bash
cd fat-container
# tag name is cs-fat in this example
docker build -t cs-fat .
```

When running the container, you probably want to map data folders and the
port:

```bash
docker run -p 8080:8080 \
   -v ./data:/data \
   -v ./data/tomcat/conf-ROOT:/usr/local/tomcat/conf/Catalina/localhost/ROOT \
   -v ./data/tomcat/work-ROOT:/usr/local/tomcat/work/Catalina/localhost/ROOT \
   --rm -it cs-fat
```

The folders on the left side of theses settings must exist before the container
is started. In the `data` folder, the sub-folders `mysql` and `opensearch` are
created when the container is started the first time.
