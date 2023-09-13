# Example Docker setup for the LCA Collaboration Server 2.0

This repository contains a setup for running the [LCA Collaboration Server 2.0](https://www.openlca.org/collaboration-server/) in a Docker container. 



## Run the LCA Collaboration Server container in read-only mode with an external MySQL server.

To run the collaboration server in read-only mode, pull the `lca-collaboration-server` image or build it with the following command:

```bash
docker build -t lca-collaboration-server .
```

The MySQL server parameters must be adapted in `application.properties`:

```bash
spring.datasource.url=jdbc:mysql://<HOST>:<PORT>/<MYSQL_DATABASE>
spring.datasource.username=<MYSQL_USER>
spring.datasource.password=<MYSQL_PASSWORD>
[...]
```

The container can be run with the following command:

```bash
docker compose -f compose-read-only.yaml up
```

If you want to run the containers in background instead, just add the `-d` flag to the command:

```bash
docker compose -f compose-read-only.yaml up -d
```

The collaboration server will run at port `8080`, thus http://localhost:8080 will bring you to the login page of the collaboration server (the initial admin user is `administrator` with the password: `Plea5eCh@ngeMe`, see also the [configuration guide](https://www.openlca.org/lca-collaboration-server-2-0-configuration-guide/).)

The setup will use two volumes (`server-data`) for storing data. This volume is created if it does not exist yet:

```bash
docker volume ls
# DRIVER VOLUME NAME
# local  lca-collaboration-server-docker_server-data
```

## Run the LCA Collaboration Server container and the MySQL server.

In order to run the LCA Collaboration Server with the MySQL server, just checkout this repository, navigate to the project folder and run the following command:

```bash
docker compose -f compose-with-db.yaml up
```

This will build the image for the collaboration server and also fetch an image for MySQL if these images do not exist yet. Then it starts containers for these images in interactive mode. 

The setup will use two volumes (`db-data` and `server-data`) for storing data. These volumes are created if they do not exist yet:

```bash
docker volume ls
# DRIVER VOLUME NAME
# local  lca-collaboration-server-docker_db-data
# local  lca-collaboration-server-docker_server-data
```

## Run a stand alone MySQL container

For testing purposes, a MySQL container with different host name and port can be run with the following command:

```bash
docker compose -f mysql/compose.yaml up
```

The database schema is initialized at start.
