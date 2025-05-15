# Example Docker setup for the LCA Collaboration Server

This repository contains a setup for running the [LCA Collaboration Server](https://www.openlca.org/collaboration-server/) in a Docker container.

## Requirements

To run this setup, you need Docker and Docker Compose:

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/)

## Environment variables

The setup will use environment variables. These can be set in a file named `.env`. The environment variables will be automatically loaded by the Docker Compose setup.

```bash
# Please fill in the following environment variables in this file
MYSQL_DATABASE=<please_fill_in>
MYSQL_USER=<please_fill_in>
MYSQL_PASSWORD=<please_fill_in>
MYSQL_ROOT_PASSWORD=<please_fill_in>
OPENSEARCH_INITIAL_ADMIN_PASSWORD=<please_fill_in>
SERVER_URL=<please_fill_in>  # optional
```

## Running the LCA Collaboration Server with Docker compose

You can start the collaboration server by executing the following command:

```bash
cd lca-collaboration-server-docker
docker compose up
```

> **_NOTE:_**  When modifying the `.env` file, you need to re-run the Docker
Compose command with the `--force-recreate` flag:

```bash
docker compose up --force-recreate
```

It will fetch images for the LCA Collaboration Server (from registry.greendelta.com), MySQL and OpenSearch. Then it starts containers for these images in interactive mode.

The setup will use two volumes (`db` and `server`) for storing data. These volumes are created if they do not exist yet:

```bash
$ docker volume ls
DRIVER    VOLUME NAME
local     lcacollab-db
local     lcacollab-server
```

### Setting up the server

The collaboration server will run on port `8080`, thus http://localhost:8080
will bring you to the login page of the collaboration server. The initial
admin credentials should be changed, see also the [configuration guide](https://www.openlca.org/lca-collaboration-server-2-configuration-guide/).

| Username        | Password            |
| --------------- | ------------------- |
| `administrator` | `Plea5eCh@ngeMe`    |


For using OpenSearch, you will need to stop and restart the containers (without
the `--force-recreate` flag!).
Then, re-index the repositories in `/administration/overview`. You can click on
`Run test search` in `/administration/settings` to verify that OpenSearch is
working.

## Running in read-only mode with external MySQL Server

The container can be run with the following command (the MySQL server must be up and running):

```bash
docker compose -f compose.read-only.yaml up
```

If you want to run the containers in background instead, just add the `-d` flag to the command.

The setup will use a single volume (`server`) for storing data. This volume is created if it does not exist yet:

```bash
$ docker volume ls
DRIVER    VOLUME NAME
local     lcacollab-server
```

## Run a stand alone MySQL container

For testing purposes, a MySQL container with different host name and port can be run with the following command:

```bash
docker compose -f compose.mysql.yaml up
```

The database schema is initialized at start.
