.. _adding_or_cutomizing_a_distribution:

###########################################
Adding or Customizing a Distribution
###########################################

=====================
Introduction
=====================

Although Fuego is configured to execute on a standard Linux
distribution, Fuego supports customizing certain aspects of its
interaction with the system under test.  Fuego uses several features
of the operating system on the board to perform aspects of its test
execution.  This includes things like accessing the system log,
flushing file system caches, and rebooting the board.  The ability to
customize Fuego's interaction with the system under test is useful in
case you have a non-standard Linux distribution (where, say, certain
features of Linux are missing or changed), or when you are trying to
use Fuego with a non-Linux system.

A developer can customize the distribution layer of Fuego in one of
two ways:

 * adding overlay functions to a board file by creating a new
 * distribution overlay file

==============================
Distribution overlay file
==============================

A distribution overlay file can be added to Fuego, by adding a new
''.dist'' file to the directory: fuego-core/overlays/distrib

The *distribution* functions are defined in the file:
fuego-core/overlays/base/base-distrib.fuegoclass These include
functions for doing certain operations on your board, including:

 - :ref:`ov_get_firmware <func_ov_get_firmware>`
 - :ref:`ov_rootfs_reboot <func_ov_rootfs_reboot>`
 - :ref:`ov_rootfs_state <func_ov_rootfs_state>`
 - :ref:`ov_logger <func_ov_logger>`
 - :ref:`ov_rootfs_sync <func_ov_rootfs_sync>`
 - :ref:`ov_rootfs_drop_caches <func_ov_rootfs_drop_caches>`
 - :ref:`ov_rootfs_oom <func_ov_rootfs_oom>`
 - :ref:`ov_rootfs_kill <func_ov_rootfs_kill>`
 - :ref:`ov_rootfs_logread <func_ov_rootfs_logread>`

You can define your own *distribution* overlay by defining a new
".dist" file in fuego-core/overlays/distribs.  (e.g. mydist.dist)
Basically, you inherit functions from base-distrib.fuegoclass, and
write override functions in mydist.dist to perform those operations
the way they need to be done on your distribution.

You can look up what each override function should do by
reading the fuegoclass code, or looking at the function documentation
at: :ref:`Test Script APIs <test_script_apis>`

The inheritance mechanism and syntax for Fuego overlay files is
described at: :ref:`Overlay Generation <overlay_generation>`

The goal of the distribution abstraction layer in Fuego is to allow
you to customize Fuego operations to match what is available on your
target board.  For example, the default (base class)
:ref:`ov_rootfs_logread() <func_ov_rootfs_logread>` function assumes
that the target board has the command "/sbin/logread" that can be used
to read the system log.  If your distribution does not have
"/sbin/logread", or indeed if there is no system log, then you would
need to override ov_rootfs_logread() to do something appropriate for
your distribution or OS.

*Note: In fact, this is a common enough situation that there is*
*already a 'nologread.dist' file already in the overlay/distribs*
*directory.*

Similarly, :ref:`ov_rootfs_kill <func_ov_rootfs_kill>` uses the /proc
filesystem, /proc/$pid/status, and the cat, grep, kill and sleep
commands on the target board to do its work.  If our distribution is
missing any of these, then you would need to override ov_rootfs_kill()
with a function that did the appropriate thing on your distribution
(or OS).

Existing distribution overlay files
=====================================

Fuego provides a few distribution overlay files for certain situations
that commonly occur in embedded Linux testing.

 * nologread.dist - for systems that do not have a 'logread' command
 * nosyslogd.dist - for systems that don't have any system logger



===========================================================
Referencing the distribution in the board file 
===========================================================

Inside the board file for your board, indicate the distribution
overlay you are using by setting the *DISTRIB* variable.

If the DISTRIB variable is not set, then the default distribution
overlay functions are used.

For example, if your embedded distribution of Linux does not have a
system logger, you can override the normal logging interaction of
Fuego by using the 'nosyslogd.dist' distribution overlay.  To do this,
add the following line to the board file for target board where this
is the case: ::


  DISTRIB="nosyslogd.dist"

==================================================
Testing Fuego/distribution interactions 
==================================================

There is a test you can run to see if the minimal command set
required by Fuego is supported on your board.  It does not require
a toolchain, since it only runs shell script code on the board.
The test is Functional.fuego_board_check.

This test may work on your board, if your board supports a POSIX
shell interface. However, note that this test reflects the commands
that are used by Fuego core and by the default distribution overlay.
If you make your own distribution overlay, you may want to create a
version of this test that omits checks for things that your
distribution does not support, or that adds checks for things
that your distribution overlay uses to interact with the board.

=========
Notes 
=========

Fuego does not yet fully support testing non-Linux operating systems.
There is work-in-progress to support testing of NuttX, but that 
feature is not complete as of this writing. In any event, Fuego does 
include a 'NuttX' distribution overlay, which may provide some ideas 
if you wish to write your own overlay for a non-Linux OS.

NuttX distribution overlay
============================

By way of illustration, here are the contents of the NuttX 
distribution overlay file (fuego-core/overlays/distribs/nuttx.dist). ::


	override-func ov_get_firmware() {
		  FW="$(cmd uname -a)"
	}

	override-func ov_rootfs_reboot() {
		  cmd "reboot"
	}

	override-func ov_init_dir() {
		  # no-op
		  true
	}

	override-func ov_remove_and_init_dir() {
		  # no-op
		  true
	}
		  
	override-func ov_rootfs_state() {
		  cmd "echo; date; echo; free; echo; ps; echo; mount" || \
		      abort_job "Error executing rootfs_status operation on target"
	}

	override-func ov_logger() {
		  # messages are in $@, just emit them
		  echo "Fuego log messages: $@"
	}

	# $1 = tmp dir, $2 = before or after
	override-func ov_rootfs_logread() {
		  # no-op
		  true
	}

	override-func ov_rootfs_sync() {
		  # no-op
		  true
	}

	override-func ov_rootfs_drop_caches() {
		  # no-op
		  true
	}

	override-func ov_rootfs_oom() {
		  # no-op
		  true
	}

	override-func ov_rootfs_kill() {
		  # no-op
		  true
	}


Hypothetical QNX distribution
=================================

Say you wanted to add support for testing QNX with Fuego.

Here are some first steps to add a QNX distribution overlay:

 * set up your board file
 * create a custom QNX.dist (stubbing out or replacing base class 
   functions as needed)

    * you could copy null.dist to QNX.dist, and deciding which items 
      to replace with QNX-specific functionality
 
 * add DISTRIB="QNX.dist" to your board file
 * run the Functional.fuego_board_check test (using ftc, or adding 
   the node and job to Jenkins and building the job using the Jenkins 
   interface), and
 * examine the console log to see what issues surface









