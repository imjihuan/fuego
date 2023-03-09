
#######################
Command Line Tool - ftc
#######################

============
Introduction
============

Fuego comes with a command line tool, called ``ftc``, that is
used to perform a variety of tasks.

``ftc`` has many sub-commands for performing different operations,
but they can be grouped into different categories, including
the following:

 * Essential commands
 * Commands for inspecting results
 * Commands for managing boards
 * Commands for working with Jenkins
 * Commands for working with a Fuego (or other) server
 * Miscelaneous commands

Note that you can get a list of all the commands supported by ``ftc``,
by using ``ftc help``.

For help on any individual sub-command, use ``ftc help <command>``.

General FTC options
===================
Some options to ``ftc`` commands are used consistently throughout the tool.
That is, there are some global options, which apply to any sub-command,
such as '-v' for verbose mode.  Or, some options are always specified
with the same argument letter, such as '-b' to specify the board
for the operation.

Here are options that are commonly used with ftc commands:

 * **-v** = verbose mode - this means to report more information than usual
 * **-q** = quiet mode - this means to report less information than usual,
   sometimes making the command completely silent.  Quiet mode is often
   used to omit header data and make the output suitable for parsing by
   other tools.
 * **-h** = help - show help for the specified sub-command
 * **--debug** = run in debug mode - this make ``ftc`` produce a log of debug
   information while it runs
 * **-b** = specify the board - used when a command takes a board argument
 * **-t** = specify the test - used when a command test a test argument.

.. note:: A test name is specified using either its full name, which
   includes the test type, or its shortened name, which is the portion
   of the name after the type.  For example, for the test
   ``Functional.hello_world``, the full test name is "Functional.hello_world",
   and the short name is just "hello_world".  Either name may be
   specified with the '-t' option, although it is usually more convenient
   to use the short name.

   In case there is both a Benchmark and Functional test with the same
   short name, the full name must be used with '-t' to make it clear
   which test is referred to.


===============
Commands groups
===============

Essential commands
==================

Here are the commands that are essential for adding information
to the Jenkins interface (nodes and jobs), for querying the
available boards, tests, and test specs, and for executing a test.

 * add-nodes
 * add-jobs
 * list-boards
 * list-tests
 * list-specs
 * run-test

These core commands are used for setup of jobs in Jenkins, and
for finding out (or trying to remember), the test elements that
are available on your system for test exection.
Use ``ftc add-nodes`` and ``ftc add-jobs`` to populate the
Jenkins interface with nodes and jobs (respectively.  See the
section `Jenkins-related commands`_ below for more information about these
commands, or see :ref:`Adding a Board <adding_board>` or
:ref:`Adding test jobs to Jenkins <addtestjob>` for more details.

The most important ``ftc`` command is ``ftc run-test``.  This is
the command used to actually run a test.  Details about ``ftc run-test``
can be found in the section `ftc run-test`_ below.

Commands for inspecting results
===============================

``ftc`` provides a few commands for inspecting the results from
operations.  Usually, Jenkins is used to show visualization of
results.  However, you can also see what tests have been run, and
what the results from those tests were, using the following commands:

 * list-runs
 * gen-report

Use the ``list-runs`` command to see a list of all test runs on the system.
The list of runs can be filtered by various criteria.

FIXTHIS - reference --where clause description section

Use the ``gen-report`` command to generate reports of test results data.

Usually, test results are examined in the :ref:`Jenkins User interface <jenkins_ui>`.
However, you can also generate lists of results at the command line
using ``ftc gen-report``

This command gives you control over the results that are reported,
as well as the content (exact fields and headers) and format of the
report.

In summary, ``ftc gen-report`` can:

 * select the test runs to report results from
 * select the header fields to show in the report
 * select the data (result) fields to show in the report
 * filter the data by results (for example showing only failures)
 * select the format of the report
 * specify the output location for the report

See the section :ref:`Generating Reports <genreports>` for details about
this command and its options,
and overall information about generating reports from test run data.

Board management
================
These commands have to do with managing boards (defined on the local machine):

 * list-boards
 * query-board
 * set-var
 * delete-var
 * power-cycle
 * power-off
 * power-on

In Fuego, boards are defined and configured in a board file, found
in the ``fuego-ro/boards`` directory.

You can use ``ftc list-boards`` to see a list of the currently configured
boards in the Fuego system.

Board attributes (or variables)
--------------------------------
Usually, to change the configuration
of a board, you manually edit the file for that board and adjust its base
settings directly.  However, Fuego also allows for viewing board attributes
(also referred to as board 'variables'), and for setting and removing
attributes of a board using ``ftc`` (that is, without having to manually
read or edting the board configuration file).

The variables defined in the board configuration file are considered
its 'base' settings or base attributes. These attributes are considered
statically defined for a board.  Fuego also allows you to store information
about a board that is considered dyanmic.  This information
is stored in a board configuration file in the ``fuego-rw/boards`` directory.

Also, Fuego automatically assigns certain functions to a board based on
the value of the DISTRIB variable for the the board.  These functions are called
overlay functions, because they can be
overridden (or "overlayed") with functions from the board configuration
file.

ftc query-board
---------------
You can use the ``ftc query-board`` command to view any of the configured or
calculated information about a board.  This includes its base variables,
dynamic variables, and overlay functions.

To see all of the attributes of a board, use ``ftc query-board`` and specify
the board to inspect, like this: ::

  ftc query-board -b beaglebone

The output may be quite verbose.  To see just a list of attributes names,
(ie without their values), use: ::

  ftc query-board -q -b beaglebone

To see the value of a single attribute, use the ``-n`` option, and specify
the attribute name: ::

  ftc query-board -b beaglebone -n TOOLCHAIN

The ``set-var`` and ``delete-var`` commands are used to set or delete an individual
dynamic variable for a board.
These ``ftc`` commands are intended for programs that automatically
configure attributes of a board, and are not usually used by users directly.

ftc set-var and delete-var
--------------------------
Here are some examples of using ``set-var`` and ``delete-var`` on a board: ::

  ftc set-var -b beaglebone FOO_COUNT=5

  ftc delete-var -b beaglebone FOO_COUNT

These would set FOO_COUNT (to the value of '5') in the beaglebone board attributes
or remove FOO_COUNT from the beaglebone board attributes, respectively.

Finally, ``ftc`` includes commands for performing power control of a board.
When Fuego detects that a board is not responding, it tries to automatically restart
the board by doing a power reset.

ftc power commands
------------------
The three commands that can be used to manipulate board power are:
``power-cycle``, ``power-off``, and ``power-on``

Here is an example of a power-related command for a board: ::

  ftc power-cycle -b beaglebone

.. note:: In order for Fuego to be able to manipulate the power for
   a board, the board must have a supported BOARD_CONTROL system
   in its configuration.

Jenkins-related commands
========================
These commands are used for interacting with Jenkins, from the command line.

 * add-job(s)
 * add-node(s)
 * list-jobs
 * list-nodes
 * rm-job(s)
 * rm-node(s)
 * build-job(s)
 * add-view

By default, Fuego is installed with the Jenkins CI system.  Fuego supports
integration with many Jenkins operations.  This includes ``ftc`` commands
for adding Fuego board and tests to Jenkins, and manipulating those
items - listing them, removing them, and in the case of jobs, running them.

Of course, if you are using Fuego in an installation without the Jenkins
CI system, none of these commands are relevant, and they may safely
be ignored.

.. important: Jenkins uses different names for boards and tests than Fuego
   does.  What Fuego calls a 'board', Jenkins refers to as a 'node'.
   What Fuego calls a 'test' is referred to in Jenkins as a 'job'.
   Fuego tests are not exactly identical with Jenkins jobs. In
   Jenkins the job definition includes the board and spec for the test.
   But the main element of a Jenkins job is the Fuego test it is
   associated with (and which it includes in its name).

As a grammatical courtesy, for some of these commands, you can omit the
trailing 's' in the command name, and the command will still work.
For example: ``ftc add-job`` does the exact same thing as ``ftc add-jobs``

When a user wants to install a Fuego test as a job in Jenkins, they use
the ``ftc add-node`` command, to first make sure that the appropriate
node (Fuego board) is registered with Jenkins, and then ``ftc add-jobs``
to add the Fuego tests as jobs within the Jenkins system.

To view or remove nodes or jobs, the ``list-nodes``, ``list-jobs``,
``rm-nodes``, or ``rm-jobs`` commands are used, respectively.

Finally, the ``ftc build-job`` command can be used to start a Jenkins
job.  This is the preferred mechanism to start a Fuego test that has
been registered with Jenkins via ``ftc add-job``.

ftc add-nodes
-------------
``ftc add-nodes`` is used to register a Fuego board with the Jenkins
interface as an execution node (an object that can run a test).

One you have added a board to Fuego, you can add it to the Jenkins
interface, using: ::

  ftc add-node -b beaglebone

Usually this will be done once, by the Fuego administrator, when a board
is initially added to Fuego.  Please see :ref:`Adding a Board <adding_board>` for
instructions to add a new board to Fuego.

ftc add-jobs
------------
The ``ftc add-jobs`` command is used to configure Jenkins to run Fuego tests, by
creating Jekins job configurations for them.  The command
provides a few different ways to specify
the set of tests to add Jenkins, as well as some options to set other test control options
that are used with Fuego when the respective jobs are executed.

The overall usage for ``add-jobs`` is: ::

  ftc add-jobs -b <board>[,board2...] -t <test> [-s <testspec>]
       [--timeout <timeout>] [--rebuild <true|false>] [--reboot <true|false>]
       [--precleanup <true|false>] [--postcleanup <true|false>]

And here is an example of a command: ::

  Example: ftc add-jobs -b beaglebone -t Dhrystone --timeout 5m --rebuild false

This would create the Jenkins job: ``beaglebone.default.Benchmark.Dhrystone``
(where 'default' means the 'default' spec (or variant) for this test).

To see a list of possible boards, tests or specs, use ``ftc list-boards``,
``ftc list-tests`` or ``ftc list-specs -t <test_name>`` respectively.

The other options are used to set the values for the options used with
``ftc run-test`` when the test is executed by Jenkins.

  * timeout: integer with a suffix from 'smhd' (seconds, minutes, hours, days).
  * rebuild: if true rebuild the test source even if it was already built.
  * reboot: if true reboot the board before the test.
  * precleanup: if true clean the board's test folder before the test.
  * postcleanup: if true clean the board's test folder after the test.

See the section `ftc run-test`_ for more information on the meaning of
these options.

Note that you can specify more than one board using a comma-separated
list for the <board> argument. For example: ::

     ftc add-jobs -b board1,board2 -t hello_world

If you specify a batch test, then Fuego will scan the list of tests included
in that batch test, and create jobs for all of them.  For example: ::

     ftc add-jobs -b beaglebone -t batch_smoketest

will try to create a job for each test referenced in the batch_smoketest
batch job.

ftc add-view
------------
Finally, Fuego provides a convenience command for easily creating a Jenkins
'view'.  Jenkins supports the ability to organize test jobs by creating
views in the user interface.  However, it is often convenient to create
a view for a small set of Fuego jobs, based on their name.

``ftc add-view`` creates a new 'view' in Jenkins, with a filter based on the
parameter provided.

The syntax for adding a view is: ::

  ftc add-view <view-name> [<job_spec>]

Basically, you provide a view name, and then an optional string indicating
the set of jobs you would like included in that view
in the Jenkins dashboard.

You can select individual jobs by name, or use a regular expression
(ie with wildcards) to specify the set of jobs to include.

If the job specification starts with "=", it is a comma-separated
list of job names.  If not, then it is used as a regular expression.

As a special case, when the command is used without a 'job_spec' argument
then the view is created with a job_spec consisting of the view-name
with wildcards added to the beginning and ending of it.

Here are some examples: ::

   Example 1: ftc add-view batch ".*.batch"

   Example 2: ftc add-view network =bbb.default.Functional.ipv6connect,bbb.default.Functional.netperf

   Example 3: ftc add-view LTP

Example 3 would add a view with a name of 'LTP' and
a job specification of ".*LTP.*".  This would result in a view
that included all jobs that have "LTP" anywhere in their
job names.


Commands for working with a Fuego (or other) server
===================================================
The Fuego server feature supports executing tests, and sharing
test definitions and test run results, between multiple test sites.
This feature is currently under construction.

The following commands are related to using Fuego in conjunction with
a Fuego server:

 * get-board
 * get-run
 * install-run
 * install-test
 * list-requests
 * package-run
 * package-test
 * put-binary-package
 * put-request
 * put-run
 * put-test
 * query-request
 * rm-request
 * update-board

The following commands support remote operations (using the '-r' or
'--remote' flags):

 * list-boards
 * list-tests
 * list-runs

These commands are used for performing operations with a Fuego server.
A Fuego server supports registering boards, and storing test packages, binary
test packages, run data, and test execution requests.  the
``package-test`` and ``package-run`` allow for creating packages
for a test and a run, respectively.  These can be uploaded to the server,
or sent directly to another developer, who can install them on their system.

Users can download tests, binary-packaged tests, and runs from a server.

A Fuego server allows a collection of Fuego sites to share tests and test
results (runs) with each other.  It also allows users to request tests
to be executed on boards at another site.  These test 'requests' can
be submitted, viewed, and processed by users interacting with the
central server.

.. caution:: The Fuego server feature is currently under construction.
   You may experiment with it if you would like, but the features
   are not robust and the documentation is not finished for it yet.
   Proceed at your own risk with this feature (and these commands).


Miscellaneous commands
======================
The following commands are for various utility functions, unrelated
to the other categories of operations:

 * config
 * help
 * version

The ``ftc config`` command allow quering the current ftc config file,
(located in the ``fuego-ro\conf`` directory).  Use ``ftc config -l``
to get a list of all config items, and ``ftc config <config_name>``
to get the value of the indicated config item.  Usually, humans
will not use this, as they can inspect the file manually.  The
``config`` command is intended for use for external tools that
want to determine the value for a specific Fuego configuration item.

The ``ftc help`` command is used to get online usage help for ``ftc``
and for individual ``ftc`` commands.

Examples: ::

  ftc help - will show a list of all available ftc commands

  ftc help list-boards - will show the help for the 'list-boards' command


``ftc version`` shows the current version of ``ftc``.


============
ftc run-test
============
One of the most important commands that ftc can execute is the 'run-test'
command.  This is the command actually used to perform a test on a
board.  A test can be executed either from the command line (using
the ``ftc`` command, or it can be exected from Jenkins, via a job
definition (which is made with the ``ftc add-jobs`` command).
Even when running from Jenkins, the ``ftc run-test`` command is
used to actually execute the test.

When running a test, multiple arguments and options are supported.

Arguments that are required for this are the board name and the test name.
The board is specified using '-b' and the test is specified using '-t'.
foo bar

Here is the ``ftc run-test`` usage: ::

  Usage: ftc run-test -b <board> -t <test> [-s <spec>] [-p <phases>]
    [--timeout <timeout>]
    [--rebuild <true|false>]
    [--reboot <true|false>]
    [--precleanup <true|false>]
    [--postcleanup <true|false>]
    [--batch]
    [--dynamic-vars <variable assignments or python_dict>]


Choosing a test spec
====================
Some Fuego tests include different variants of a test, that can be
selected using the test ``spec``.  You can see the list of specs
for a test using the ``ftc list-specs`` command.  If no spec is specified
for run-test, then the "default" spec is used, which is usually the test
executed in its most common configuration.

Test control options
====================
Various other flags control aspects of test execution:

 * **timeout**: specify the maximum time the test is allowed to run
   (default: 30m = 30 minutes)
 * **rebuild**: if 'true' rebuild the test source even if it was already built.
   (default: 'false')
 * **reboot**: if 'true' reboot the board before the test.
   (default: 'false')
 * **precleanup**: if 'false', do not clean up the board's test folder before the test.
   (default: 'true')
 * **postcleanup**: if 'false' do not clean up the board's test folder after the test.
   (default: 'true')
 * **batch**: generate a batch id for this test

Each of the boolean test control flags can set be 'true' or 'false'.

The control flags are used to pre-reboot the board being tested,
or to prevent or force cleaning up the test directory.  Usually,
Fuego removes all traces of the test upon test completion.
When debugging a test, it is often useful to set ``--postcleanup`` to
'false', so that Fuego won't remove the test directory on the board
at the end of the test.  This allows you to inspect the test
materials on the board, or run the test manually.
Setting ``--precleanup`` to 'false' is sometimes useful when
you want to avoid the deploy phase. (See `phases`_ below.)

The timeout value is specified as an integer and a suffix
(one of s, m, h, or d).  The suffix corresponds to one of:
seconds, minutes, hours, days.  For example, a 10-minute
timeout would be specified as ``--timeout 10m``.

The batch id is a number used to group tests together for reporting purposes.
if ``--batch`` is specified, Fuego will select a new batch id for the test, and
set the ``FUEGO_BATCH_ID`` environment variable.  This will be recorded for this
test and any sub-tests called during execution of the test).
You can filter tests using the batch id in a ``--where`` clause, in
the ``ftc gen-report`` command.

.. note:: If you would like to specify your own batch id for a test,
   you can do so by setting the ``FUEGO_BATCH_ID`` environment variable
   to your own value before calling ``ftc run-test``.

Test variables
==============
It is possible to override one or more test variables on the ``ftc run-test``
command line, using the ``--dynamic-vars`` option.

This allows overriding the variables in a test spec from the ftc command line.
For example, the ``Benchmark.Dhrystone`` test uses a test variable
of ``LOOPS`` to indicated the number of times to execute the
Dhrystone operations.  The value of this variable in the default
spec for this test is 10000000 (10 million).  You could override
this value at the command line, using ::

  ftc run-test -b bbb -t Dhrystone --dynamic-vars "LOOPS=40000000"

You can specify the variable value using a python dictionary
expression or using simple NAME=VALUE syntax.  Here is an example
using python dictionary syntax: ::

  ftc run-test -b bbb -t Benchmark.Dhrystone --dynamic-vars "{'LOOPS':'400000000'}"

Note that both of these syntaxes allow for multiple variables to
be specified.  In the case of NAME=VALUE pairs, separate the
pairs with a comma, like this: ::

  --dynamic-vars "VAR1=value1,VAR2=Another value"


Phases
======
A test is normally run in phases, one sequentially after the other.
However, in special circumstances (such as when debugging a test
during test development) it may be useful to only execute certain
phases of the test.  Some phases take a long time, and it can be helpful
to skip them when debugging a test.

When specifying a set of phases with the ``run-test`` '-p' option,
each phases is represented by a single character: ::

  p = pre_test
  c = pre_check
  b = build
  d = deploy
  s = snapshot
  r = run
  t = post_test
  a = processing
  m = make binary package

To control the phases executed during a test run, use the '-p' option,
and specify a list of characters corresponding to the phases you
want to execute.

For example: ::

  ftc run-test -b myboard -t mytest -p pcbd

would run the ``pre_test``, ``pre_check``, ``build`` and ``deploy``
phases of the test 'mytest'.

This is useful during development of a test (ie. for testing tests).
Use caution running later phases of a test without their normal
precursors (e.g. specifying to execute the ``run`` phase, without
also specify to execute the ``pre_test``, ``build`` or ``deploy`` phases).
This can lead to undefined behavior.

.. warning:: It is almost always desirable to run the ``pre_test`` phase
   ('-p'), so use caution omitting that phase from your list.
   In general, using phase selection is quite tricky, and unless
   you know what each phase does (and its side effects), it may lead
   to unexpected results.

Results and Result code
=======================
When a test is run, log files and results are placed in a log directory.
The log directory is based on a set of attributes for the test run,
underneath the ``fuego-rw/logs`` directory.  The pattern for
the directory name is: ::

  <test_name>/<board>.<spec>.<build_number>.<build_number>

So a full log directory name might look like this: ::

  fuego-rw/logs/Benchmark.signaltest/beaglebone.default.5.5

For more details about the log files that are produced during
a test run, see :ref:`Log files <logfiles>`.

In addition to populating the Fuego log directory, if Jenkins is
being used and a corresponding Jenkins job is defined
for the test, then the Jenkins interface will be populated with information
for that test run (referred to as a "build" in Jenkins).  A visualization
of the test results (for example a chart or a table), may be prepared for
display in the Jenkins interface.

Also, although a test may have multiple individual test cases that it executes,
the overall status of the test is reported via the return code from ``ftc run-test``.
This will be 0 for success, and something else for test failure.
Usually, a non-zero result will be the value that was returned by the main
test program that was run on the board.

