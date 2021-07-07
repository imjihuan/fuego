##############
Glossary
##############

Here is a glossary of terms used in this wiki:

Here is a short table that relates a few Jenkins terms to Fuego terms:

+--------------+------------------+------------------------------------------+
| Jenkins term |Fuego term        |Description                               |
+==============+==================+==========================================+
|slave         |''none''          |this is a long-running jenkins process,   |
|              |                  |that executes jobs.  It is usually (?)    |
|              |                  |assigned to a particular node             |
+--------------+------------------+------------------------------------------+
|node          |board             |item being tested (Fuego defines          |
|              |                  |Jenkins node for each board in the system)|
+--------------+------------------+------------------------------------------+
|job           |test              |a collection of information needed to     |
|              |                  |perform a single test                     |
+--------------+------------------+------------------------------------------+
|''none''      |request           |a request to run a particular test on a   |
|              |                  |board                                     |
+--------------+------------------+------------------------------------------+
|build         |run(or 'test run')|the results from executing the job or test|
+--------------+------------------+------------------------------------------+
|''none''      |plan              |the plan has the list of tests and how to |
|              |                  |run them (which variation, or 'spec' to   |
|              |                  |use)                                      |
+--------------+------------------+------------------------------------------+
|''none''      |spec              |the spec indicates a particular variation |
|              |                  |of a test                                 |
+--------------+------------------+------------------------------------------+

=====
B
=====

``base test script``

  See ``test script``.

``benchmark``

  A type of test where one or more numeric metrics indicates the status
  of the test.  See :ref:`Benchmark parser notes`
  for more information about processing these metrics.

``binary package``

  A tarfile containing the materials that would normally be deployed to
  the board for execution.

``board file``

  A file that describes (using environment variables) the attributes of
  a target board.  This has the extension .board and is kept in the
  directory ``/fuego-ro/boards``.

``build``

  In Jenkins terminology, a "build" is an execution of a test, and the
  resulting artifacts associated with it.  In Fuego, this is also
  referred to as a test "run".

====
C
====

``console log``

  The full output of execution of a test from Jenkins.
  See :ref:`Log files` for details.

``criteria``

  This is an expression which indicates whether how a test result
  should be interpreted.  This is also referred to as a "pass criteria".
  Criteria files are stored in ``criteria.json`` files.  See
  :ref:`criteria.json <criteria_json>` for details.

=====
D
=====


``devlog``

  The developer log for a test.
  See :ref:`Log files` for details.

``Device``

  The name of a target board in the Fuego system.

``device under test``

  In test terminology, this refers to the item being tested.
  In Fuego, this may also be called the ''Device'', ''board'',
  ''node'', or ``target``

``distribution``

  This refers to a set of software that is running on a Linux machine.
  Example "distributions" are Debian, Angstrom or Android. The
  distribution defines file locations, libraries, utilities and several
  important facilities and services of the machine (such as the init
  process, and the logger).

=====
F
=====

``functional test``

  A type of test that returns a single pass/fail result, indicating
  whether the device under test.  It may include lots of sub-tests.

====
J
====

``Jenkins``

  An advanced continuous integration system, used as the default
  front-end for the Fuego test framework. see :ref:`Jenkins`

``job``

  In Jenkins terminology, a job is a test

====
L
====

``log file``

  Several log files are created during execution of a test.  For details
  about all the different log files, see :ref:`Log files`.

====
M
====

``metric``

  A numeric value measured by a benchmark test as the result
  of the test.  This is compared against a threshold value to determine
  if the test passed or failed.  See :ref:`Benchmark
  parser notes`

=====
O
=====

``overlay``

  This is a set of variables and functions stored in a fuegoclass file,
  which are used to customize test execution for a particular board.
  See :ref:`Overlay Generation` for details.

``ovgen.py``

  Program to collect "overlay" data from various scripts and data
  files, and produce the final test script to run.
  see :ref:`Overlay Generation`.

=====
P
=====

``package``

  See ``test package``.

``parsed log``

  The test log file after it has been filtered by log_compare.
  See :ref:`Log files` for details.

``parser.py``

  A python program, included with each Benchmark test, to scan the test
  log for benchmark metrics, check each against a reference threshold,
  and produce a plot.png file for the test.  See :ref:`parser.py` and
  :ref:`Benchmark parser notes` for more information.

``provision``

  To provision a board is to install the system software on it.  Some
  board control systems re-provision a board for every test.  In
  general, Fuego runs a series of tests with a single system software
  installation.

=====
R
=====

``reference log``

  This file (called "reference.log") defines the regression threshhold
  (and operation) for each metric of a benchmark test.  See
  :ref:`reference.log` and :ref:`Benchmark parser notes`

``run``

  See ``test run``.

====
S
====

``spec variable``

  A test variable that comes from a spec file. See
  :ref:`Test variables`

``stored variable``

  A test variable that is stored in a read/write file, and can be
  updated manually or programmatically.  See
  :ref:`Test variables`

``syslog``

  The system log for a test.  This is the system log collected during
  execution of a test.  See :ref:`Log files` for details.


====
T
====

``test``

  This is a collection of scripts, jenkins configuration, source code,
  and data files used to validate some aspect of the device under test.
  See :ref:`Fuego Object Details` for more information.

``test log``

  This is the log output from the actual test program on the target.
  There are multiple logs created during the execution of a test, and
  some might casually also be called "test logs".  However, in this
  documentation, the term "test log" should be used only to refer to the
  test program output.  See :ref:`Log files` for details.

``test package``

  This is a packaged version of a test, including all the materials
  needed to execute the test on another host.  See :ref:`Test
  package system`

``test phases``

  Different phases of test execution defined by Fuego: pre_test, build,
  deploy, test_run, get_testlog, test_processing, post_test.  For a
  description of phases see: :ref:`fuego test phases`

``test program``

  A program that runs on the target to execute a test and output the
  results.  This can be a compiled program or a shell script (in which
  case the build step is empty)

``test run``

  This is a single instance of a test execution, containing logs and
  other information about the run.  This is referred to in Jenkins as a
  'build'.

``test script``

  The shell script that interfaces between the Fuego core system and a
  test program.  This is a small script associated with each test.
  It is called ``fuego_test.sh``, and it provides a set of test
  functions that are executed on the host (in the container) when a
  test is run.

  The script declares a tarfile, and functions to build,
  deploy and run the test.  The test script runs on the host.  This is
  also called the 'base test script'.  For details about the environment
  that a script runs in or the functions it may call, see :ref:`Variables`,
  :ref:`Core interfaces`, and :ref:`Test Script APIs`.

``test variable``

  This is the name of a variable available to the a test during it's
  execution.  See :ref:`Test variables`.


``TOOLCHAIN``

  Defines the toolchain or SDK for the device.  This is used to select a
  set of environment variables to define and configure the toolchain for
  building programs for the intended test target.

``tools.sh``

  File containing the definition of toolchain variables for the
  different platforms installed in the container (and supported by the
  test environment)  See :ref:`tools.sh` for details.

====
V
====

``variable``

  See ``test variable``
