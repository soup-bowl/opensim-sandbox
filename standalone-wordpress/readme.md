# OpenSimulator - Standalone + WordPress

This runs the same expertiment as the [Standalone instance](../standalone), but couples with an instance of WordPress that can manage the userbase via XMLRPC.

**Check the repository root readme for answers to most questions.**

## What this will do

### Architecture

The compose script will do the following:

* Builds a container, based on the [Mono image](https://hub.docker.com/_/mono/), to run OpenSimulator.
  * Wait for It is added so that our container checks the database has started up before it begins starting up OpenSim.
  * The build process picks up the **3 configuration files** and adds them to a directory within the container, so OpenSim can use them.
* Starts up a copy of **[MariaDB Server 10.5](https://mariadb.org/)**.
  * You can swap to [MySQL](https://hub.docker.com/_/mysql/) if you prefer - they're largely compatible with each other.
  * Be aware of a [modern charset database limitation](http://opensimulator.org/mantis/view.php?id=8919) - this is why 10.5 is used.
* Starts up an instance of **[WordPress](https://wordpress.org/)**. 
* Starts up an **[NGINX](https://nginx.org/en/) web server** - this is to show the grid welcome screen, and more details.
* **OpenSimulator** begins when the database instance reports it has finished initialising. It will create a db, populate it, then advertise that it is ready to accept connections.

**Once the initalisation finishes** (give it an extra minute), run `docker-compose exec wordpress wp-init` to automatically setup the WordPress instance for OpenSimulator usage.

Once the `docker-compose up` command is reporting all instances as done, you can visit the grid info page at [localhost:8080](http://localhost:8080).

### OpenSimulator

*For more information, see the [Standalone instance](../standalone).*

## Changing configurations

The configuration files are **built into the image**, so if you change the configuration files found in `.docker`, then you will need to run the following commands to rebuild the image (will not lose any data).

```bash
docker-compose up --build -d
```
