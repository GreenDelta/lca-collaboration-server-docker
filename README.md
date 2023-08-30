# Example Docker setup for the LCA Collaboration Server 2.0

This repository contains a setup for running the [LCA Collaboration Server 2.0](https://www.openlca.org/collaboration-server/) in a Docker container. In order to run it, just checkout this repository, navigate to the project folder and run the following command:

```
docker compose up
```

This will build the image for the collaboration server and also fetch an image for MySQL if these images do not exist yet. Then it starts containers for these images in interactive mode. If you want to run the containers in background instead, just add the `-d` flag to the command:

```
docker compose up -d
```

The collaboration server will run at port `8080`, thus http://localhost:8080 will bring you to the login page of the collaboration server (the initial admin user is `administrator` with the password: `Plea5eCh@ngeMe`, see also the [configuration guide](https://www.openlca.org/lca-collaboration-server-2-0-configuration-guide/).)

The setup will use two volumes (`db-data` and `server-data`) for storing data. These volumes are created if they do not exist yet:

```bash
docker volume ls
# DRIVER VOLUME NAME
# local  lca-collaboration-server-docker_db-data
# local  lca-collaboration-server-docker_server-data
```
