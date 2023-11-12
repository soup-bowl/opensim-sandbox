# OpenSimuator Configuration Sandbox
Some example [OpenSimulator][os] configuration setups, using [Docker][docker] (should also be compatible with [Podman][podman]) for quick prototyping.

For accessing the OpenSimulator metaverse, I recommend [Firestorm Viewer](https://www.firestormviewer.org/os-operating-system/).

> [!WARNING]  
> These sandboxes are built targeting the **AMD64** platform. Machines running **ARM** or **Apple Silicon** may not work.

## Experiments

Each folder contains a docker-compose file that will setup the OpenSimulator prototype.

Folder                        | Purpose
------------------------------|--------
[standalone][os-s]            | Sets up an OpenSimulator instance in standalone mode, using MySQL (mariadb 10.5) as the storage engine.
[standalone-wordpress][os-wp] | Same as Standalone, but has a WordPress instance prepped to control the userbase.

[os-s]:  standalone
[os-wp]: standalone-wordpress

## Using Docker Compose / Cheat Sheet

* Start up an experiment: `docker-compose up --build -d`
  * `--build` will build the Docker file needed for OpenSimulator.
  * `-d` is optional - it brings you back to a prompt. If omitted, your terminal is locked to output (can return by typing `docker-compose logs`).
* Stop experiment: `docker-compose stop`
* Destroying: `docker-compose down -v`
  * `-v` will remove the associated volumes (e.g. database storage data). If you keep it, the files will still hang around for the next `up`.

## Troubleshooting

### I'm not able to run commands in the OpenSimulator prompt

You are able to attach a shell to the current entrypoint, but so far this doesn't seem to work for me. You can 'cheese' this process by adding [screen][screen], allowing you to 'resume' the actively running session. To do this, replace the entrypoint in the Dockerfile to this:

```dockerfile
ENTRYPOINT [ "screen", "-S", "OpenSim", "-D", "-m", "mono",  "./OpenSim.exe" ]
```

You can now access the OpenSimulator admin prompt by running `docker-compose exec metaverse /bin/bash` and then running `screen -r OpenSim`.

## This does not work on Mac

In 2020, Apple began switching to ARM-based CPUs instead of the common x86-64 type. Currently **OpenSimulator does not officially declare support ARM CPUs**, so the software will not work as expected.

There are builds of OpenSimulator that **do** work on ARM, but the current mainline build of OpenSimulator ships with x86-64-only **physics drivers**. This means that if you start the sandboxes on an ARM machine, you'll crash when the physics library starts operating. If you *disable* the physics library, you can run OpenSimulator in a crtically reduced state. You can do this by changing the following setting in **OpenSim.ini**.

```ini
[Startup]
    physics = basicphysics
```

If you do this, prepare for a ... Weird experience.

[os]:     http://opensimulator.org/wiki/Main_Page
[docker]: https://www.docker.com/
[wfi]:    https://github.com/docker/docker.github.io/blob/master/compose/startup-order.md
[podman]: https://podman.io/blogs/2021/01/11/podman-compose.html
[screen]: https://www.howtogeek.com/662422/how-to-use-linuxs-screen-command/
