######################
Troubleshooting Guide
######################

This page describes problems encountered using Fuego, and their solutions.

.. note::

   for Editors: please put each issue in it's own page section.


================
Installation
================

Problem with default Jenkins port
======================================

Fuego has Jenkins default to using port 8090 on the host system.
However, if you have something else already running on port 8090, you
may wish to change this.

You can change the Jenkins port during installation of Fuego,
using an argument to the install.sh script.  For example,
to install Fuego with Jenkins configured to use port 9999, use
the following command during installation:

::

  $ ./install.sh fuego 9999


To change the Jenkins port for an already-built Fuego container,
start the container, and inside the container edit the file:

 * /etc/default/jenkins

Change the line that says: HTTP_PORT=8090

Change to port to whatever your like.

Also, check the line that defines JENKINS_ARGS.  Mine looked like this:

::

  JENKINS_ARGS="--webroot=/var/cache/jenkins/war --httpPort=8090 --prefix=/fuego"


Change this line to read as follows:

::

  JENKINS_ARGS="--webroot=/var/cache/jenkins/war --httpPort=$HTTP_PORT --prefix=/fuego"

Then restart Jenkins:

 * $ service jenkins restart


Problem creating docker file
================================

Make sure you are running on a 64-bit version of the Linux kernel on
your host machine.

Problem starting Jenkins after initial container creation
==============================================================

Doug Crawford reported a problem starting Jenkins in the container
after his initial build.


::

  $ sudo ./docker-create-container.sh
  Created JTA container 6a420f901af7847f2afa3100d3fb3852b71bc65f92aecd13a9aefe0823d42b77
  $ sudo ./docker-start-container.sh Starting JTA container
  6a420f901af7847f2afa3100d3fb3852b71bc65f92aecd13a9aefe0823d42b77
  [....] Starting Jenkins Continuous Integration Server: jenkinssu: System error  failed!
  [ ok ] Starting OpenBSD Secure Shell server: sshd.
  [ ok ] Starting network benchmark server.


The error string is jenkinssu: System error

Takuo Kogushi provides the following response:

I had the same issue. I did some search in the net and found it is not
a problem of fuego itself.  As far as I know there are two
workarounds;

 1) Rebuild and install libpam with --disable-audit option (in the container) or
 2) Modify ``docker-create-container.sh`` to add --pid="host" option to docker
    create command

Here is a patch provided by Koguchi-san:

::

  diff --git a/fuego-host-scripts/docker-create-container.sh b/fuego-host-scripts/docker-create-container.sh
  index 2ea7961..24663d6 100755
  --- a/fuego-host-scripts/docker-create-container.sh
  +++ b/fuego-host-scripts/docker-create-container.sh
  @@ -7,7 +7,7 @@ while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symli  done  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

  -CONTAINER_ID=`sudo docker create -it -v $DIR/../userdata:/userdata --net="host" fuego`
  +CONTAINER_ID=`sudo docker create -it -v $DIR/../userdata:/userdata --pid="host" --net="host" fuego`
   CONTAINER_ID_FILE="$DIR/../last_fuego_container.id"
   echo "Created Fuego container $CONTAINER_ID"
   echo $CONTAINER_ID > $DIR/../last_fuego_container.id

Actually I have not tried the first one and do not know if there is
any side effects for the second.


This may be related to this docker bug:
`<https://github.com/docker/docker/issues/5899>`_


===========
General
===========

Timeout executing ssh commands
====================================

In some cases, the ssh command used by Fuego takes a very long time to
connect.  There is a timeout for the ssh commands, specified as 15
seconds in the cogent repository and 30 seconds in the fuegotest
repository.

The timeout for ssh commands is specified in the file

 * ``/fuego-core/scripts/overlays/base/base-params.fuegoclass``

You can change ConnectTimeout to something longer by editing the file.

::

  FIXTHIS - make ConnectTimeout for ssh connections a board-level test variable

ssh commands taking a long time
=====================================

Sometimes, even if the command does not time, the SSH operations
on the target take a very long time for each operation.

The symptom is that when you are watching the console output for a
test, the test stops at the point of each SSH connection to the
target.

One cause of long ssh connection times can be that the target ssh
server (sshd) is configured to do DNS lookups on each inbound
connection.

To turn this off, on the target, edit the file:

 * ``/etc/ssh/sshd_config``

and add the line:

::

  UseDNS no


This line can be added anywhere in the file, but I recommend adding
it right after the UsePrivilegeSeparation line (if that's there).


========================================
Handling different Fuego Error messages
========================================

Here are some Fuego error messages, their meaning, and how to fix them.

"Fuego error: Could not read 'before' syslog from board"
========================================================

This message is found in ``syslog.before.txt`` in the log directory for
a test run.  This indicates that Fuego could not find the 'before'
syslog during test execution.  This can happen if a board reboots during
a test, and the 'before' syslog was stored in a temp directory on the
board that is cleared on board reboot.  This is not a fatal error.

To avoid this problem, specify a different, non-ephemeral, tmp directory
in the board file for the board, using the variable ``FUEGO_TARGET_TMP``

Here is an example:

::

  FUEGO_TARGET_TMP="/home/fuego/tmp"

