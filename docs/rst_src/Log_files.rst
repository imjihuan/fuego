.. _log_files:

##################
Log files
##################

During test execution, Fuego collects several different logs.

These represent different aspects of the system, and are used for
different purposes.

Here are the main logs collected or generated during a test:

 * **console log**
 * **devlog**
 * **syslog**
 * **test log**

These are located in the 'run' directory (also know as the 'log'
directory), at:
``/fuego-rw/logs/<test_name>/<board>.<spec>.<build_id>.<build_number>``

================
Results logs
================

These logs are the results of test execution, and have output from
different parts of the system.

console log
==================

The console log is collected by Jenkins during the entire execution of
the test.  It is primarily filled with data from the invocation of the
test base script, which is executed as a shell script, with the 'set -x'
parameter set.

When debug options are turned on, then each line of the test shell
script is output and put into the console log as it is executed.  During
execution of the base script, several "source" statements are
encountered, nesting the invocation of scripts multiple times.  The
number of '+' signs preceding a line in the console log indicates the
depth (or invocation nesting level) for that line, in the shell
execution.

There are "phase" messages added to the log during the test, which
help identify which part of the test a particular sequence is in.
This can help you debug what part of a test (pre_test, build, deploy,
run, post_test, etc.) is failing, if any.

The location of the console log for a test run is at:
``/fuego-core/lib/jenkins/jobs/<jobname>/builds/<build_number>/log``

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

============
Summary
============

In the Fuego version 1.5 (released in 2019), the log directories are as
follows:

 * Fuego logs:

   * ``/fuego-rw/logs/<testname>/<board>.<spec>.<build_id>.<build_number>``

     * run.json - saved by test itself
     * devlog.txt - written by report_devlog
     * syslog.before.txt - saved by ov_rootfs_logread (dump_syslogs)
     * syslog.after.txt - saved by ov_rootfs_logread
     * testlog.txt - saved by get_testlog
     * consolelog.txt - created by ftc (or link to Jenkins console log)

 * jenkins files:

   * ``/var/lib/jenkins/jobs/<jobname>/builds/buildnum/``

     * build.xml
     * changelog.xml
     * log - console log created by Jenkins

 * per-test data files:

   * ``/fuego-rw/logs/<testname>``

     * flat_plot_data.txt - has results data in "flat" ASCII text format
     * flot_chart_data.json - has chart data in json and HTML format
