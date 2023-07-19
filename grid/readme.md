# OpenSimulator - Grid

This experiment runs OpenSimulator in grid mode, using a central [Robust instance](http://opensimulator.org/wiki/ROBUST). The intention being that more OpenSimulator grid servers can be added, all controlled by a centralised Robust instance.

**Check the repository root readme for answers to most questions.**

## Running this experiment

The Robust instance needs to be told about a user account before initialising. So to begin the experiment, do the following:

* Run `docker compose up --build -d db db_pma robust`.
* Run `docker compose exec robust screen -r` to enter Robust server command mode.
* Type `create user` and press enter.
  * **Governor** for first name.
  * **Linden** for last name.
  * Password is your choice, but it's safe for you to just use **password**.
  * Skip (press enter) for the rest.
* Close the connection (just close the command prompt).
* Start a new session, and run `docker compose up -d` to start-up the remaining grid instances.

## What this will do

### Architecture

The compose script will do the following:

* Starts up two copies of **[OpenSimulator](http://opensimulator.org/wiki/Main_Page)** server, using an [OpenSimulator Docker image](https://hub.docker.com/r/soupbowl/opensimulator). One set into [Robust mode](http://opensimulator.org/wiki/ROBUST).
* Starts up a copy of **[MariaDB Server 10.5](https://mariadb.org/)**.
  * You can swap to [MySQL](https://hub.docker.com/_/mysql/) if you prefer - they're largely compatible with each other.
  * Be aware of a [modern charset database limitation](http://opensimulator.org/mantis/view.php?id=8919) - this is why 10.5 is used.
* Starts up an **[NGINX](https://nginx.org/en/) web server** - this is to show the grid welcome screen, and more details.
* **Robust** begins when the database instance reports it has finished initialising. It will create a db, populate it, then advertise that it is ready to accept connections.
* **OpenSimulator** will start-up and handshake with the Robust instance.

Once the `docker-compose up` command is reporting all instances as done, you can visit the grid info page at [localhost:8080](http://localhost:8080). 

### Robust

[Robust instance](http://opensimulator.org/wiki/ROBUST) will load in the Robust.ini configuration file, and understand that it now operates as the centralised grid services container. This means this container will take on the jobs of managing user, inventory, asset, etc, and lets the individual grids offload the work onto this container. 

Open started, you can point your OpenSimulator viewer to `localhost:8002` and connect with credentials **Governor Linden** and **password**. A grid needs to be started first, otherwise you'll pass verification and then fail as your avatar has nowhere to go.

### OpenSimulator

OpenSimulator will load in our three configuration files. Left untouched, it will instruct OpenSim to operate:

* In grid mode, offloading management to the Robust instance.
* Create a Region at vector point 1000,1000 (what does this mean? [Sheldon explains it well](https://youtu.be/Xk_sAi9mgxg?t=24)).
  * We also tie an estate owner account to be created with this region, called **Govenor Linden** (play on the [Linden Labs NPC](https://secondlife.fandom.com/wiki/Governor_Linden)), hence why you need to create the specific user first.
  * This grid is also registered as the **home/default grid**, meaning you'll land here if your viewer specifies an unknown location.
