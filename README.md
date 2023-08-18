# Docker environment for the LCA Collaboration Server 2.0

This Docker setup allow to run the LCA Collaboration Server on a `tomcat9` server (docker image `tomcat:9-jdk17`) along with a MySQL database (docker image `mysql:8.1`).


## Download the server and the installation files

Upload into the same directory as the `Dockerfile` the [LCA Collaboration Server WAR file](https://www.openlca.org/wp-content/uploads/2023/08/lca-collaboration-server-2.0.2_2023-08-16.war) and the [installer](https://www.openlca.org/wp-content/uploads/2023/08/lca-collaboration-server-installer-2.0.1_2023-08-15.jar).

## Run the multi-container app

With `Docker Compose version v2.20.2` run the following command:

```bash
docker compose up
```
