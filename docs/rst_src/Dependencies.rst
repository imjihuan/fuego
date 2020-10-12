

####################
Dependencies
####################

===============
Introduction
===============

Fuego includes a test dependency system that allows Fuego to determine
whether a test can be run on a board or not.  The test dependency
system provides an opportunity for Fuego to do an early abort of a
test in case required conditions are not met for the test.

The dependency system allows short-circuiting of test execution.  That
is, these dependencies are checked during a pre_test phase, and if the
dependencies are not met, Fuego aborts the test, before the test is
built, deployed and executed on the target.

The dependency system consists of 2 parts:

 1) A set of test variables in the base script that specify needed attributes
    of the device under test. These dependencies are expressed as statically
    declared "NEED\_" variables in ``fuego_test.sh``

 2) The ability to define a test function, :ref:`test_pre_check
    <function_test_pre_check>`, that is called before the test executes,
    which can test for arbitrary conditions

In the future, it intended that this feature will allow for
automatically detecting what tests are applicable to particular
boards.

==================
NEED variables
==================

A test can declare variables (called 'NEED' variables) that describe
attributes of the device under test, in the fuego_test.sh script.

The following NEED variables are currently supported:

 * NEED_MEMORY
 * NEED_FREE_STORAGE
 * NEED_ROOT
 * NEED_KCONFIG
 * NEED_MODULE

These variables are usually declared after the source reference
definition, and before the first function declaration in ``fuego_test.sh``

Declaration example
=======================

Here is an example, from Benchmark.signaltest:

This shows the first few lines of ``fuego_test.sh`` for this test ::

  tarball=signaltest.tar.gz

  NEED_ROOT=1

  function test_build {
    make CC="$CC" LD="$LD" LDFLAGS="$LDFLAGS" CFLAGS="$CFLAGS"
  }
  ...


NEED_MEMORY
============

The ``NEED_MEMORY`` variable is used to require that the board have a
certain amount of free memory, for the test to run.  The value is
expressed in either bytes, kilobytes, megabytes, gigabytes or
terabytes.

The value is declared as an integer number (base 10) followed by an
optional prefix - one of 'K', 'M', 'G', 'T'.

Here are some examples:

 * NEED_MEMORY=500K
 * NEED_MEMORY=2G
 * NEED_MEMORY=1500000

As a technical detail, the value specified is compared with the value
of MemFree in ``/proc/meminfo`` of target board.

NEED_FREE_STORAGE
======================

The ``NEED_FREE_STORAGE`` variable is used to require that the board have
a certain amount of free storage, in the filesystem where the test
needs it, in for the test to run.  The value is expressed in either
bytes, kilobytes, megabytes, gigabytes or terabytes.  The value of
``NEED_FREE_STORAGE`` is usually provided with 2 strings - a string
indicating the required size, and a directory to check.

Most tests are executed in the directory specified by $BOARD_TESTDIR,
so that is often the second string provided.  However, if a test needs
space somewhere else in the filesystem (besides where the test
normally runs), this can be specified directly (statically), or via
some other test variable.  If no second string is provided, the
specified value of free storage required is compared with the amount
of available storage in the root filesystem.

The value required is declared as an integer number (base 10) followed
by an optional prefix - one of 'K', 'M', 'G', 'T'.

Here are some examples:

 * NEED_FREE_STORAGE=2G
 * NEED_FREE_STORAGE="50M $BOARD_TESTDIR"
 * NEED_FREE_STORAGE="5T /media/raid-array"

As a technical detail, the value specified is compared with the value
of the 'Available' column returned by ``df`` for the indicated
directory.

NEED_ROOT
==========

This variable is declared if a test required to be executed with
'root' privileges.  In that case, the following should be added to the
test script:

 * NEED_ROOT=1

NEED_KCONFIG
=============

This variable is used to check that one or more kernel configuration
options have specified values.

The ``NEED_KCONFIG`` line can list more than one kernel config option.
Each option is of the form: CONFIG_OPTION={value}.  Currently, the
value must be one of: 'y' or 'n'.

Here are some examples:

 * NEED_KCONFIG="CONFIG_PRINTK=y"
 * NEED_KCONFIG="CONFIG_LOCKDEP_SUPPORT=n"
 * NEED_KCONFIG="CONFIG_USB=y CONFIG_USB_EHCI_MV_U20=y"

Technical detail:  The kernel configuration is searched for in the
following locations, on the target, in order:

 * /proc/config.gz
 * /boot/config-$(uname -r) and on the host at:
 * $KERNEL_SRC/.config

If ``NEED_KCONFIG`` is defined, but if the kernel configuration of the
target board can not be found, then the dependency check fails.

.. note::
   it is intended that the kernel build system will set the board
   variable KERNEL_SRC, for use by the Fuego system (but this is not
   implemented yet).

NEED_MODULE
===============

This variable indicates that a test needs a particular module loaded
on the system, in order to run.

Here is an example:

 * NEED_MODULE=bitrev

.. note::
   it's unclear that this is a good way to detect a kernel feature
   needed for a test.  Any module that is upstream can also be included in
   the kernel statically.  Testing for a driver or feature as a module would
   miss that configuration.

==================
test_pre_check
==================

A test base script (fuego_test.sh) can provide a function called
:ref:`test_pre_check <function_test_pre_check>`  where arbitrary commands
can be run, to determine if the device under test (the board) has the
required features or hardware for the test.

This function, if present, is run during the pre_test phase of text
execution.  Thus, if prerequisite conditions are not met, the test can
abort early and avoid the additional test phases (build, deploy, run,
etc.)

The following functions are commonly used in the test_pre_check routine:

 * :ref:`assert_define <function_assert_define>`
 * :ref:`is_on_target <function_is_on_target>`
 * :ref:`is_on_target_path <function_is_on_target_path>`
 * :ref:`assert_has_program <function_assert_has_program>`
 * :ref:`is_on_sdk <function_is_on_sdk>`
 * :ref:`abort_job <function_abort_job>`

For examples of how to use these functions, see the individual
documentation pages for the functions (linked above).

Addtionally, the ``test_pre_check`` function can execute any additional
code it wants (using the ``cmd`` function), in order to query the target
during this phase, for required capabilities. Or, it might check
conditions on the host, network, or extended test environment, to
verify that conditions are ready for the test.

This might include checking for things like:

 * mounted file systems
 * network connections
 * required hardware
 * auxiliary test harness availability and preparation

======================
Envisioned features
======================

In the future, the test dependency system may be used to allow a Fuego
user to select tests which are appropriate for the hardware or
distribution that they have.

Fuego does not currently have thousands of tests.  But in a future
where there ARE thousands of tests, it will be overwhelming to the
test user to select those tests which are of interest for their
hardware.  The test dependency system will allow Fuego to
automatically compare the features or hardware required for a test,
with the features and hardware of a board, and decide if a test is
compatible or relevant for that board.

When Fuego has a test "server", this can be used as a matching service
to select tests for execution on boards that have specific features or
hardware.  When Fuego has a test "store", then the dependency system
can be use to filter the tests to only those that are relevant to
their testing needs.

The NEED variables are declarative, rather than imperative (like the
test_pre_check function), so that it will be possible to develop an
automated system to do this matching (between test and board).

