.. _using_batch_tests:

##########################
Using Batch Tests
##########################


A "batch test" in Fuego is a Fuego test that runs a series of other
tests as a group.  The results of the individual tests are
consolidated into a list of testcase results for the batch test.

Prior to Fuego version 1.5, there was a different feature, called
"testplans", which allowed users to compose sets of tests into logical
groups, and run them together.  The batch test system, introduced in
Fuego version 1.5 replaces the testplan system.

=============================
How to make a batch test
=============================

A batch test consists of a Fuego test that runs other tests.  A Fuego
batch test is similar to other Fuego tests, in that the test definition
lives in ``fuego-core/tests/<test-name>``, and it consists of a
``fuego_test.sh`` file, a spec file, a ``parser.py``, a ``test.yaml``
file and possibly other files.

The difference is that a Fuego batch test runs other Fuego tests, as a
group.  The batch test has a few elements that are different from
other tests.

Inside the ``fuego_test.sh`` file, a batch test must define two main
elements:

 1. The testplan element
 2. The ``test_run`` function, with commands to run other tests

Testplan element
=========================

The testplan element consists of data assigned to the shell variable
``BATCH_TESTPLAN``. This variable contains lines that specify, in
machine-readable form, the tests that are part of the batch job.  The
testplan is specified in json format, and is used to specify the
attributes (such as timeout, flags, and specs) for each test.  The
testplan element is used by ``ftc add-jobs`` to create Jenkins jobs for
each sub-test that is executed by this batch test.

The ``BATCH_TESTPLAN`` variable must be defined in the ``fuego_test.sh`` file.
The definition must begin with a line starting with the string
'BATCH_TESTPLAN=' and end with a line starting with the string
'END_TESTPLAN'.  By convention this is defined as a shell "here
document", like this example: ::


	BATCH_TESTPLAN=$(cat <<END_TESTPLAN
	{
		  "testPlanName": "foo_plan",
		  "tests": [
		      { "testName": "Functional.foo" },
		      { "testName": "Functional.bar" }
		  }
	}
	END_TESTPLAN
	)


The lines of the testplan follow the format described at
:ref:`Testplan_Reference <testplan_reference>`.  Please see that page
for details about the plan fields and structure (the schema for the
testplan data).

test_run function
====================

The other element in a batch test's ``fuego_test.sh`` is a ``test_run``
function.  This function is used to actually execute the tests in the
batch.

There are two functions that are available to help with this:

 * :ref:`allocate_next_batch_id <func_allocate_next_batch_id>`
 * :ref:`run_test <func_run_test>`

The body of the test_run function for a batch test usually has a few
common elements:

 * setting of the ``FUEGO_BATCH_ID``
 * execution of the sub-tests, using a call to the function
   :ref:`run_test <func_run_test>` for each one

Here are the commands in the test_run function for the test
``Functional.batch_hello``: ::

	function test_run {
		  export TC_NUM=1
		  DEFAULT_TIMEOUT=3m
		  export FUEGO_BATCH_ID="hello-
                  $(allocate_next_batch_id)"

		  # don't stop on test errors
		  set +e
		  log_this "echo \"batch_id=$FUEGO_BATCH_ID\""
		  TC_NAME="default"
		  run_test Functional.hello_world
		  TC_NAME="fail"
		  run_test Functional.hello_world -s hello-fail
		  TC_NAME="random"
		  run_test Functional.hello_world -s hello-random
		  set -e
	}


Setting the batch_id
----------------------------

Fuego uses a ``batch id`` to indicate that a group of test runs are
related.  Since a single Fuego test can be run in many different ways
(e.g. from the command line or from Jenkins, triggered manually or
automatically, or as part of one batch test or another), it is helpful
for the run data for a test to be assigned a ``batch_id`` that can be
used to generate reports or visualize data for the group of tests that
are part of the batch.

A batch test should set the ``FUEGO_BATCH_ID`` for the run to a unique
string for that run of the batch test.  Each sub-test will store the
batch id in its ``run.json`` file, and this can be used to filter run data
in subsequent test operations.  The Fuego system can provide a unique
number, via the routine :ref:`allocate_next_batch_id
<func_allocate_next_batch_id>`.  By convention, the ``batch_id`` for a
test is created by combining a test-specific prefix string with the
number returned from ``allocate_next_batch_id``.

In the example above, the prefix used is 'hello-', and this would be
followed by a number returned by the function ``allocate_next_batch_id``.

Executing sub-tests
----------------------

The :ref:`run_test <func_run_test>` function is used to execute the
sub-tests that are part of the batch.  The other portions of the
example above show setting various shell variables that are used by
``run_test``, and turning off 'errexit' mode while the sub-tests are
running.

In the example above, ``TC_NUM``, ``TC_NAME``, and ``DEFAULT_TIMEOUT``
are used for various effects.  These variables are optional, and in most
cases a batch test can be written without having to set them.  Fuego
will generate automatic strings or values for these variables if they
are not defined by the batch test.

Please see the documentation for :ref:`run_test <func_run_test>` for
details about the environment and arguments used when calling the
function.

Avoiding stopping on errors
----------------------------------------

The example above shows use of ``set +e`` and ``set -e`` to control the
shell's 'errexit' mode.  By default, Fuego runs tests with the shell
errexit mode enabled.  However, a batch test should anticipate that
some of its sub-tests might fail.  If you want all of the tests in the
batch to run, even if some of them fail, they you should use ``set +e``
to disable errexit mode, and ``set -e`` to re-enable it when you are
done.

Of course, if you want the batch test to stop if one of the sub-tests
fails, they you should control the errexit mode accordingly (for
example, leaving it set during all sub-test executions, or disabling
it or enabling it only during the execution of particular sub-tests).

Whether to manipulate the shell errexit mode or not depends on what
the batch test is doing.  If it is implementing a sequence of
dependent test stages, the errexit mode should be left enabled.  If a
batch test is implementing a series of unrelated, independent tests,
the errexit mode should be disabled and re-enabled as shown.

================
Test output
================

The run_test function logs test results in a format similar to TAP13.
This consists of the test output, followed by a line starting with the
batch id (inside double brackets), then "ok" or "not ok" to indicate
the sub-test result, followed by the testcase number and testcase
name.

A standard ``parser.py`` for this syntax is available and used by other
batch tests in the system (See
``fuego-core/tests/Functional.batch_hello/parser.py``)

========================================
Preparing the system for a batch job
========================================

In order to run a batch test from Jenkins, you need to define a
Jenkins job for the batch test, and jobs for all of the sub-tests that
are called by the batch test.

You can use ``ftc add-jobs`` with the batch test, and Fuego will create
the job for the batch test itself as well as jobs for all of its
sub-tests.

It is possible to run a batch test from the command line using 'ftc
run-test', without creating Jenkins jobs.  However if you want to see
the results of the test in the Jenkins interface, then the Jenkins
test jobs need to be defined prior to running the batch test from the
command line.

===========================
Executing a batch test
===========================

A batch test is executed the same way as any other Fuego test.  Once
installed as a Jenkins job, you can execute it using the Jenkins
interface (manually), or use Jenkins features to cause it to trigger
automatically.  Or, you can run the test from the command line using
``ftc run-test``.

===============================
Viewing batch test results
===============================

You can view results from a batch test in two ways:

 1. Inside the Jenkins interface, or
 2. Using ``ftc`` to generate a report.

Jenkins batch test results tables
=====================================

Inside the Jenkins interface, a batch job will display the list of
sub-tests, and the PASS/FAIL status of each one.  In addition, if
there is a Jenkins job associated with a particular sub-test, there
will be a link in the table cell for that test run, that you can click
to see that individual test's result and data in the Jenkins
interface.


Generating a report
======================

You can view a report for a batch test, by specifying the batch_id
with the  ``ftc gen-report`` command.

To determine the batch_id, look at the log for the batch test
(testlog.txt file).  Or, generate a report listing the batch_ids for
the batch test, like so: ::

 $ ftc gen-report --where test=batch_<name> --fields timestamp,batch_id

Select an appropriate batch_id from the list that appears, and note it
for use in the next command.

Now, to see the results from the individual sub-tests in the batch, use
the desired batch_id as part of a ''where'' clause, like so: ::

 $ ftc gen-report --where batch_id=<batch_id>

You should see a report with all sub-test results for the batch.

=======================
Miscelaneous notes
=======================

Timeouts
==========

The timeout for a batch test should be long enough for all sub-tests
to complete.  When a batch test is launched from Jenkins, the board on
which it will run is reserved and will be unavailable for tests until
the entire batch is complete.  Keep this in mind when executing batch
tests that call sub-tests that have a long duration.

The timeout for individual sub-tests can be specified multiple ways.
First, the timeout listed in the testplan (embedded in ``fuego_test.sh``
as the ``BATCH_TESTPLAN`` variable) is the one assigned to the Jenkins
job for the sub-test, when jobs are created during test installation
into Jenkins.  These take effect when a sub-test is run independently
from the batch test.

If you want to specify a non-default timeout for a test, then you must
use a ``--timeout`` argument to the ``run_test`` function, for that
sub-test.
