####################
Overlay Generation
####################

Overlay generation refers to the process of converting overlay files
into a test variable script.  This allows for board files and base
test scripts to override functions and variables in the base fuego
system with customized versions.  This implements a weak form of
object-orientated programming.

At run time, the base test script is sourced.  This in turn sources
the fuego test system.  During that 'source' operation, environment
variables (NODE_NAME and DISTRIB) are used to select the .board and
.dist files for the target.  These files, in turn, can inherit and
include definitions of variables and functions from other files
(called "overlay" or "class" files).

The program ``ovgen.py`` is called to read the .board and .dist files, and
to combine the information in these with the overlay files, and
finally to also add information from the testplans and test spec
files, to create a single unified ``prolog`` script.  This script is
called the ``test variables file`` and is sourced into the running
script, to provide final definitions for functions and variables used
during test execution.

The call to ``ovgen.py`` looks like this: ::

 $OF_OVGEN $OF_CLASSDIR_ARGS $OF_OVFILES_ARGS $OF_TESTPLAN_ARGS $OF_SPECDIR_ARGS $OF_OUTPUT_FILE_ARGS

Which expands to something like: ::

 /fuego-core/scripts/ovgen/ovgen.py \
   --classdir /fuego-core/engine/overlays//base \
   --ovfiles /fuego-core/engine/overlays//distribs/nologger.dist \
             /fuego-core/engine/overlays//boards/qemu-arm.board \
   --testplan /fuego-core/engine/overlays//testplans/testplan_default.json \
   --output /fuego-rw/work/qemu-test-arm_prolog.sh


This says to take the 2 ovfiles mentioned: ``nologger.dist`` and
``qemu-arm.board``, and process them using the indicated classdir,
testplan and specdir, to product the output ``qemu-test-arm_prolog.sh``.

The result will be a single file containing all the functions and
variables defined in the combined files, taking into account any
overrides encountered.

The classdir defines where base ``fuegoclass`` files are located, which
can be included or inherited into the environment space.

The testplan and specdir are used to augment the environment space
with variables for the indicated testplan.

========================================
Inheritance, inclusion and overrides
========================================

The system implements a weak form of object-oriented behavior
(specifically function and variable polymorphism), by allowing
functions and variables from the base Fuego system to be overridden
during execution of the program.

A ``class`` file has the same syntax as a shell script, but the
extension ``.fuegoclass``.  To include the material from a class file
into another file, you use either the 'inherit' keyword or the
'include' keyword.

If you 'inherit' a class file, then the variables and functions in the
file may be overridden by local definitions in your shell script.

The functions which are intended to be overridable start with the
prefix ov_ (usually), and reside in the 'class' files in the classdir.
Variables can also be overridden.  These have no special identifying
prefix.

If you 'include' a class file, then the variables and functions in
that file may NOT be overridden by local definitions in your shell
script.

It is presumed that these overrides will be specified in the .board
and .dist files.

nologread.dist
=====================

One example of an override is provided in the system already, in the
form of nologread.dist.  Every target node defined in the system (in
the Jenkins interface) defines both a board file and a dist file.
These are intended to define parameters and functions for accessing
the board, and for executing certain functions based on the type of
distribution on the board (e.g. poky vs debian).

The ``base.dist`` file is the default .dist file used by targets, and it
does not override any functions or variables provided by the fuego
system.  It merely inherits all pre-defined functions from
``base-distrib.fuegoclass``.

However, the ``nologger.dist`` file is intended for use when there is no
command 'logread' provided on the target.  It uses 'cat' instead to
retrieve the log information during the test.  It inherits the
pre-defined functions from ``base-distrib.fuegoclass``, but then overrides
the function ov_rootfs_logread.

Here is a list of overridable functions:

From ``base-board.fuegoclass``:

 * ov_transport_get
 * ov_transport_put
 * ov_transport_cmd

From ``base-distrib.fuegoclass``:

 * ov_get_firmware
 * ov_rootfs_reboot
 * ov_rootfs_state
 * ov_logger
 * ov_rootfs_sync
 * ov_rootfs_drop_caches
 * ov_rootfs_oom
 * ov_rootfs_kill
 * ov_rootfs_logread

From ``base-funcs.fuegoclass``:

 * default_target_route_setup

The following variables can be overriden:

From ``base-params.fuegoclass``:

 * DEVICE
 * PATH
 * SSH
 * SCP

=======================================
How to use the override/class system
=======================================

Board and distribution files are referenced in the Jenkins definition
for a test node (target).  These files are interpreted by Fuego as
overlay files, which can use values and functions from other files
(fuegoclass files), and override them if necessary for a particular
board.

Inheriting and including other variables
==============================================

An overlay file (board or distribution file) defined variables and
functions from other base class files in the system using the
'inherit' and 'include' directives.

The inherit directive is used to read items from a fuegoclass file
that can be overridden.

Items that are read from a fuegoclass file using the 'include'
directive cannot be overridden in the overlay file.

For example, a board file usually uses the following directives:

 * Inherit "base-board"
 * Include "base-params"

This means that the functions and variables declared in the
``base-board.fuegoclass`` file can be overridden in the board file.
However, the functions and variables declared in the
``base-params.fuegoclass`` file can not be overridden in the board file.

Syntax for overriding variables and functions
===================================================

To override a variable that is defined in another file, you re-declare
the variable in the board or distrib file using the normal syntax
(NAME="value"), but put an "override" prefix on the line, like so:

::

 override NAME="value"


To override a function, use the syntax as follows: ::


  override-func func_name() {
      function commands...
  }


The syntax must be precise, including the number of spaces in the
first line and the brace placement (on same line as function name for
the opening brace, and at the first of the line for the closing brace)


==========================
System Developer Notes
==========================

Outline of ovgen operation
===========================

Here is an outline of ovgen operation:

 * run

   * Parse command line arguments
   * Parse test specs, if specdir is specified on command line
   * Parse test plans, if testplan is specified on command line
   * Parse all the base fuegoclass files (from classdir directory)
   * Parse classes out of the override file

     * This processes inherited values and overrides during the parse

   * Generate the prolog (test variable script) from the data read

.. note::
   testplans and testspecs are simple maps internally (in ovgen.py).
   However, parseBaseDir() and parseOverrideFile() return class objects
   that are put into a list.

For additional developer notes on the overlay system, see
:ref:`ovgen feature notes`
