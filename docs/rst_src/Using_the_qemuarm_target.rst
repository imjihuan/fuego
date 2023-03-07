.. _qemuarmtarget:

##########################
Using the qemuarm target
##########################

Here are some quick instructions for using the qemu-arm "board" that is
preinstalled in fuego.

Fuego does not ship with a qemuarm image in the repository, but
assumes that you have built one with the Yocto Project.

If you don't have one lying around, you will need to build one.  Then
you should follow the other steps on this page to configure it to run
with Fuego.

=========================
Build a qemuarm image
=========================

Here are some quick steps for building a qemuarm image using the Yocto
Project: (See the `Project Quick Start
<http://www.yoctoproject.org/docs/2.1/yocto-project-qs/
yocto-project-qs.html|Yocto>`_,
for more information)

Note that these steps are for Ubuntu.

 * Make sure you have required packages for building the software ::

     $ sudo apt-get install gawk wget git-core diffstat unzip texinfo \
        gcc-multilib build-essential chrpath socat libsdl1.2-dev xterm

 * Install the qemu software ::

     $ sudo apt-get install qemu-user

 * Download the latest stable release of the Yocto Project ::

     $ git clone git://git.yoctoproject.org/poky

 * Configure Yocto Project for building the qemuarm target ::

     $ cd poky
     $ source oe-init-build-env build-qemuarm build-qemuarm
     $ edit conf/local.conf

 * Under the comment about "Machine Selection", uncomment the line ::

     MACHINE ?= "qemuarm"

 * Build a minimal image (this will take a while) ::

     $ bitbake core-image-minimal

============================
Running the qemuarm image
============================

You can run the emulator, using the image you just built:

 * Run the emulator ::

     $ runqemu qemuarm

 * Find the address and ssh port for the image

   * Inside the image, do ``ifconfig eth0``

====================
Test connectivity
====================

From the host, verify that the networking is running: ::

 $ ping 192.168.7.2
 $ ssh root@192.168.7.2

Of course, substitute the correct IP address in the commands above.

Once you know that things are working, directly connecting from the host
to the qemuarm image, make sure the correct values are in the
``qemu-arm.board`` file.  You can edit this file on your host in
``fuego-ro/boards/qemu-arm.board``

Here are the values you should set: ::

 IPADDR="192.168.7.2"
 SSH_PORT=22
 LOGIN="root"
 PASSWORD=""

==========================
Test building software
==========================

It is important to be able to build the test software for the image
you are using with qemu.

The toolchain used to compile programs for a board is controlled via the
``TOOLCHAIN`` variable in the board file.  Currently the
``qemu-arm.board`` file specifies TOOLCHAIN="debian-armhf".

You may need to install the ``debian-armhf`` toolchain, or your own SDK
from your Yocto Project build, into the Fuego container in order to
build test programs for the qemuarm emulator.  See :ref:`Adding a
toolchain <add_toolchain>` for information about how to do that.

Try building a simple program, like ``hello_world``, as a test for the new
system, and see what happens.  You can try this by executing the
test ``Functional.hello_world``.  You can do that with this command: ::

 $ ftc run-test -b qemu-arm -t hello_world

