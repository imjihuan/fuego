############
spec.json
############

================
Introduction
================

The file ``spec.json`` is defined for each test.  This file allows for
the same test to be used in multiple different ways.  This is often
referred to as a parameterized test.

The ``spec.json`` file indicates a list of "specs" for the test, and
for each test the values for test variables (parameters) that the test
will use to configure its behavior.

The variables declared in a spec are made available as shell variables
to the test at test runtime.  To avoid naming collisions, the test
variables are prefixed with the name of the test.  They are also
converted to all upper-case.

So, for example, for a test called Functional.mytest, if the spec
declared a variable called 'loops', with a value of "10", the
following test variable would be defined: FUNCTIONAL_MYTEST_LOOPS=10

The intent is allow for a test author or some other party to declare a
set of parameters to run the test in a different configuration.

Fuego is often used to wrap existing test programs and benchmarks,
which have command line options for controlling various test execution
parameters.  Setting these command line options is one of the primary
purposes of specs, and the spec.json file.

==========
Schema
==========

``spec.json`` holds a single object, with a 'testName' attribute, and an
attribute called 'specs' that is a collection of spec definitions.
Each spec definition has a name and a collection of named attributes.

 * **testName** - this indicates the test that these specs apply to
 * **specs** - this indicates the collection of specs
 * **fail_case** - this allows a test to provide a list failure expressions
   that will be be checked for in the test or system logs

    * **fail_regexp** - a regular expression that indicates a failure.
      This is grep'ed for in the testlog (unless use_syslog is set)
    * **fail_message** - a message to output when the regular expression is
      found

    * **use_syslog** - a flag indicating to scan for the fail_regexp in the
      system log rather than the test log

Within each spec, there should be a collection of name/value pairs.
Note that the values in a name/value pair are expanded in test context,
so that the value may reference other test variables (such as from
the board file, or the stored variables file for a board).

Special variables
=======================

There are some special variables that can be defined, that are recognized
by the Fuego core system.

One of these is:

 * **PER_JOB_BUILD** - if this variable is defined, then Fuego will create
   a separate build area for each job that this test is included in, even if
   a board or another job uses the same toolchain.  This is used when the test
   variables are used in the ''build'' phase, and can affect the binary that is
   compiled during this phase.

============
Examples
============

Here is an example, from the test ``Functional.bc``:

::

  {
      "testName": "Functional.bc",
      "fail_case": [
          {
              "fail_regexp": "syntax error",
              "fail_message": "Text expression has a syntax error"
          },
          {
              "fail_regexp": "Bug",
              "fail_message": "Bug or Oops detected in system log",
              "use_syslog": "1"
          }
      ],
      "specs": {
         "default": {
              "EXPR":"3+3",
              "RESULT":"6"
          },
          "bc-mult": {
              "EXPR":"2*2",
              "RESULT": "4"
          },
          "bc-add": {
              "EXPR":"3+3",
              "RESULT":"6"
          },
           "bc-by2": {
              "PER_JOB_BUILD": "true",
              "tarball": "by2.tar.gz",
              "EXPR":"3+3",
              "RESULT":"12"
          },
          "bc-fail": {
              "EXPR":"3 3",
              "RESULT":"6"
          },
      }
  }

In this example, the EXPR variable is used as input to the program
'bc' and the RESULT gives the expected output from bc.

This particular ``spec.json`` file is this complex for instructional
purposes, and this particular test is somewhat overly parameterized.


Here is an example, from the test ``Functional.synctest``:

::

  {
      "testName": "Functional.synctest",
      "specs": {
          "sata": {
              "MOUNT_BLOCKDEV":"$SATA_DEV",
              "MOUNT_POINT":"$SATA_MP",
              "LEN":"10",
              "LOOP":"10"
          },
          "mmc": {
              "MOUNT_BLOCKDEV":"$MMC_DEV",
              "MOUNT_POINT":"$MMC_MP",
              "LEN":"10",
              "LOOP":"10"
          },
          "usb": {
              "MOUNT_BLOCKDEV":"$USB_DEV",
              "MOUNT_POINT":"$USB_MP",
              "LEN":"10",
              "LOOP":"10"
          },
          "default": {
              "MOUNT_BLOCKDEV":"ROOT",
              "MOUNT_POINT":"$BOARD_TESTDIR/work",
              "LEN":"30",
              "LOOP":"10"
          }
      }
  }


Note the use of variables references for ``MOUNT_BLOCKDEV`` and
``MOUNT_POINT``.  These use values ($SATA_DEV, $MMC_DEV or $USB_DEV) that
should be defined in a board file for filesystem-related tests.

When a test defines variables, they should be documented in the test's
``test.yaml`` file.

============
Defaults
============

If a test has no ``spec.json``, then default set of values is used, which
is a single spec with the name "default", and no values defined.

============
See also
============

 * See :ref:`Test Spec and Plans` for more information about
   Fuego's test spec and testplan system.

