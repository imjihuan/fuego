.. _addtoolchain:


###################
Adding a toolchain
###################

==================
Introduction
==================

In order to build tests for your target board, you need to install a
toolchain (often in the form of an SDK) into the Fuego system, and let
Fuego know how to access it.

Adding a toolchain to Fuego consists of these steps:

 * 1. obtain (generate or retrieve) the toolchain
 * 2. copy the toolchain to the container
 * 3. install the toolchain inside the container
 * 4. create a -tools.sh file for the toolchain
 * 5. reference the toolchain in the appropriate board file

========================
Obtain a toolchain
========================

First, you need to obtain a toolchain that will work with your board.
You should have a toolchain that produces software which will work
with the Linux distribution on your board.  This is usually obtained
from your build tool, if you are building the distribution yourself,
or from your semiconductor supplier or embedded Linux OS vendor, if
you have been provided the Linux distribution from an external source.


Installing a Debian cross-toolchain target
==============================================

If you are using an Debian-based target, then to get started, you may
use a script to install a cross-compiler toolchain into the container.
For example, for an ARM target, you might want to install the Debian
armv7hf toolchain.  You can even try a Debian toolchain with other
Linux distributions.  However, if you are not using Debian on your
target board, there is no guarantee that this will produce correct
software for your board.  It is much better to install your own SDK
for your board into the fuego system.

To install a Debian cross toolchain into the container, get to the
shell prompt in the container and use the following script:

 * /fuego-ro/toolchains/install_cross_toolchain.sh

To use the script, pass it the argument naming the cross-compile
architecture you are using.  Available values are:

 * arm64 armel armhf mips mipsel powerpc ppc64el

Execute the script, inside the docker container, with a single
command-line option to indicate the cross-toolchain to install.  You
can use the script more than once, if you wish to install multiple
toolchains.

Example:

 * # /fuego-ro/toolchains/install_cross_toolchain.sh armhf

The Debian packages for the specified toolchain will be installed into
the docker container.

Building a Yocto Project SDK
===============================

When you build an image in the Yocto Project, you can also build an
SDK to go with that image using the '-c do_populate_sdk' build step
with bitbake.

To build the SDK in Yocto Project, inside your yocto build directory
do:

 * bitbake <image-name> -c do_populate_sdk

This will build an SDK archive (containing the toolchain, header files
and libraries needed for creating software on your target, and put it
into the directory <build-root>/tmp/deploy/sdk/

For example, if you are building the 'core-image-minimal' image, you
would execute: ::

  $ bitbake core-image-minimal -c do_populate_sdk

At this step look in tmp/deploy/sdk and note the name of the sdk
install package (the file ending with .sh).

===========================================
Install the SDK in the docker container
===========================================

To allow fuego to use the SDK, you need to install it into the fuego
docker container.  First, transfer the SDK into the container using
docker cp.

With the container running, on the host machine do:

 * docker ps (note the container id)
 * docker cp tmp/deploy/sdk/<sdk-install-package> <container-id>:/tmp

This last command will place the SDK install package into the /tmp
directory in the container.

Now, install the SDK into the container, whereever you would like.
Many toolchains install themselves under /opt.

At the shell inside the container, run the SDK install script
(which is a self-extracting archive):

  * /tmp/poky-....sh

    * during the installation, select a toolchain installation
      location, like: /opt/poky/2.0.1

These instructions are for an SDK built by the Yocto Project.  Similar
instructions would apply for installing a different toolchain or SDK.
That is, get the SDK into the container, then install it inside the
container.

==============================================
Create a -tools.sh file for the toolchain
==============================================

Now, fuego needs to be told how to interact with the toolchain.
During test execution, the fuego system determines what toolchain to
use based on the value of the TOOLCHAIN variable in the board file for
the target under test.  The TOOLCHAIN variable is a string that is
used to select the appropriate '<TOOLCHAIN>-tools.sh' file in
/fuego-ro/toolchains.

You need to determine a name for this TOOLCHAIN, and then create a
file with that name, called $TOOLCHAIN-tools.sh.  So, for example if
you created an SDK with poky for the qemuarm image, you might call the
TOOLCHAIN "poky-qemuarm".  You would create a file called
"poky-qemuarm-tools.sh"

The -tools.sh file is used by Fuego to define the environment
variables needed to interact with the SDK.  This includes things like
CC, AR, and LD.  The complete list of variables that this script
neeeds to provide are described on the page [[tools.sh]]

Inside the -tools.sh file, you execute instructions that will set the
environment variables needed to build software with that SDK.  For an
SDK built by the Yocto Project, this involves setting a few variables,
and calling the environment-setup... script that comes with the SDK.
For SDKs from other sources, you can define the needed variables by
directly exporting them.

Here is an example of the tools.sh script for poky-qemuarm.  This is
in the sample file /fuego-ro/toolchains/poky-qemuarm-tools.sh: ::


	# fuego toolchain script
	# this sets up the environment needed for fuego to use a
	# toolchain
	# this includes the following variables:
	# CC, CXX, CPP, CXXCPP, CONFIGURE_FLAGS, AS, LD, ARCH
	# CROSS_COMPILE, PREFIX, HOST, SDKROOT
	# CFLAGS and LDFLAGS are optional
	#
	# this script is sourced by /fuego-ro/toolchains/tools.sh

	POKY_SDK_ROOT=/opt/poky/2.0.1
	export SDKROOT=${POKY_SDK_ROOT}/sysroots/
        armv5e-poky-linux-gnueabi

	# the Yocto project environment setup script changes PATH so
        # that python uses
	# libs from sysroot, which is not what we want, so save the
        # original path
	# and use it later
	ORIG_PATH=$PATH

	PREFIX=arm-poky-linux-gnueabi
	source ${POKY_SDK_ROOT}/environment-setup-armv5e-
        poky-linux-gnueabi

	HOST=arm-poky-linux-gnueabi

	# don't use PYTHONHOME from environment setup script
	unset PYTHONHOME
	env -u PYTHONHOME



===============================================
Reference the toolchain in a board file
===============================================

Now, to use that SDK for building test software for a particular
target board, set the value of the TOOLCHAIN variable in the board
file for that target.

Edit the board file:
 * vi /fuego-ro/boards/myboard.board

And add (or edit) the line:

 * TOOLCHAIN="poky-qemuarm"

============
Notes
============

Python execution
==================

You may notice that some of the example scripts set the environment
variable ORIG_PATH.  This is used by the function
[[function_run_python|run_python]] internally to execute the
container's default python interpreter, instead of the interpreter
that was built by the Yocto Project.






