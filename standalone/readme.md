# OpenSimulator - Standalone

This experiment runs OpenSimulator in the most basic format - [standalone mode](http://opensimulator.org/wiki/Configuration). Best mode for getting started with OpenSimulator.

**Check the repository root readme for answers to most questions.**

## What this will do

### Architecture

The compose script will do the following:

* Starts up a **[OpenSimulator](http://opensimulator.org/wiki/Main_Page)** server, using an [OpenSimulator Docker image](https://hub.docker.com/r/soupbowl/opensimulator).
  * A health check is in place to ensure everything starts *after* MariaDB finishes.
* Starts up a copy of **[MariaDB Server 10.5](https://mariadb.org/)**.
  * You can swap to [MySQL](https://hub.docker.com/_/mysql/) if you prefer - they're largely compatible with each other.
  * Be aware of a [modern charset database limitation](http://opensimulator.org/mantis/view.php?id=8919) - this is why 10.5 is used.
* Starts up an **[NGINX](https://nginx.org/en/) web server** - this is to show the grid welcome screen, and more details.
* **OpenSimulator** begins when the database instance reports it has finished initialising. It will create a db, populate it, then advertise that it is ready to accept connections.

Once the `docker compose up` command is reporting all instances as done, you can visit the grid info page at [localhost:8080](http://localhost:8080). 

### OpenSimulator

OpenSimulator will load in our three configuration files. Left untouched, it will instruct OpenSim to operate:

* In Standalone grid mode, meaning the region, estates, users and their inventories are all stored within this one instance.
* Tells OpenSimulator we want our data stored in the counterpart MariaDB (MySQL) database.
* Create a Region at vector point 1000,1000 (what does this mean? [Sheldon explains it well](https://youtu.be/Xk_sAi9mgxg?t=24)).
  * We also tie an estate owner account to be created with this region, called **Govenor Linden** (play on the [Linden Labs NPC](https://secondlife.fandom.com/wiki/Governor_Linden)). 

Open started, you can point your OpenSimulator viewer to `localhost:9000` and connect with credentials **Governor Linden** and **password**.

## Changing configurations

The configuration files are **built into the image**, so if you change the configuration files found in `.docker`, then you will need to run the following commands to rebuild the image (will not lose any data).

```bash
docker compose up --build -d
```
