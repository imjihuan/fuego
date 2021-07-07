.. _adding_board:


#################
Adding a Board
#################

==============
Overview
==============

To add your own board to Fuego, there are five main steps:

 1. Make sure you can access the target via ssh, serial or some
    other connection
 2. Decide whether to use an existing user account, or to create a
    user account specifically for testing
 3. Create a test directory on the target
 4. Create a board file (on the host)
 5. Add your board as a node in the Jenkins interface

1 - Set up communication to the target board
==============================================

In order for Fuego to test a board, it needs to communicate with it
from the host machine where Fuego is running.

The most common way to do this is to use 'ssh' access over a network
connection.  The target board needs to run an ssh server, and the host
machine connects to it using the 'ssh' client.

The method of setting an ssh server up on a board varies from system
to system, but sample instructions for setting up an ssh server on a
raspberry pi are located here:
:ref:`Raspberry Pi Fuego Setup <raspPiFuegoSetup>`

Another method that can work is to use a serial connection between
the host and the board's serial console.  Setting this up is outside
the scope of this current documentation, but Fuego uses the "serio"
package to accomplish this.  I

2 - Decide on user account for testing (creating one if needed)
=================================================================

On your target board, a user account is required in order to run tests.

The user account used by Fuego is determined by your board file, which
you will configure manually in step 4.  You need
to decide which account to use.  There are three options:

 * use the root account
 * use an existing account
 * use a new account, dedicated to testing

There are pros and cons to each approach.

My personal preference is to use the root account.  Several tests in
Fuego require root privileges.  If you are working with a test board,
that you can re-install easily, using the 'root' account will allow
you to run the greatest number of tests.  However, this should not be
used to test machines that are in production.  A Fuego test can run
all kinds of commands, and you should not trust that tests will not
destroy your machine (either accidentally or via some malicious
intent).

If you don't use 'root', then you can either use an existing account,
or create a new account.  In most circumstances it is worthwhile to
create a new account dedicated to testing.  However, you may not have
sufficient privileges on your board to do this.

In any event, at this point, decide which account you will use for
testing with Fuego, and note it to include in the board file,
described later.


3 - Create test directory on target
==============================================

First, log in to your target board, and create a directory where
tests can be run.  Usually, you do this as root, and a commonly
used directory for this is "/home/fuego".  To do this,
do the following:

For target with network connectivity : ::

	 $ ssh root@your_target
	 <target>$ mkdir /home/fuego
	 <target>$ exit


For target with Serial connectivity :

Use minicom or any other serial terminal tool.
Login to the target by giving username and password.
Create the directory 'fuego' as below: ::


 <target>$ mkdir /home/fuego



Create board file
===================

Now, create your board file.
The board files reside in <fuego-source-dir>/fuego-ro/boards, and
each file has a filename with the name of the board, with the
extension ".board".

The easiest way to create a board file is to copy an existing one,
and edit the variables to match those of your board.  The following
instructions are for a board called 'myboard', that has networking
access, an ssh daemon running on target, and the ARM architecture.

Do the following: ::

	$ cd fuego-ro/boards
	$ cp template-dev.board myboard.board
	$ vi myboard.board


.. Note::
   You can use your own editor in place of 'vi'*

Set board parameters
----------------------

A board file has parameters which define how Fuego interacts with your
board.  There are lots of different parameters, but the most important
to get started quickly (and the most commonly edited) are:

TRANSPORT parameters
`````````````````````
Each board needs to specify how Fuego will communicate with it.
This is done by specifying a TRANSPORT, and a few variables associated
with that transport type.

 * TRANSPORT - this specifies the transport to use with the target

   * there are three transport types currently supported: 'ssh',
     'serial', 'ttc'
   * Most boards will use the 'ssh' or 'serial' transport type
   * ex: TRANSPORT="ssh"

Most targets require the following:

 * LOGIN - specifies the user account to use for Fuego operations
 * PASSWORD - specifies the password for that account (if any)

There are some parameters that are specific to individual transports.

For targets using ssh:

 * IPADDR
 * SSH_PORT
 * SSH_KEY

IPADDR is the network address of your board.  SSH_PORT is the port
where the ssh daemon is listening for connections.  By default this is
22, but you should set this to whatever your target board uses.
SSH_KEY is the absolute path where an SSH key file may be found (to
allow password-less access to a target machine).

An example would be:

 * SSH_KEY="/fuego-ro/boards/myboard_id_rsa"

SSH_PORT and SSH_KEY are optional.

For targets using serial:

 * SERIAL
 * BAUD
 * IO_TIME_SERIAL

SERIAL is serial port name used to access the target from the host.
This is the name of the serial device node on the host (or in the
container).this is specified without the /dev/ prefix.

Some examples are:

 * ttyACM0
 * ttyACM1
 * ttyUSB0

BAUD is the baud-rate used for the serial communication, for eg.
"115200".

IO_TIME_SERIAL is the time required to catch the command's response
from the target. This is specified as a decimal fraction of a second,
and is usually very short.  A time that usually works is "0.1"
seconds.

 * ex: IO_TIME_SERIAL="0.1"

This value directly impacts the speed of operations over the serial
port, so it should be adjusted with caution.  However, if you find
that some operations are not working over the serial port, try
increasing this value (in small increments - 0.15, 0.2, etc.)

.. Note::
   In the case of TRANSPORT="serial", Please make sure that docker
   container and Fuego have sufficient permissions to access the
   specified serial port. You may need to modify
   docker-create-usb-privileged-container.sh prior to making your docker
   image, in order to make sure the container can access the ports.

   Also, if check that the host filesystem permissions on the device node
   (e.g /dev/ttyACM0 allows access. From inside the container you can try
   using the sersh or sercp commands directly, to test access to the
   target.

For targets using ttc:

 * TTC_TARGET

TTC_TARGET is the name of the target used with the 'ttc' command.


Other parameters
``````````````````

 * BOARD_TESTDIR
 * ARCHITECTURE
 * TOOLCHAIN
 * DISTRIB
 * BOARD_CONTROL

The BOARD_TESTDIR directory is an absolute path in the filesystem on
the target board where the Fuego tests are run.
Normally this is set to something like "/home/fuego", but you can set
it to anything.  The user you specify for LOGIN should have access
rights to this directory.

The ARCHITECTURE is a string describing the architecture used by
toolchains to build the tests for the target.

The TOOLCHAIN variable indicates the toolchain to use to build the
tests for the target.  If you are using an ARM target, set this to
"debian-armhf".  This is a default ARM toolchain installed in the
docker container, and should work for most ARM boards.

If you are not using ARM, or for some reason the pre-installed arm
toolchains don't work for the Linux distribution installed on your
board, then you will need to install your own SDK or toolchain.  In
this case, follow the steps in :ref:`Adding a toolchain <add_toolchain>`,
then come back to this step and set the TOOLCHAIN variable to the
name you used for that operation.

For other variables in the board file, see the section below.

The DISTRIB variable specifies attributes of the Linux distribution
running on the board, that are used by Fuego.  Currently, this is
mainly used to tell Fuego what kind of system logger the operating
system on the board has.  Here are some options that are available:

 * base.dist - a "standard" distribution that implements syslogd-style
   system logging.  It should have the commands: logread, logger, and
   /var/log/messages

 * nologread.dist - a distribution that has no 'logread' command, but
   does have /var/log/messages

 * nosyslogd.dist - a distribution that does not have syslogd-style
   system logging.

If DISTRIB is not specified, Fuego will default to using
"nosyslogd.dist".

The BOARD_CONTROL variable specifies the name of the system used to
control board hardware operations.  When Fuego is used in conjunction
with board control hardware, it can automate more testing
functionality.  Specifically, it can reboot the board, or re-provision
the board, as needed for testing.  As of the 1.3 release, Fuego only
supports the 'ttc' board control system.  Other board control systems
will be introduced and supported over time.

Add node to Jenkins interface
================================

Finally, add the board in the Jenkins interface.

In the Jenkins interface, boards are referred to as "Nodes".

You can see a list of the boards that Fuego knows about using:

 * $ ftc list-boards

When you run this command, you should see the name of the board you
just created.

You can see the nodes that have already been installed in Jenkins
with:

 * $ ftc list-nodes

To actually add the board as a node in jenkins, inside the docker
container, run the following command at a shell prompt:

 * $ ftc add-nodes -b <board_name>

==============================
Board-specific test variables
==============================

The following other variables can also be defined in the board file:

 * MAX_REBOOT_RETRIES
 * FUEGO_TARGET_TMP
 * FUEGO_BUILD_FLAGS

See :ref:`Variables <variables>` for the definition and usage of these
variables.

General Variables
====================

File System test variables (SATA, USB, MMC)
=============================================

If running filesystem tests, you will want to declare the Linux device
name and mountpoint path, for the filesystems to be tested.  There are
three different device/mountpoint options available depending on the
testplan you select (SATA, USB, or MMC).  Your board may have all of
these types of storage available, or only one.

To prepare to run a test on a filesystem on a sata device, define the
SATA device and mountpoint variables for your board.

For example, if you had a SATA device with a mountable filesystem
accessible on device /dev/sdb1, and you have a directory on your
target of /mnt/sata that can be used to mount this device at, you
could declare the following variables in your board file.

 * SATA_DEV="/dev/sdb1"
 * SATA_MP="/mnt/sata"

You can define variables with similar names (USB_DEV and USB_MP, or
MMC_DEV and MMC_MP) for USB-based filesystems or MMC-based
filesystems.

LTP test variables
======================

LTP (the Linux Test Project) test suite is a large collection of tests
that require some specialized handling, due to the complexity and
diversity of the suite. LTP has a large number of tests, some of which
may not work correctly on your board.  Some of the LTP tests depend on
the kernel configuration or on aspects of your Linux distribution or
your configuration.

You can control whether the LTP posix test succeeds by indicating the
number of positive and negative results you expect for your board.
These numbers are indicated in test variables in the board file:

 * LTP_OPEN_POSIX_SUBTEST_COUNT_POS
 * LTP_OPEN_POSIX_SUBTEST_COUNT_NEG

You should run the LTP test yourself once, to see what your baseline
values should be, then set these to the correct values for your board
(configuration and setup).

Then, Fuego will report any deviation from your accepted numbers, for
LTP tests on your board.

LTP may also use these other test variables defined in the board file:

 * FUNCTIONAL_LTP_HOMEDIR - If this variable is set, it indicates
   where a pre-installed version of LTP resides in the board's
   filesystem.  This can be used to avoid a lengthy deploy phase on
   each execution of LTP.
 * FUNCTIONAL_LTP_BOARD_SKIPLIST - This variable has a list of
   individual LTP test programs to skip.

See :ref:`Functional.LTP <functionalLTP>` for more information about
the LTP test, and test variables used by it.


