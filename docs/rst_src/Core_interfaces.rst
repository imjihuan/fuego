.. _core_interfaces:

################
Core interfaces
################


This page documents the interface between the Jenkins front end and
the Fuego core engine.  See also :ref:`Variables <variables>`

==========================
From Jenkins to Fuego
==========================

Environment variables passed during a build
================================================

Built-in Jenkins variables for shell script jobs
---------------------------------------------------

``BUILD_ID``
  The current test run id.  As of (at least) Jenkins
  version 2.32.1, this is the same as the BUILD_NUMBER.


``BUILD_NUMBER``
  The current test run number, such as "153".
  This appears to be selected as the next numerical number in
  sequence,by the Jenkins system, at the start of a job.

``BUILD_TAG``
  String of "jenkins-${JOB_NAME}-${BUILD_NUMBER}".
  Convenient to put into a resource file, a jar file, etc for
  easier identification.

``BUILD_URL``
  Full URL of this test run, like
  `<http://server:port/jenkins/job/foo/15/>`_

``EXECUTOR_NUMBER``
  The unique number that identifies the current
  executor (among executors of the same machine) that's carrying out
  this test run. This is the number you see in the "test executor status",
  except that the number starts from 0, not 1.

``JENKINS_HOME``
  The absolute path of the directory assigned on the
  master node for Jenkins to store data.

``JENKINS_URL``
  Full URL of Jenkins, like `<http://server:port/jenkins/>`_

``JOB_NAME``
  Name of Jenkins job for this test.
  In Fuego, this will be something like: "myboard.default.Functional.foo"
  or "myboard.default.Benchmark.bar".  The job name has the form:
  {board}.{spec}.{type}.{test_name}

``JOB_URL``
  Full URL of this test or test suite, like
  `<http://server:port/jenkins/job/myboard.default.Functional.foo/>`_

``NODE_LABELS``
  Whitespace-separated list of labels that are assigned to the node.

``NODE_NAME``
  Name of the slave if the test run is on a slave, or
  "master" if run on master.  In the case of Fuego, this is the board
  name (e.g. 'beagleboneblack')

``WORKSPACE``
  The absolute path of the directory assigned to the test
  run as a workspace.  For Fuego, this is always ``/fuego-rw/buildzone``.
  Note that this comes from "custom workspace" setting in the job definition.

Fuego variables passed from Jenkins system configuration
------------------------------------------------------------

The following variables are defined at the system level, and are passed
by Jenkins in the environment of every job that is executed:

``FUEGO_RO``
  The location where Fuego read-only data (configuration,
  boards and toolchains) are located.  Currently ``/fuego-ro`` in the
  docker container.

``FUEGO_RW``
  The location where Fuego read-write data is located
  (directories for builds, logs (run data), and other workspace and
  scratchpad areas).  Currently ``/fuego-rw``.

``FUEGO_CORE``
  The location where the Fuego script system and tests
  are located.  Currently ``/fuego-core``.

Fuego variables passed from Jenkins job definition
------------------------------------------------------

These variables are defined in the job definition for a test:

``Device``
  This is the target board to run the test on.

``Reboot``
  Indicates to reboot the target device before running the test

``Rebuild``
  Indicates that build instances of the test suite should
  be deleted, and the test suite rebuilt from the tarball

``Target_PreCleanup``
  Indicates to clean up test materials left from
  a previous run of the test, before the test begins.

``Target_PostCleanup``
  Indicates to clean up test materials after the
  test ends.

``TESTPLAN``
  This has the name of the testplan used for this test job.
  Note that this selected by the end user from the output of
  getTestplans.groovy. (example value: testplan_default)

``TESTNAME``
  Has the base name of the test (e.g. LTP vs Functional.LTP)

``TESTSPEC``
  This has the name of the spec used for this test job

``FUEGO_DEBUG``
  Can have a 1 to indicate verbose shell script output

=======================
From Fuego to Fuego
=======================

``DISTRIB``
  Indicates the distribution file for the board.
  This comes from the board file. It's primary purpose is to select the
  logging features of the distribution on the target (to indicate whether
  there's a logger present on target).  The value is often
  'distribs/nologread.dist'

``OF_BOARD_FILE``
  Full path to the board file

``OF_CLASSDIR``
  full path to the overlay class directory
  (usually /home/jenkins/overlays//base)

``OF_CLASSDIR_ARGS``
  argument specifying the overlay class directory
  (usually '--classdir /home/jenkins/overlays//base')

``OF_DEFAULT_SPECDIR``
  path to directory containing test specs
  (usually /home/jenkins/overlays//test_specs)

``OF_DISTRIB_FILE``
  path to the distribution file for the target
  board (often /home/jenkins/overlays//distribs/nologger.dist

``OF_OVFILES``
  FIXTHIS - document what OF_OVFILES is for

``OF_OVFILES_ARGS``
  FIXTHIS - document what OF_OVFILES_ARGS is for

``OF_ROOT``
  root directory for overlay generator
  (usually /home/jenkins/overlays/)

``OF_SPECDIR_ARGS``
  argument to specify the test spec directory
  (usually '--specdir /home/jenkins/overlays//test_specs/')

``OF_TESTPLAN_ARGS``

``OF_TESTPLAN``
  full path to the JSON test plan file for this test
  (often /home/jenkins/overlays//testplans/testplan_default.json)

``OF_TESTPLAN_ARGS``
  argument specifying the path to the testplan
  (often '--testplan /home/jenkins/overlays//testplans/testplan_default.json')

``TEST_HOME``
  home directory for the test materials for this test
  (example: /home/jenkins/tests/Functional.bc)

``TESTDIR``
  base directory name of the test (example: Functional.bc)

``TRIPLET``
  FIXTHIS - document TRIPLET

Deprecated
==============

The following variables are no longer used in Fuego:

``FUEGO_ENGINE_PATH``
  (deprecated in Fuego 1.1 - use '$FUEGO_CORE/engine' now)

``FUEGO_PARSER_PATH``
  (deprecated in Fuego 1.1)


===================
Example Values
===================

Here are the values from a run using the Jenkins front-end with job
bbb.default.Functional.hello_world:

(these are sorted alphabetically)::

  AR=arm-linux-gnueabihf-ar
  ARCH=arm
  AS=arm-linux-gnueabihf-as
  BUILD_DISPLAY_NAME=#2
  BUILD_ID=2
  BUILD_NUMBER=2
  BUILD_TAG=jenkins-bbb.default.Functional.hello_world-2
  BUILD_TIMESTAMP=2017-04-10_21-55-26
  CC=arm-linux-gnueabihf-gcc
  CONFIGURE_FLAGS=--target=arm-linux-gnueabihf --host=arm-linux-gnueabihf --build=x86_64-unknown-linux-gnu
  CPP=arm-linux-gnueabihf-gcc -E
  CROSS_COMPILE=arm-linux-gnueabihf-
  CXX=arm-linux-gnueabihf-g++
  CXXCPP=arm-linux-gnueabihf-g++ -E
  EXECUTOR_NUMBER=0
  FUEGO_CORE=/fuego-core
  FUEGO_RO=/fuego-ro
  FUEGO_RW=/fuego-rw
  FUEGO_START_TIME=1491861326786
  HOME=/var/lib/jenkins
  HOST=arm-linux-gnueabihf
  HUDSON_COOKIE=1b9620a3-d550-4cb1-afb1-9c5a29650c14
  HUDSON_HOME=/var/lib/jenkins
  HUDSON_SERVER_COOKIE=2334aa4d37eae7a4
  JENKINS_HOME=/var/lib/jenkins
  JENKINS_SERVER_COOKIE=2334aa4d37eae7a4
  JOB_BASE_NAME=bbb.default.Functional.hello_world
  JOB_DISPLAY_URL=http://unconfigured-jenkins-location/job/bbb.default.Functional.hello_world/display/redirect
  JOB_NAME=bbb.default.Functional.hello_world
  LD=arm-linux-gnueabihf-ld
  LDFLAGS=--sysroot / -lm
  LOGDIR=/fuego-rw/logs/Functional.hello_world/bbb.default.2.2
  LOGNAME=jenkins
  MAIL=/var/mail/jenkins
  NODE_LABELS=bbb
  NODE_NAME=bbb
  PATH=/usr/local/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games
  PREFIX=arm-linux-gnueabihf
  PWD=/fuego-rw/buildzone
  RANLIB=arm-linux-gnueabihf-ranlib
  Reboot=false
  Rebuild=true
  RUN_CHANGES_DISPLAY_URL=http://unconfigured-jenkins-location/job/bbb.default.Functional.hello_world/2/display/redirect?page=changes
  RUN_DISPLAY_URL=http://unconfigured-jenkins-location/job/bbb.default.Functional.hello_world/2/display/redirect
  SDKROOT=/
  SHELL=/bin/bash
  SHLVL=3
  Target_PostCleanup=true
  Target_PreCleanup=true
  TERM=xterm
  TESTDIR=Functional.hello_world
  TESTNAME=hello_world
  TESTSPEC=default
  USER=jenkins
  WORKSPACE=/fuego-rw/buildzone

===========================
From Fuego to Jenkins
===========================

This sections describes some of the operations that Fuego core
scripts (or a test) can perform to invoke an action by Jenkins
during a test.  To perform a Jenkins action, Fuego uses
Jenkins' REST API using the wget command.

 * To abort a job, fuego does:

   * wget -qO- ${BUILD_URL}/stop
   * This is called by common.sh: ``abort_job()``

 * To check if another test instance is running (do a lock check),
   fuego does:

   * wget -qO- "$(cat ${LOCKFILE})/api/xml?xpath=*/building/text%28%29"

     * LOCKFILE was previously set to hold the contents: ${BUILD_URL},
       so this resolves to:

       * wget -qO- ${BUILD_URL}/api/xml?xpath=*/building/text()

   * This is called by functions.sh:``concurrent_check()``

Jenkins python module
======================

Fuego's ``ftc`` command uses the 'jenkins' python module to perform a
number of operations with Jenkins.  This module is used to:

 * list nodes
 * add nodes
 * remove nodes
 * list jobs
 * build jobs
 * remove jobs
 * re-synch build data for a job (using get_job_config() and reconfig_job())
 * add view

.. note::
   Fuego uses jenkins-cli to add jobs (described next).


Jenkins-cli interface
======================

You can run Jenkins commands from the command line, using the
pre-installed jenkins-cli interface.  This is used by Fuego's
``ftc`` command to create jobs.

jenkins-cli.jar is located in the Docker container at: ::

   /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar


See https://wiki.jenkins-ci.org/display/JENKINS/Jenkins+CLI for
information about using this plugin.

Here is a list of available commands for this plugin: ::

  build
    Runs a test, and optionally waits until its completion.
  cancel-quiet-down
    Cancel the effect of the "quiet-down" command.
  clear-queue
    Clears the test run queue
  connect-node
    Reconnect to a node
  console
    Retrieves console output of a build
  copy-job
    Copies a test.
  create-job
    Creates a new test by reading stdin as a configuration XML file.
  delete-builds
    Deletes test record(s).
  delete-job
    Deletes a test
  delete-node
    Deletes a node
  disable-job
    Disables a test
  disconnect-node
    Disconnects from a node
  enable-job
    Enables a test
  get-job
    Dumps the test definition XML to stdout
  groovy
    Executes the specified Groovy script.
  groovysh
    Runs an interactive groovy shell.
  help
    Lists all the available commands.
  install-plugin
    Installs a plugin either from a file, an URL, or from update center.
  install-tool
    Performs automatic tool installation, and print its location to
    stdout. Can be only called from inside a test run.
  keep-build
    Mark the test run to keep the test run forever.
  list-changes
    Dumps the changelog for the specified test(s).
  list-jobs
    Lists all tests in a specific view or item group.
  list-plugins
    Outputs a list of installed plugins.
  login
    Saves the current credential to allow future commands to run
    without explicit credential information.
  logout
    Deletes the credential stored with the login command.
  mail
    Reads stdin and sends that out as an e-mail.
  offline-node
    Stop using a node for performing test runs temporarily, until the
    next "online-node" command.
  online-node
    Resume using a node for performing test runs, to cancel out the
    earlier "offline-node" command.
  quiet-down
    Quiet down Jenkins, in preparation for a restart. Don't start
    any test runs.
  reload-configuration
    Discard all the loaded data in memory and reload everything from
    file system. Useful when you modified config files directly on disk.
  restart
    Restart Jenkins
  safe-restart
    Safely restart Jenkins
  safe-shutdown
    Puts Jenkins into the quiet mode, wait for existing test runs to
    be completed, and then shut down Jenkins.
  session-id
    Outputs the session ID, which changes every time Jenkins restarts
  set-build-description
    Sets the description of a test run.
  set-build-display-name
    Sets the displayName of a test run
  set-build-result
    Sets the result of the current test run. Works only if invoked
    from within a test run.
  shutdown
    Immediately shuts down Jenkins server
  update-job
    Updates the test definition XML from stdin.
    The opposite of the get-job command
  version
    Outputs the current version.
  wait-node-offline
    Wait for a node to become offline
  wait-node-online
    Wait for a node to become online
  who-am-i
    Reports your credential and permissions


Scripts to process Fuego data
==============================

Benchmark parsing
--------------------

In Fuego, Benchmark log parsing is done by a python system consisting
of ``parser.py`` (from each test), ``dataload.py`` and utility functions in
``fuego-core/engine/scripts/parser``

See :ref:`Benchmark parser notes <benchmark_parser_notes>`,
:ref:`parser.py <parser_py>`, :ref:`reference.log <reference.log>` and
:ref:`Parser module API <Parser_module_API>`.

Postbuild action
------------------

In Fuego, Jenkins jobs are configured to perfrom a postbuild action,
to set the description of a test with links to the test log
(and possibly plot and other files generated in post-processing)
