.. _test_variables:

####################
Test variables
####################

==================
Introduction
==================

When Fuego executes a test, shell environment variables are used to
provide information about the test environment, test execution
parameters, communications methods and parameters, and other items.

These pieces of information are originate from numerous different
places.  An initial set of test variables comes in the shell
environment from either Jenkins or from the shell in which ftc is
executed (depending on which one is used to invoke the test).

The information about the board being tested comes primarily from two
sources:

 * the board file
 * the stored board variables file

Additional information comes from the testplan and test spec that are
used for this particular test run.  Finally, test variables can be
defined on the 'ftc' command line.  These test variables (know as
*dynamic variables*, override variables that come from other sources.

Test variables can be simple strings, or they may be shell functions.

When a test is run, Fuego gathers information from all these sources,
and makes them available to the test (and uses them itself) to control
test execution.

==============
Board file
==============
 
The board file contains static information about a board.  It is
processed by the overlay system, and the values inside it appear as
variables in the environment of a test, during test execution.

The board file resides in:

 * /fuego-ro/boards/$BOARD.board

There are a number of variables which are used by the Fuego system
itself, and there may also be variables that are used by individual
tests.

Common board variables 
=========================

Here is a list of the variables which might be found in a board file:

 * ARCHITECTURE - specifies the architecture of the board
 * BAUD - baud rate for serial device (if using 'serial' transport)
 * BOARD_TESTDIR - directory on board where tests are executed
 * BOARD_CONTROL - the mechanism used to control board hardware 
   (e.g. hardware reboot)
 * DISTRIB - filename of distribution overlay file 
   (if not the default)
 * IO_TIME_SERIAL - serial port delay parameter 
   (if using 'serial' transport)
 * IPADDR - network address of the board
 * LOGIN - specifies the user account to use for Fuego operations
 * PASSWORD - specifies the password for the user account on the board 
   used by Fuego
 * PLATFORM - specifies the toolchain to use for the platform
 * SATA_DEV - specifies a filesystem device node (on the board) for 
   SATA filesystem tests
 * SATA_MP - specifies a filesystem mount point (on the board) 
   for SATA filesystem tests
 * SERIAL - serial device on host for board's serial console 
   (if using 'serial' transport)
 * SRV_IP - network address of server endpoint, for networking tests 
   (if not the same as the host)
 * SSH_KEY - the absolute path to key file  with ssh key for 
   password-less ssh operations (e.g. "/fuego-ro/board/myboard_id_rsa")
 * SSH_PORT - network port of ssh daemon on board (if using 
   ssh transport)
 * TRANSPORT - this specifies the transport to use with the target
 * USB_DEV - specifies a filesystem device node (on the board) for 
   USB filesystem tests
 * USB_MP - specifies a filesystem mount point (on the board) for 
   USB filesystem tests

See :ref:`Adding a board <adding_board>` for more details about these 
variables.

A board may also have additional variables, including variables that
are used for results evaluation for specific tests.

==================
Overlay system 
==================

The overlay system gathers variables from several places, and puts
them all together into a single file which is then source'ed into the
running test's environment.

It takes information from:

 * the board files (both static and dynamic)
 * the testplan
 * the test spec
 * the overlay files

and combines them all, using a set of priorities, into a single
file called "prolog.sh", which is then source'ed into the running
shell environment of the Fuego test being executed.

The overlay system is described in greater detail here:
:ref:`Overlay_Generation <overlay_generation>`

=======================
Stored variables 
=======================

Stored board variables are test variables that are defined on a
per-board basis, and can be modified and managed under program
control.

Stored variables allow the Fuego system, a test, or a user to store
information that can be used by tests.  This essentially creates an
information cache about the board, that can be both manually and
programmatically generated and managed.

The information that needs to be held for a particular board depends
on the tests that are installed in the system. Thus the system needs
to support ad-hoc collections of variables.  Just putting everything
into the static board file would not scale, as the number of tests
increases.

*Note: the LAVA test framework has a similar concept called*
*a board dictionary.*

One use case for this to have a "board setup" test, that scans for
lots of different items, and populates the stored variables with
values that are used by other tests.  Some items that are useful to
know about a board take time to discover (using e.g. 'find' on the
target board), and using a board dynamic variable can help reduce the
time required to check these items.

The board stored variables are kept in the file:
 * /fuego-rw/boards/$BOARD.vars

These variables are included in the test by the overlay generator.

Commands for interacting with stored variables 
====================================================

A user or a test can manipulate a board stored variable using the ftc
command.The following commands can be used to set, query and delete 
variables:

 *  **tc query-board** - to see test variables (both regular board 
    variables and stored variables)
 *  **ftc set-var** - to add or update a stored variable
 *  **ftc delete-var** - to delete a stored variable

ftc query-board
------------------

'ftc query-board' is used to view the variables associated with a
Fuego board.  You can use the command to see all the variables, or
just a single variable.

Note that 'ftc query-board' shows the variables for a test that come
from both the board file and board stored variables file (that is,
both 'static' board variables and stored variables).  It does not show
variables which come from testplans or spec files, as those are
specific to a test.

The usage is:
 * ftc query-board <board> [-n <VARIABLE>]

Examples:
 $ ftc query-board myboard
 $ ftc query-board myboard -n PROGRAM_BC

The first example would show all board variables, including functions.
The second example would show only the variable PROGRAM_BC, if it
existed, for board 'myboard'.

ftc set-var
------------

'ftc set-var' allows setting or updating the value of a board stored
variable.

The usage is:
 * ftc set-var <board> <VARIABLE>=<value>

By convention, variable names are all uppercase, and function names
are lowercase, with words separated by underscores.

Example:
 $ ftc set-var PROGRAM_BC=/usr/bin/bc

ftc delete-var
----------------

'ftc delete-var' removes a variable from the stored variables file.

Example:
 $ ftc delete-var PROGRAM_BC

Example usage
==============

Functional.fuego_board_check could detect the path for the 'foo'
binary, (e.g. is_on_target foo PROGRAM_FOO) and call 'ftc set-var
$NODE_NAME PROGRAM_FOO=$PROGRAM_FOO'.  This would stay persistently
defined as a test variable, so other tests could use $PROGRAM_FOO
(with assert_defines, or in 'report' or 'cmd' function calls.)


Example Stored variables
=========================

Here are some examples of variables that can be kept as stored
variables, rather than static variables from the board file:

 * SATA_DEV = Linux device node for SATA file system tests
 * SATA_MP = Linux mount point for SATA file system tests
 * LTP_OPEN_POSIX_SUBTEST_COUNT_POS = expected number of pass results 
   for LTP OpenPosix test
 * LTP_OPEN_POSIX_SUBTEST_COUNT_NEG = expected number of fail results 
   for LTP OpenPosix test
 * PROGRAM_BC = path to 'bc' program on the target board
 * MAX_REBOOT_RETRIES = number of retries to use when rebooting a 
   board

===================
Spec variables 
===================
A test spec can define one or more variables to be used with a test.  
These are commonly used to control test variations, and are specified 
in a spec.json file.

When a spec file defines a variable associated with a named test spec,
the variable is read by the overlay generator on test execution, and
the variable name is prefixed with the name of the test, and converted
to all upper case.

For example, support a test called "Functional.foo" had a test spec 
that defined the variable 'args' with a line
like the following in its spec.json file: ::

	 "default": {
	     "args": "-v -p2"
	 }


When the test was run with this spec (the "default" spec), then the
variable FUNCTIONAL_FOO_ARGS would be defined, with the value "-v
-p2".

See  :ref:`Test_Specs_and_Plans <test_specs_and_plans>` for more
information about specs and plans.

Note that spec variables are overridden by 

=========================
Dynamic variables
=========================

Another category of variables used during testing are dynamic
variables.  These variables are defined on the command line of 'ftc
run-test' using the '--dynamic-vars' option.

The purpose of these variables is to allow scripted variations when
running 'ftc run-test'  The scripted variables are processed and
presented the same way as Spec variables, which is to say that the
variable name is prefixed with the test name, and converted to all
upper case.

For example, if the following command was issued:

 * ftc run-test -b beaglebone -t Functional.foo --dynamic_vars *ARGS=-p*

then during test execution the variable *FUNCTIONAL_FOO_ARGS* would be
defined with the value *-p*.

See :ref:`Dynamic Variables <dynamic_variables>` for more information.

========================
Variable precedence 
========================

Here is the precedence of variable definition for Fuego, during test
execution:

(from lowest to highest)
 * environment variable (from Jenkins or shell where 'ftc run-test' is 
   invoked)
 * board variable (from fuego-ro/boards/$BOARD.board file)
 * stored variable (from fuego-rw/boards/$BOARD.vars file)
 * spec variable (from spec.json file)
 * dynamic variable (from ftc command line)
 * core variable (from Fuego scripts)
 * fuego_test variable (from fuego_test.sh)

Spec and dynamic variables are prefixed with the test name, and 
converted to upper case.  That tends to keep them in a separate name 
space from the rest of the test variables.







