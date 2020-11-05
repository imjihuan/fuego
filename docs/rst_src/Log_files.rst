##################
Log files
##################


During test execution, Fuego collects several different logs.

These represent different aspects of the system, and are used for
different purposes.

FIXTHIS - finish documenting log files on the Log files page.
Specifically, document parsed logs better (describe how they are
generated in log_compare)

Here are the main logs collected or generated during a test:

 * **console log**
 * **devlog**
 * **syslog**
 * **test log**
 * **parsed log**

These are located in the 'run' directory (also know as the 'log'
directory), at:
``/fuego-rw/logs/<test_name>/<board>.<spec>.<build_id>.<build_number>``

There are additional logs that may be defined for a test, which are
used in post-processing and checking of results for the test.

 * **pn log**
 * **reference log**

================
Results logs
================

These logs are the results of test execution, and have output from
different parts of the system.

console log
==================

The console log is collected by Jenkins during the entire execution of
the test.  It is dominated by the invocation of the test base script,
which is executed as a shell script, with the 'set -x' parameter set.

During execution of the base script, several "source" statements are
encountered, nesting the invocation of scripts multiple times.  The
number of '+' signs preceding a line in the console log indicates the
depth (or invocation nesting level) for that line, in the shell
execution.

There are "phase" messages added to the log during the test, which can
help identify which part of the test a particular sequence is in.
This can help you debug what part of a test (pre_test, build, deploy,
run, post_test) is failing, if any.

The second major part of the script is the post_test phase, which is
also executed as a shell script fragment, utilizing the prolog
generated previously, and documenting the gather of logs and
determination of final test result.

The location of the console log for a test run is at:
``/var/lib/jenkins/jobs/<jobname>/builds/<build_number>/log``

If a test was executed by ftc instead of Jenkins (that is, directly
from the command line), then the consolelog is in the Fuego log
direcotry and is called: ``consolelog.txt``


devlog
===========

This is a summarized list of operations performed during the execution
of a test.  These entries are created when internal routines use the
function :ref:`report_devlog <function report devlog>` to add a line to
this log.

The name of the devlog for a test run is ``devlog.txt``

syslog
===========

The syslog records the messages from the target system's log.  There
are two of these recorded, one during the pre_test (called the
"before" log), and one during the post_test (called the "after" log).

This includes messages from the kernel (if a logger is transferring
the messages from the kernel to the system log), as well as messages
from programs running on the system (that output to their status to
the syslog).

The names of the syslogs for a test are:

 * ``syslog.before.txt``
 * ``syslog.after.txt``

test log
============

This is the output produced by the test program itself.  It is
collected with the *report* and *report_append* functions, which
save the standard output from the commands they run into a log file
which is retrieved from the target at the end of the test.

The name of the test log for a test is: ``testlog.txt``

parsed log
===============

The 'parsed' version of the log, is one that has been grep'ed for a
regular expression using log_compare.  The parsed log should consist
of individual lines showing a pass, fail or skip for each sub-test in
a test suite.

The names of the parsed logs for a test are:

 * *testlog.p.txt*
 * *testlog.n.txt*

==================
Reference logs
==================

Fuego also uses reference logs during test results processing, to
compare against the logs that are generated during a test:

pn log
============

A test may provide a so-called 'pn log', which is a log file recording
the positive and negative results from a previous test run.

If this file exists in the test directory, it is used during
post-processing (in the :ref:`log_compare <function log compare>`
function), to see if the positive or negative results from the current
log match those from the saved pn log.

reference log
==================

This file holds the operations and threshold values for a Benchmark
test.

See :ref:`reference.log`

============
summary
============

In the Fuego version 1.1 (early 2017), the log directories are as
follows:

 * Fuego logs:

   * ``/fuego-rw/logs/<testname>/<board>.<spec>.<build_id>.<build_number>``

     * run.json - saved by test itself
     * devlog.txt - written by report_devlog
     * syslog.before.txt - saved by ov_rootfs_logread (dump_syslogs)
     * syslog.after.txt - saved by ov_rootfs_logread
     * testlog.txt - saved by get_testlog
     * testlog.p.txt - created by log_compare
     * consolelog.txt - created by ftc (or link to Jenkins console log)
     * res.json - created by bench_processing (parser.py for a Benchmark test)
     * fres.json - created by post_test (parser.py for a Functional test

 * jenkins files:

   * ``/var/lib/jenkins/jobs/<jobname>/builds/buildnum/``

     * build.xml
     * changelog.xml
     * log - console log created by Jenkins

 * per-test data files:

   * ``/fuego-rw/logs/<testname>``

     * plot.data
     * plot.png
     * metrics.json - list of metrics for this test
     * <testname>.<metric>.json - list of data values for a metric
     * <testname>.info.json - list of meta-data for each data line (device, firmware, platform data points)

