# OpenSimulator, via Firestorm in the Browser

This experiment runs both the client and the server in Docker. The OpenSimulator server is running [standalone mode](http://opensimulator.org/wiki/Configuration), but network isolated. It is accessed via [Firestorm running in a desktop container](https://github.com/soup-bowl/firestorm-docker), accessed via port 3001.

**Check the repository root readme for answers to most questions.**

## What this will do

### Architecture

The compose script will do the following:

* Starts up a **[OpenSimulator](http://opensimulator.org/wiki/Main_Page)** server, using an [OpenSimulator Docker image](https://hub.docker.com/r/soupbowl/opensimulator).
  * In this experiment, it is inaccessible to the host machine.
  * A health check is in place to ensure everything starts *after* MariaDB finishes.
* Starts up a copy of **[MariaDB Server 10.5](https://mariadb.org/)**.
  * You can swap to [MySQL](https://hub.docker.com/_/mysql/) if you prefer - they're largely compatible with each other.
  * Be aware of a [modern charset database limitation](http://opensimulator.org/mantis/view.php?id=8919) - this is why 10.5 is used.
* Starts up an **[NGINX](https://nginx.org/en/) web server** - this is to show the grid welcome screen, and more details.
  * In this experiment, it is inaccessible to the host machine.
* Starts up [**Firestorm Viewer** inside a container](https://github.com/soup-bowl/firestorm-docker), accessible via port 3001.
  * Selkies, the web viewer, requires HTTPS. So port 3001 - the HTTPS port - is exposed to access it.
  * The certificate is **self-signed**, so the browser will flag it. You can safely **ignore this warning**.
  * This can be hot-swapped for [Singularity Viewer]() - switch image to:
    `ghcr.io/soup-bowl/singularity-web:edge`

Once the `docker compose up` command is reporting all instances as done, you can access Firestorm Viewer at [localhost:3001](https://localhost:3001) (accept the self-signed cert).

**This will not immediately list the grid** - to access it: navigate to [Firestorm Web](https://localhost:3001), and you need to:
* Either press `ctrl + p`, or go to **Viewer** > **Preferences**.
* Navigate to **Opensim**
* In **Add new grid**, add **metaverse:9000**, and click **Apply**.
  * For some reason, the grid info won't display after closing Preferences. You can get it to appear by restarting the viewer instance (`docker compose restart viewer`).

Now you should see **Sandbox** in the grid list - you can login as normal to this one.

### Why `metaverse:9000` instead of `localhost:9000`?

Because the viewer is running _inside_ the container, rather than connecting to it, the viewer container has more access to the private network Docker Compose will make. So because of this, we no longer need to connect from outside the network, but from within. Docker registers the service key as the hostname, so the viewer sees `metaverse` as the container's private IP address.

Check the `docker-compose.yml` file, compare it to the `standalone/docker-compose.yml` - you'll see it has no ports open, except for the viewer!

### OpenSimulator

*For more information, see the [Standalone instance](../standalone#opensimulator).*

## Changing configurations

The configuration files are **built into the image**, so if you change the configuration files found in `.docker`, then you will need to run the following commands to rebuild the image (will not lose any data).

```bash
docker compose up --build -d
```
