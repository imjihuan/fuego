########################
Test Specs and Plans
########################

.. note::
   This page describes (among other things) the standalone test
   plan feature, which is in process of being converted to a new
   system.  The information is still accurate as of November 2020
   (and Fuego version 1.5).  However, standalone testplans are
   now deprecated.  The testplan system is being refactored and
   testplan json data is being integrated into a new batch test
   system introduced in Fuego version 1.5. See
   :ref:`Using_Batch_Tests` for more information.

================
Introduction
================

Fuego provides a mechanism to control test execution using something
called "test specs" and "test plans".  Together, these allow for
customizing the invocation and execution of tests in the system.  A
test spec lists variables, with their possible values for different
test scenarios, and the test plan lists a set of tests, and the set of
variable values (the spec) to use for each one.

There are numerous cases where you might want to run the same test
program, but in a different configuration (i.e. with different
settings), in order to measure or test some different aspect of the
system.  This is often referred to as test "parameterization".
One of the simplest different types of test settings you might
choose is whether to run a quick test or a thorough (long) test.
Selecting between quick and long is a high-level concept, and
corresponds to the concept of a test plan. The test plan selects
different arguments, for the tests that this makes sense for.

For example, the arguments to run a long filesystem stress test, are
different than the arguments to run a long network benchmark test.
For each of these individual tests, the arguments will be different
for different plans.

Another broad category of test difference is what kind of hardware
device or media you are running a filesystem test on.  For example,
you might want to run a filesystem test on a USB-based device, but the
results will likely not be comparable with the results for an
MMC-based device. This is due to differences in how the devices
operate at a hardware layer and how they are accessed by the system.
Therefore, depending on what you are trying to measure, you may wish
to measure only one or another type of hardware.

The different settings for these different plans (the test variables
or test parameters) are stored in the
test spec file.  Each test in the system has a test spec file, which
lists different specifications (or "specs") that can be incorporated
into a plan.  The specs list a set of variables for each spec.  When a
testplan references a particular spec, the variable values for that
spec are set by the Fuego overlay generator during the test execution.

In general, test plan files are global and have the names of
categories of tests.

.. note::
    Note that a spec mentioned in a test plan may not be
    available every test.  In fact the only spec that is
    guaranteed to be available in every test is the 'default'
    test spc.  It is important for the user to recognize which
    test specs and plan arguments may be suitably used with which
    tests.

===============
Test plans
===============

The Fuego  "test plan" feature is provided as an aid to organizing
testing activities.

There are only a few "real" testplans provided in Fuego (as of early
2019).  There is a "default" testplan, which includes a smattering of
different tests, and some test plans that allow for selecting between
different kinds of hardware devices that provide file systems.  Fuego
includes a number of different file system tests, and these plans
allow customizing each test to run with filesystems on either USB,
SATA, or MMC devices.

These test plans allow this selection:

 * testplan_usbstor
 * testplan_sata
 * testplan_mmc

These plans select test specs named: 'usb', 'sata', and 'mmc'
respectively.

Fuego also includes some test-specific test plans (for the
``Functional.bc`` and ``Functional.hello_world`` tests), but these are
there more as examples to show how the test plan and spec system works,
than for any real utility.

A test plan is specified by a file in JSON format, that indicates the
test plan name, and a list of tests. For each test, it also lists the
specs which should be used for that test, when run with this plan.  The
test plan file should have a descriptive name starting with 'testplan_'
and ending in the suffix '.json', and the file must be placed in the
``overlays/testplans`` directory.

Example hello world testplan
============================

The test program from the hello_world test allows for selecting
whether the test succeeds, always fails, or fails randomly.  It does
this using a command line argument.

The Fuego system includes test plans that select these different
behaviors.  These test plan files are named:

 * ``testplan_default.json``
 * ``testplan_hello_world_fail.json``
 * ``testplan_hello_world_random.json``

Here is ``testplan_hello_world_random.json``

::

  {
       "testPlanName": "testplan_hello_world_random",
       "tests": [
           {
               "testName": "Functional.hello_world",
               "spec": "hello-random"
           }
       ]
   }


Testplan Reference
========================

A testplan can include several different fields, at the "top" level of
the file, and associated with an individual test.  These are described
on the page:  :ref:`Testplan_Reference:Testplan Reference`

==============
Test Specs
==============

Fuego's "test spec" system is a mechanism for running Fuego tests
in a "parameterized" fashion.  That is, you can run the same underlying
test program, but with different values for variables that are passed
to the test (the test "parameters", in testing nomenclature).
Each 'spec' that is defined for a test may also be referred to
as a test 'variant' - that is, a variation on the basic operation
of the test.

Each test in Fuego should have a 'test spec' file, which lists
different specifications or variants for that test. For each 'spec'
(or variant), the configuration declares the variables that are
recognized by that test, and their values.  Every test is required to
define a "default" test spec, which is the default set of test
variables used when running the test.  Note that a test spec is
not required to define any test variables, and this is the case for
many 'default' test specs for tests which have no variants.

The set of variables, and what they contain is highly test-specific.
In some cases, a test variable is used to configure different command
line options for the test program.  In other cases, the variable
may be used by ``fuego_test.sh`` to change how test preparation
is done, or to select different hardware devices or file systems
for the test to operate on.

The test spec file is in JSON format, and has the name "spec.json".

The test spec file is placed in the test's home directory, which is
based on the test's name: ``/fuego-core/tests/$TESTNAME/spec.json``

Example
=============

The ``Functional.hello_world`` test has a test spec that provides
options for executing the test normally (the 'default' spec), for
always failing (the 'hello-fail' spec), or for succeeding or failing
randomly (the 'hello-random' spec)

This test spec file for the 'hello_world' test is
``fuego-core/tests/Functional.hello_world/spec.json``

Here is the complete spec for this test: ::

   {
       "testName": "Functional.hello_world",
       "specs": {
           "hello-fail": {
               "ARG":"-f"
           },
           "hello-random": {
               "ARG":"-r"
           },
           "default": {
               "ARG":""
           }
       }
   }


During test execution, the variable ``$FUNCTIONAL_HELLO_WORLD_ARG`` will be
set to one of the three values shown (nothing, '-f' or '-r'), depending
on which is spec used when the test is run.

In Fuego, the spec to use with a test can be specified multiple
different ways:

 * as part of the Jenkins job definiton
 * on the ``ftc run-test`` command line
 * as part of a testplan definition

======================================
Variable use during test execution
======================================

Variables from the test spec are expanded by the overlay generator
during test execution.  The variables declared in the test spec files
may reference other variables from the environment, such as from the
board file, relating to the toolchain, or from the fuego system
itself.

The name of the variable is appended to the end of the test name to
form the environment variable that is used by the test.  The environment
variable name is converted to all uppercase.  This environment
variable can be used in the ``fuego_test.sh`` as an argument to the
test program, or in any other way desired.

Example of variable use
=======================

In this hello-world example, the program invocation (by
``fuego_test.sh``) uses the variable ``$FUNCTIONAL_HELLO_WORLD_ARG``.
Below is an excerpt from
``/fuego-core/tests/Functional.hello_world/fuego_test.sh``.


::

   function test_run {
       report "cd $BOARD_TESTDIR/fuego.$TESTDIR; ./hello $FUNCTIONAL_HELLO_WORLD_ARG"
   }


Note that in the default spec for hello_world, the variable ('ARG' in
the test spec) is left empty.  This means that during execution of
this test with testplan_default, the program 'hello' is called with no
arguments, which will cause it to perform its default operation.  The
default operation for the 'hello' program is to write "Hello World" and
a test result of "SUCCESS", and then exit successfully.

===============================
Specifying failure cases
===============================

A test spec file can also specify one or more failure cases.  These
represent string patterns that Fuego scans for in the test log, to
detect error conditions indicating that the test failed.  The syntax
for this is described next.

Example of fail case
==========================

The following example of a test spec (from the Functional.bc test),
shows how to declare an array of failure tests for this test.

There should be an variable named "fail_case" declared in test test
spec JSON file, and it should consist of an array of objects, each one
specifying a 'fail_regexp' and a 'fail_message', with an optional
variable (use_syslog) indicating to search for the item in the system
log instead of the test log.

The regular expression is used with grep to scan lines in the test
log.  If a match is found, then the associated message is printed, and
the test is aborted.

::

   {
       "testName": "Functional.bc",
       "fail_case": [
           {
               "fail_regexp": "some test regexp",
               "fail_message": "some test message"
           },
           {
               "fail_regexp": "Bug",
               "fail_message": "Bug or Oops detected in system log",
               "use_syslog": 1
           }
           ],
       "specs":
       [
           {
               "name":"default",
               "EXPR":"3+3",
               "RESULT":"6"
           }
       ]
   }


These variables are turned into environment variables by the overlay
generator and are used with the function
:ref:`fail_check_cases <function_fail_check_cases>`  which is called during
the 'post test' phase of the test.

Note that the above items would be turned into the following
environment variables internally in the fuego system:

 * FUNCTIONAL_BC_FAIL_CASE_COUNT=2
 * FUNCTIONAL_BC_FAIL_PATTERN_0="some test regexp"
 * FUNCTIONAL_BC_FAIL_MESSAGE_0="some test message"
 * FUNCTIONAL_BC_FAIL_PATTERN_1="Bug"
 * FUNCTIONAL_BC_FAIL_MESSAGE_1="Bug or Oops detected in system log"
 * FUNCTIONAL_BC_FAIL_1_SYSLOG=true

=============================
Catalog of current plans
=============================

Fuego, as of January 2017, only has a few testplans defined.

Here is the full list:

 * testplan_default
 * testplan_mmc
 * testplan_sata
 * testplan_usbstor
 * testplan_bc_add
 * testplan_bc_mult
 * testplan_hello_world_fail
 * testplan_hello_world_random

The storage-related testplans (mmc, sata, and usbstor) allow the test
spec to configure the appropriate following variables:

 * MOUNT_BLOCKDEV
 * MOUNT_POINT
 * TIMELIMIT
 * NPROCS

Both the 'bc' and 'hello_world' testplans are example testplans to
demonstrate how the testplan system works.

The 'bc' testplans are for selecting different operations to test in
'bc'.  The 'hello_world' testplans are for selecting different results
to test in 'hello_world'
