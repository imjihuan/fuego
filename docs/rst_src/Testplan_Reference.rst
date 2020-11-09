####################
Testplan  Reference
####################

In Fuego, a testplan is used to specify a set of tests to execute, and
the settings to use for each one.

========================
Filename and location
========================

A testplan is in json format, and can be located in two places:

 * As a file located in the directory ``fuego-core/engine/overlay/testplans``.
 * As a here document embedded in a batch test script
   (``fuego_test.sh``)

A testplan file name should start with the prefix "testplan_", and end
with the  extension ".json".

A testplan here document should be preceded by a line starting with
BATCH_TESTPLAN= and followed by a line starting with "END_TESTPLAN".

========================
Top level attributes
========================

The top level objects that may be defined in a testplan are:

 * testPlanName
 * tests
 * default_timeout
 * default_spec
 * default_reboot
 * default_rebuild
 * default_precleanup
 * default_postcleanup


Each of these attributes, except for 'tests' has a value that is a string.
Here are their meaninings and legal values:

The testPlanName is the name of this testplan.  It must match the
filename that holds this testplan (without the "testplan_" prefix or
".json" extension.  This object is required.

'tests' is a list of tests that are part of this testplan.  See below
for a detailed description of the format of an element in the 'tests'
list.  This object is required.

Default test settings
==========================

The testplan may also include a set of default values for test settings.
The test settings for which defaults may be specified are:

 * timeout
 * spec
 * reboot
 * rebuild
 * precleanup
 * postcleanup

These values are used if the related setting is not specified in the
individual test definition.

For example, the testplan might define a default_timeout of "15m"
(meaning 15 minutes).  The plan could indicate timeouts different from
this (say 5 minutes or 30 minutes) for individual tests, but if a test
in the testplan doesn't indicate its own timout it would default to
the one specified as the default at the top level of the testplan.

The ability to specify per-plan and per-test settings makes it easier
to manage these settings to fit the needs of your Fuego board or lab.

Note that if neither the individual test nor the testplan provide
a default value is not provided, then a Fuego global default value
for that setting will be used.

Note that the default_spec specifies the name of the test spec to use
for the test (if one is not is specified for the individual test
definition).  The name should match a spec that is defined for every
test listed in the plan.  Usually this will be something like
"default", but it could be something that is common for a set of
tests, like 'mmc' or 'usb' for filesystem tests.

See the individual test definitions for descriptions of these
different test settings objects.

===============================
Individual test definitions
===============================

The 'tests' object is a list of objects, each of which indicates a
test that is part of the plan.  The objects included in each list
element are:

 * testName
 * spec
 * timeout
 * reboot
 * rebuild
 * precleanup
 * postcleanup

All object values are strings.

TestName
==============

The 'testName' object has the name of a Fuego test included in this
plan.  It should be the fully-qualified name of the test (that is, it
should include the "Benchmark." or "Functional." prefix.)  This
attribute of the test element is required.

Spec
==========

The 'spec' object has the name of the spec to use for this test. It
should match the name of a valid test spec for this test.  If 'spec'
is not specified, then the value of "default_spec" for this testplan
will be used.

Timeout
=========

The timeout object has a string indicating the timeout to use for a
test.  The string is positive integer followed by a single-character
units-suffix.  The units suffixes available are:

 * 's' for seconds
 * 'm' for minutes
 * 'h' for hours
 * 'd' for days

Most commonly, a number of minutes is specified, like so:

 * "default_timeout" : "15m",

If no 'timeout' is specified, then the value of 'default_timeout' for
this testplan is used.

Reboot
============

The 'reboot' object has a string indicating whether to reboot the
board prior to the test.  It should have a string value of 'true' or
'false'.

Rebuild
===============

The 'rebuild' object has a string indicating whether to rebuild the
test software, prior to executing the test.  The object value must be
a string of either 'true' or 'false'.

If the value is 'false', then Fuego will do the following, when
executing the test:

 * If the test program is not built, then build it
 * If the test program is already built, then use the existing test program

If the value is 'true', then Fuego will do the following:

 * Remove any existing program build directory and assets
 * Build the program (including fetching the source, unpacking it,
   and executing the instructions in the test's "test_build" function)

Precleanup
===============

The 'precleanup' flag indicates whether to remove all previous test
materials on the target board, prior to deploying and executing the test.
The object value must be a string of either 'true' or 'false'.

Postcleanup
=================

The 'postcleanup' flag indicates whether to remove all test materials
on the target board, after the test is executed.
The flag value must be a string of either 'true' or 'false.

============================
Test setting precedence
============================

Note that the test settings are used by the plan at job creation time,
to set the command line arguments that will be passed to 'ftc run-test'
by the Jenkins job, when it is eventually run.

A user can always edit a Jenkins job (for a Fuego test), to
override the test settings for that job.

The precedence of the settings encoded into the job definition at job
creation time are:

 - Testplan individual test setting (highest priority)
 - Testplan default setting
 - Fuego default setting

The precedence of settings at job execution time are:

 - 'ftc run-test' command line option setting (highest priority)
 - Fuego default setting
