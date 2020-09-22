.. _integration_with_ttc:

############################
Integration with ttc
############################

This page describes how to use fuego with 'ttc'.  'ttc' is a tool used
for manual and automated access to and manipulation of target boards.
It is a tool developed by Tim Bird and used at Sony for managing their
board farms, and for doing kernel development on multiple different
target boards at a time (including especially boards with varying
processors and architectures.)

This page describes how ttc and fuego can be integrated, so that the
fuego test framework can use 'ttc' as it's transport mechanism.

You can find more information about 'ttc' on the linux wiki at:
http://elinux.org/Ttc_Program_Usage_Guide

========================================
Outline of supported functionality
========================================

Here is a rough outline of the support for 'ttc' in fuego:

 * Integration for the tool and helper utilities in the container
   build

   * When the docker container is built, ttc is downloaded from github
     and installed into the docker image.
   * During this process, the path to the ttc.conf file is changed
     from /etc/ttc.conf to /fuego-ro/conf/ttc.conf

 * 'ttc' is now a valid transport option

   * You can specify ttc as the 'transport' for a board, instead of
     ssh

 * ttc now supports -r as an option to the 'ttc cp' command

   * this is required since fuego uses -r extensively to do recursive
     directory copies (See :ref:`Transport_notes <transport_notes>`
     for details)

 * fuego-core has been modified to avoid using wildcards on 'get'
   operations

 * a new test called Functional.fuego_transport has been added

   * this tests use of wildcards, multiple files and directories and
     directory recursion with the 'put' command.
   * it also indirectly tests the 'get' command, because logs are
     obtained during the test.


==========================
Supported operations
==========================

ttc has several sub-commands.  Fuego currently only uses the following
ttc sub-commands:

 * 'ttc run' - to run a command on the target
 * 'ttc cp' - to get a file from the target, and to put files to the
   target

Note that some other commands, such as 'ttc reboot' are not used, in
spite of there being similar functionality provided in fuego (see
:ref:`function target reboot <func_target_reboot>` and :ref:`function
ov rootfs reboot <func_ov_rootfs_reboot>`).

Finally, other commands, such as 'ttc get_kernel', 'ttc get_config',
'ttc kbuild'  and 'ttc kinstall' are not used currently.  These may be
used in the future, when fuego is expanded to have a focus on tests
that require kernel rebuilding.

========================
Location of ttc.conf
========================

Normally, ttc uses the default configuration file at /etc/ttc.conf.
Fuego modifies ttc so that the default configuration file is located
at /userdata/conf/ttc.conf.

During fuego installation, /etc/ttc.conf is copied to userdata/conf
from the host machine, if it is present (and a copy of ttc.conf is
not already there).

========================================
Steps to use ttc with a target board
========================================

Here is a list of steps to set up a target board to use ttc.
These steps assume you have already added a board to fuego
following the steps described in :ref:`Adding a board <adding_board>`.

 * If needed, create your docker container using 'docker-create-usb-
   privileged-container.sh'

    * This may be needed if you are using ttc with board controls that
      require access to USB devices (such as the Sony debug board)
    * substitute this command in place of 'docker-create-container.sh'
      in the `Fuego Quickstart Guide <http://fuegotest.org/wiki/Fuego_
      Quickstart_Guide#Download,_build,_start_and_access>`_.

 * Make sure that /userdata/conf/ttc.conf has the definitions required
   for your target board

   * Validate this by doing 'ttc list' to see that the board is
     present, and 'ttc run' and 'ttc cp' commands, to test that these
     operations work with the board, from inside the container.

 * Edit the fuego board file (found in /userdata/conf/boards
   /<somthing>.board)

   * Set the TRANSPORT to 'ttc'
   * Set the TTC_TARGET variable is set to the name for the target
     used by ttc
   * See the following example, for a definition for a target named
     'bbb' (for my beaglebone black board)::


	TRANSPORT=ttc
	TTC_TARGET=bbb

===========================
modify your copy_to_cmd
===========================

In your ttc.conf file, you may need to make changes to any copy_to_cmd
definitions.  Fuego allows programs to pass a '-r' argument to its
internal 'put' command, which in turn invokes ttc's cp command, with
the source as target and destination as the host.  In other words, it
ends up invokings ttc's 'copy_from_cmd' for the indicated target.

All versions of copy_to_cmd should be modified to
reference a new environment variable $copy_args.

Basically, if a fuego test uses 'put -r' at any point, this needs to be
supported by ttc.  ttc will pass any '-r' seen to the subcommand in
the environment variable $copy_args, where you can use it as needed
with whatever sub-command (cp, scp, or something else) that you
use to execute a copy_to_cmd.

See examples in ttc.conf.sample and ttc.conf.sample2 for usage examples.







