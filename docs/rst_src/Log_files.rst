.. _logfiles:

##################
Log files
##################

During test execution, Fuego collects several different logs.

These represent different aspects of the test system and the
status of the board under test, and are used for
different purposes.

Here are the main logs collected or generated during a test:

 * **console log**
 * **test log**
 * **run.json**

In addition to the main test logs and results files, there are other files
(test artifacts) with information collected during the test.  These
are used to debug test execution, board farm status, board status, and
results processing.

 * **board snapshot**
 * **syslogs**
 * **devlog**
 * **prolog.sh**
 * **'result' directory**

These are located in the 'log' directory (also know as the 'run'
directory), at:
``/fuego-rw/logs/<test_name>/<board>.<spec>.<build_id>.<build_number>``

=================
Main results logs
=================

These logs are the results of test execution, and have output from
different parts of the system.

Console log
==================
The console log is collected by Fuego during the entire execution of
the test.  This includes output from commands executed during
every phase of test execution.

The console log is called: ``consolelog.txt``

The main purpose of this log is to show command output during
every phase of the test (not just the 'run' phase), in order
to debug test execution, and show test progress.

The console log is the same thing that shows up in the Jenkins
interface during test execution.  It is also available after
the test finishes, by clicking on the 'Console Output' link
on an individual Jenkins build page.

Debug data
----------
When debug options are turned on, then each line of the Fuego core
and the test's fuego_test.sh shell script is output and put into the
console log as it is executed.

During test execution, several levels of shell script are run
(that is, "source" statements are executed).
The number of '+' signs preceding a line in the console log indicates the
depth (or invocation nesting level) for that line, in the shell
execution.

There are "phase" messages added to the log during the test, which
help identify which part of the test a particular sequence is in.
This can help you debug what part of a test (pre_test, build, deploy,
run, post_test, etc.) is failing, if any.

You can control which phases emit debugging messages, by setting
the FUEGO_LOG_LEVELS variable for a test.

This can be done in the Jenkins job config for a job, or by
setting the environment variable to an appropriate string
before running ``ftc run-test``.

Test log
============
This is the output produced by the test program itself.
During execution of a Fuego test, many operations are performed,
usually including the execution of a program on the board under
test.  That program's output is collected and saved.
Data for this log is usually only collected during the 'run'
phase of a test.

Certain Fuego functions, that are used to execute the key
commands for a test, save their results to the test log.
These include the  *report*, *report_append*, *report_live*, and *log_this*
functions.

In the case of the *report*, and *report_append* functions,
the output from the commands called by these functions
is saved into a log file which is retrieved from the target
at the end of the test.

The name of the test log for a test is: ``testlog.txt``

The purpose of this log is to preserve the actual output of
the test program itself.

run.json
===========
``run.json`` is a file that has information
about the test run, as well as detailed information about test results.
The test meta-data and results are expressed in a unified, canonical format, such that results
can be queried and compared across test runs (and potentially different
test systems).  No matter what format output a test program returns,
Fuego converts this into a machine-readable list of testcase results
and (for benchmarks) test measurement results.

See :ref:`run.json <run_json>` for details of the contents of this file.

====================
Other test artifacts
====================
Other files are produced during a test and stored in the log directory.
Here are descriptions of each of these test artifacts and purpose
and expected usage of them.


Board snapshot
================
The board snapshot file, called 'machine-snapshot.txt',
contains information about the
process environment and board status at the start of the test.
By default it includes the following information:

 * shell environment variables for processes executed by the test
 * kernel version information (called the 'firmware revision')
 * process load
 * memory status
 * mounted filesystems
 * running process list
 * the status of interrupts

The main purpose of this is to allow the user to see if there were
any unusual conditions on the machine, at the time of the test.
This is intended to allow diagnosing test failures cause by machine
state.

Syslogs
===========
The syslogs record messages from the board's system log.  There
are two of these recorded, one before the start of test
execution (called the "before" log), and one after test execution
(called the "after" log).

These logs includes messages from the kernel (if a logger is transferring
the messages from the kernel to the system log), as well as messages
from programs running on the system, that output to their status to
the system log.

The names of the syslogs for a test are:

 * ``syslog.before.txt``
 * ``syslog.after.txt``

The purposes of these logs is to capure the condition of the machine
before the test started, and also to allow determining any error conditions
that were logged on the system while the test was running.

In particular, the difference between the 'after' syslog and the
'before' syslog is examined by Fuego, to check for any kernel
oopses (kernel failures reported to the log).  If the kernel
has an "oops" during a test, then the test is reported as having failed,
regardless of other conditions (test program return code or
criteria processing of testcase results).


Devlog
===========
This is a summarized list of board management and control operations performed
during the execution of a test.

The name of the devlog for a test run is ``devlog.txt``

The main purpose of this log is for debugging the internal Fuego command
sequences, and for determining the health of the board within a board
farm.  Most Fuego end users can ignore this log.


prolog.sh
============
The prolog.sh is a shell script that is generated during test execution.
It contains the Fuego-generated test variables for the test, as well
as the overlay functions that were used for this test run.

It is used during test execution, but is left in the log directory
to allow for debuggin test execution.  Most Fuego users should not
need to examine this file.  It is useful mainly for developers
of the Fuego test system itself, and developers of Fuego tests.


'Result' directory
==================
Some tests produce a directory in the log area called 'result'.
This is automatically produced by some parsers, when they process
the testlog.txt file.  Sections of test testlog.txt that contain
diagnostics information for individual testcases are stored
as individual files, so that they can be displayed as separate
pages in the Jenkins user interface.  For some tests, these
individual files are also processed into test-specific reports
(specifically, LTP has additional spreadsheet-creation facilities
that use the individual files in the 'results' directory.

These directories can safely be ignored by the user in most
cases.

============
Summary
============

In the Fuego version 1.5 (released in 2019), the log directories are as
follows:

 * Fuego logs:

   * ``/fuego-rw/logs/<testname>/<board>.<spec>.<build_id>.<build_number>``

     * consolelog.txt - collection of all output from all commands during a test
     * testlog.txt - the output of the actual test program
     * run.json - test meta-data and results in canonical format
     * machine-snapshot.txt - status of board before test
     * syslog.before.txt - system log of board under test, saved before test execution
     * syslog.after.txt - system log of board under test, saved after test execution
     * devlog.txt - list of board command and control operations

 * jenkins files:

   * ``/var/lib/jenkins/jobs/<jobname>/builds/buildnum/``

     * build.xml - Jenkins meta-data about the build
     * log - same as the console log above

 * per-test data files:

   * ``/fuego-rw/logs/<testname>``

     * flat_plot_data.txt - has results data in "flat" ASCII text format
     * flot_chart_data.json - has chart data in json and HTML format
