# OpenSimuator Configuration Sandbox
Some example [OpenSimulator][os] configuration setups, using [Docker][docker] (should also be compatible with [Podman][podman]) for quick prototyping.

For accessing the OpenSimulator metaverse, I recommend [Firestorm Viewer](https://www.firestormviewer.org/os-operating-system/).

## Experiments

Each folder contains a docker-compose file that will setup the OpenSimulator prototype.

Folder                    | Purpose
--------------------------|--------
[standalone](/standalone) | Sets up an OpenSimulator instance in standalone mode, using MySQL (mariadb 10.5) as the storage engine.

## Using Docker Compose / Cheat Sheet

* Start up an experiment: `docker-compose up --build -d`
  * `--build` will build the Docker file needed for OpenSimulator.
  * `-d` is optional - it brings you back to a prompt. If omitted, your terminal is locked to output (can return by typing `docker-compose logs`).
* Stop experiment: `docker-compose stop`
* Destroying: `docker-compose down -v`
  * `-v` will remove the associated volumes (e.g. database storage data). If you keep it, the files will still hang around for the next `up`.

## Troubleshooting

### OpenSimulator does not start

MySQL and MariaDB may take longer to initiate than OpenSimulator is able to wait, causing OpenSim to crash. In these instances, just wait 2-3 mins for the MySQL installation to finish initialising, then run compose up again. This time it should stay running as the database instance is readied.

### I'm not able to run commands in the OpenSimulator prompt

(In most instances, [wait-for-it][wfi] has been added to the buils to stop this situation from happening).

You are able to attach a shell to the current entrypoint, but so far this doesn't seem to work for me. You can 'cheese' this process by adding [screen][screen], allowing you to 'resume' the actively running session. To do this, replace the entrypoint in the Dockerfile to this:

```
ENTRYPOINT [ "screen", "-S", "OpenSim", "-D", "-m", "mono",  "./OpenSim.exe" ]
```

You can now access the OpenSimulator admin prompt by running `docker-compose exec metaverse /bin/bash` and then running `screen -r OpenSim`.

[os]:     http://opensimulator.org/wiki/Main_Page
[docker]: https://www.docker.com/
[wfi]:    https://github.com/docker/docker.github.io/blob/master/compose/startup-order.md
[podman]: https://podman.io/blogs/2021/01/11/podman-compose.html
[screen]: https://www.howtogeek.com/662422/how-to-use-linuxs-screen-command/
