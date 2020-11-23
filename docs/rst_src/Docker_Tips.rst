#############
Docker Tips
#############

Here are some tips for using docker with Fuego:

============
Starting
============

After the container is created, you should start it by running:

::

  ./start.sh

This calls:

::

  ./fuego-host-scripts/docker-start-containter.sh

With no arguments, this will start the container named
``fuego-container``.  However, if you have a multiple fuego containers,
or have a container with a different name, you can specify the
container name on the start.sh command line.

Special privileged container
=================================

To run the container in a special privileged mode that allows access
to host USB devices (needed for accessing Android targets and
USB-SERIAL devices), create it using the "--priv" command line option
to ``./install.sh``:

::

  ./install.sh --priv

This will call
``./fuego-host-scripts/docker-create-usb-privileged-container.sh``
to create a container with extra privileges to certain host devices.

This script includes a set of devices that the container is granted
access to.  However, you may need to add a new device to the list.  To
add a new device to be accessible inside the docker container, please
edit the following line in ``docker-create-usb-privileged-container.sh``:

::

 CONTAINER_ID=`sudo docker create -it --privileged -v /dev/bus/usb:/dev/bus/usb -v /dev/ttyACM0:/dev/ttyACM0 ... --net="host" fuego`


With above, only "ttyUSBx" and "ttyACM0" will be detected and accessible inside
the docker container.

.. note::

   As of February, 2017, this script was in the next branch of the fuego repository.


============================
Operations while running
============================

 * Show the running docker ID

    * sudo docker ps

 * Execute a command in the container

    * docker exec <id> <some_command>

 * Attach another shell inside the container

    * sudo docker exec -i -t <id> bash
    * There is a helper script called 'fuegosh' which can be used to get a shell
      inside a currently running Fuego container

      * see fuego-core/scripts/fuegosh

 * Access docker container using ssh

    * ssh user@<ip_addr> -p 2222
    * sshd is running on 2222 in the container, if the default sshd_config is used

 * Copy files to the container

    * docker cp foo <id>:/path/to/dest

 * Copy files from the container

    * docker cp <id>:/path/to/src/foo bar

===========
Exiting
===========

To exit the docker container, just exit the primary shell that started
with the container was started.

==============
Persistence
==============

The Fuego container uses docker bind mounts so that some files persist
in the host filesystem, even when the container is not running.

In the host system, these are under ``fuego-ro``, ``fuego-rw`` and
``fuego-core`` in the directory where the container was created.

Here are some files that persist:

 * ``fuego-ro/boards*`` - for board definition files
 * ``fuego-ro/conf/ttc.conf`` - for use with ttc targets
 * ``fuego-ro/toolchains`` - this is where toolchains and SDKs can be installed
 * ``fuego-ro/toolchains/tools.sh`` - this file has the multiplexor for the different
   toolchains (on the PLATFORM variable)
 * ``fuego-rw/logs`` - this has logs from executed test runs
 * ``fuego-rw/work``
 * ``fuego-rw/buildzone`` - this is where test programs are built
 * ``fuego-rw/test`` - place where the board 'docker' places test materials

===================================================
How to determine if you're inside the container
===================================================

 * grep -q docker /proc/1/cgroup ; echo $?

   * Will be 0 if inside the container, 1 if on host

==========================
Cleaning up old images
==========================

I build lots of docker images, and they leave lots of data around.

 * **docker ps -a**  - show docker containers on your system, and their images
 * **docker images** - show images on your system, and their age and size
 * **docker rmi <id>** - remove an image (you must remove any containers using this image first)
 * **docker rm <id>** - remove a container

====================================================
Copy/Replace a file into a non-running container
====================================================

Background:

Consider a case where you make some changes to
``/etc/default/jenkins``
file when your container is running, and then you restart the
container. Unfortunately your container may not start because of an
issue in the ``/etc/default/jenkins`` file. How do you fix it as the
container itself is not running?

Solution:

Get the container id (of the non-running container) via

::

  $ 'docker ps -a' command


Replace the faulty file with original/corrected one via 'docker cp'
command as shown in the example below.

::

  $ sudo docker cp jenkins 6b4e6e63rfg7:/etc/default/


where '6b4e6e63rfg7' is the container id of the non-running container

Now you will able to start the docker container successfully.

