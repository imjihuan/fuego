.. _fuego_developer_notes:

################################
Fuego Developer Notes
################################

This page has some detailed notes about Fuego, Jenkins and how they
interact.

=============
Resources
=============

Here are some pages in this wiki with developer information:

 * :ref:`Coding style <Coding style>`
 * :ref:`Core_interfaces <Core interfaces>`
 * :ref:`Glossary`
 * :ref:`Fuego test results determination`
 * :ref:`Fuego_naming_rules <Fuego naming rules>`
 * :ref:`Fuego Object Details`
 * :ref:`Integration with ttc`
 * :ref:`Jenkins User Interface`
 * :ref:`Jenkins Plugins`
 * :ref:`License And Contribution Policy`
 * :ref:`Log files`
 * :ref:`Metrics`
 * :ref:`Overlay Generation`
 * :ref:`ovgen feature notes`
 * :ref:`Parser module API`
 * :ref:`Test Script APIs`
 * :ref:`Test package system`
 * :ref:`Test server system`
 * :ref:`Transport notes`
 * :ref:`Variables`


==========
Notes
==========

.. important:
   This information was gathered in 2016, and some references
   here still refer to JTA (the predecessor to Fuego).  Some of
   this material is out of date.  But it is kept because it does
   explain some aspects of Jenkins/Fuego behavior

specific questions to answer
===============================

What happens when you click on the "run test" button:

 * what processes start on the host

    * java - jar ``/home/jenkins/slave.jar``, executing a shell running
      the contents of the job.xml "hudson.tasks.Shell/command" block:

      * this block is labeled: "Execute shell: Command" in the "Build"
        section of the job, in the configure page for the job in the
        Jenkins user interface.

 * what interface is used between the executing test (ultimately
   a bash shell script) and the jenkins processes

   * stop is performed by using the Jenkins REST API -- by accessing "http://localhost:8090/...stop"
   * see :ref:`Fuego-Jenkins`

Each Jenkins node is defined in Jenkins
in:``/var/lib/jenkins/nodes/config.xml``

 * The name of the node is used as the "Device" and "NODE_NAME" for a
   test.

   * These environment variables are passed to the test agent, which is
     always "java -jar /home/jenkins/slave.jar"

 * Who calls ovgen.py? The core does, at the very start of ``main.sh``
   via the call to ``set_overlay_vars`` (which is in ``overlays.sh``:w

Jenkins calls:

  * java -jar /fuego-core/slave.jar

     * with variables:

       * Device
       * Reboot
       * Rebuild
       * Target_PreCleanup
       * Target_PostCleanup
       * TESTDIR
       * TESTNAME
       * TESTSPEC
       * FUEGO_DEBUG

   * the "Test Run" section of the Jenkins job for a test has a
     shell script fragment with the following shell commands: ::

        #logging areas=pre_test,pre_check,build,makepkg,deploy,snapshot,run,
        #    post_test,processing, parser,criteria,charting
        #logging levels=debug,verbose,info,warning,error
        #export FUEGO_LOGLEVELS="run:debug,parser:verbose"
        export FUEGO_CALLER="jenkins"
        ftc run-test -b $NODE_NAME -t Functional.hello_world -s default \
            --timeout 6m \
            --reboot false \
            --rebuild false \
            --precleanup true \
            --postcleanup true

Some Jenkins notes:

Jenkins stores its configuration in plain files
under JENKINS_HOME You can edit the data in these files using the web
interface, or from the command line using manual editing (and have the
changes take affect at runtime by selecting "Reload configuration from
disk".

By default, Jenkins assumes you are doing a continuous integration
action of "build the product, then test the product".   It has default
support for Java projects.

Fuego seems to use distributed builds (configured in a master/slave
fashion).

Jenkins home has (from 2007 docs):

  * config.xml - has stuff for the main user interface
  * *.xml
  * fingerprints - directory for artifact fingerprints
  * jobs

    * <JOBNAME>

      * config.xml
      * workspace
      * latest
      * builds

        * <ID>
        * build.xml
        * log
        * changelog.xml

The docker container interfaces to the outside host filesystem via the
following links:

 * /fuego-ro -> <host-fuego-location>/fuego-ro
 * /fuego-rw -> <host-fuego-location>/fuego-rw
 * /fuego-core -> <host-fuego-core-location>

What are all the fields in the "configure node" dialog:
Specifically:

 * where is "Description" used? - don't know
 * what is "# of executors"? - don't know for sure
 * how is "Remote root directory" used?

   * this is a path inside the Fuego container.  I'm not sure what
     Jenkins uses it for.

 * what are Labels used for?

   * as tags for grouping builds

 * Launch method: Fuego uses the Jenkins option "Launch slave via
   execution of command on the Master"
   The command is "java -jar /fuego-core/slave.jar"

     * NOTE: slave.jar comes from fuego-core git repository, under slave.jar


The fuego-core directory structure is: ::


   overlays - has the base classes for fuego functions
     base - has core shell functions
     testplans - has json files for parameter specifications (deprecated)
     distribs - has shell functions related to the distro
   scripts - has fuego scripts and programs
    (things like overlays.sh, loggen.py, parser/common.py, ovgen.py, etc.
   slave.jar - java program that Jenkins calls to execute a test
   tests - has a directory for each test
     Benchmark.foo
       Benchmark.foo.spec
       foo.sh
       test.yaml
       reference.log
       parser.py
     Functional.bar
     LTP
     etc.


What is groovy:

 * an interpreted language for Java, used by the scriptler plugin to
   extend Jenkins

What plugins are installed with Jenkins in the JTA configuration?

 * Jenkins Mailer, LDPA, External Monitor Job Type, PAM, Ant, Javadoc
 * Jenkins Environment File (special)
 * Credentials, SSH Credentials, Jenkins SSH Slags, SSH Agent
 * Git Client, Subversion, Token Macro, Maven Integration, CVS
 * Parameterized Trigger (special)
 * Git, Groovy Label Assignment Extended Choie Parameter
 * Rebuilder...
 * Groovy Postbuild, ez-templates, HTML Publisher (special)
 * JTA Benchmark show plot plugin (special)
 * Log Parser Plugin (special)
 * Dashboard view (special)
 * Compact Columns (special)
 * Jenkins Dynamic Parameter (special)
 * flot (special) - benchmark graphs plotting plug-in for Fuego

Which of these did Cogent write?

 * the flot plugin (not flot itself)

What scriptler scripts are included in JTA?

 * getTargets
 * getTestplans
 * getTests

What language are scriptler scripts in?

 * Groovy

What is the Maven plugin for Jenkins?

 * Maven is an apache project to build and manage Java projects

   * I don't think the plugin is needed for Fuego

Jenkins refers to a "slave" - what does this mean?

 * it refers to a sub-process that can be delegated work.  Roughly
   speaking, Fuego uses the term 'target' instead of 'slave', and
   modifies the Jenkins interface to support this.


How the tests work
===================

A simple test that requires no building is Functional.bc

  * the test script and test program source are found in the
    directory: ``/home/jenkins/tests/Functional.bc``

This runs a shell script on target to test the 'bc' program.

Functional.bc has the files: ::

    bc-script.sh
       declares "tarball=bc-script.tar.gz"
       defines shell functions:
         test_build - calls 'echo' (does nothing)
         test_deploy - calls 'put bc-device.sh'
         test_run - calls 'assert_define', 'report'
           report references bc-device.sh
         test_processing - calls 'log_compare'
           looking for "OK"
       sources $JTA_SCRIPTS_PATH/functional.sh
     bc-script.tar.gz
       bc-script/bc-device.sh


Variables used (in bc-script.sh): ::

  BOARD_TESTDIR
  TESTDIR
  FUNCTIONAL_BC_EXPR
  FUNCTIONAL_BC_RESULT



A simple test that requires simple building:
  Functional.synctest

This test tries to call fsync to write data to a file, but is
interupted with a kill command during the fsync().  If the child dies
before the fsync() completes, it is considered success.

It requires shared memory (shmget, shmat) and semaphore IPC (semget
and semctl) support in the kernel.

Functional synctest has the files: ::

     synctest.sh
       declares "tarball=synctest.tar.gz"
       defines shell functions:
         test_build - calls 'make'
         test_deploy - calls 'put'
         test_run - calls 'assert_define', hd_test_mount_prepare, and 'report'
         test_processing - calls 'log_compare'
           looking for "PASS : sync interrupted"
       sources $JTA_SCRIPTS_PATH/functional.sh
     synctest.tar.gz
       synctest/synctest.c
       synctest/Makefile
     synctest_p.log
       has "PASS : sync interrupted"


Variables used (by synctest.sh) ::

  CFLAGS
  LDFLAGS
  CC
  LD
  BOARD_TESTDIR
  TESTDIR
  FUNCTIONAL_SYNCTEST_MOUNT_BLOCKDEV
  FUNCTIONAL_SYNCTEST_MOUNT_POINT
  FUNCTIONAL_SYNCTEST_LEN
  FUNCTIONAL_SYNCTEST_LOOP

.. note::

  could be improved by checking for CONFIG_SYSVIPC in /proc/config.gz
  to verify that the required kernel features are present

MOUNT_BLOCKDEV and MOUNT_POINT are used by 'hd_test_mount_prepare' but
are prefaced with FUNCTIONAL_SYNCTEST or BENCHMARK_BONNIE


from clicking "Run Test", to executing code on the target...
config.xml has the slave command: /home/jenkins/slave.jar
-> which is a link to /home/jenkins/jta/engine/slave.jar

overlays.sh has "run_python $OF_OVGEN ..."
where OF_OVGEN is set to "$JTA_SCRIPTS_PATH/ovgen/ovgen.py"

How is overlays.sh called?
  it is sourced by ``/home/jenkins/scripts/benchmarks.sh`` and
    ``/home/jenkins/scripts/functional.sh``

``functional.sh`` is sourced by each Funcational.foo script.


For Functional.synctest: ::

  Functional.synctest/config.xml
    for the attribute <hudson.tasks.Shell> (in <builders>)
      <command>....
        souce $JTA_TESTS_PATH/$JOB_NAME/synctest.sh</command>

  synctest.sh
    '. $JTA_SCRIPTS_PATH/functional.sh'
       'source $JTA_SCRIPTS_PATH/overlays.sh'
       'set_overlay_vars'
           (in overlays.sh)
           run_python $OF_OVGEN ($JTA_SCRIPTS_PATH/ovgen/ovgen.py) ...
                  $OF_OUTPUT_FILE ($JTA_SCRIPTS_PATH/work/${NODE_NAME}_prolog.sh)
             generate xxx_prolog.sh
           SOURCE xxx_prolog.sh

       functions.sh pre_test()

       functions.sh build()
          ... test_build()

       functions.sh deploy()

       test_run()
         assert_define()
         functions.sh report()




NOTES about ovgen.py
======================

What does this program do?

Here is a sample command line from a test console output: ::

  python /home/jenkins/scripts/ovgen/ovgen.py \
    --classdir /home/jenkins/overlays//base \
    --ovfiles /home/jenkins/overlays//distribs/nologger.dist /home/jenkins/overlays//boards/bbb.board \
    --testplan /home/jenkins/overlays//testplans/testplan_default.json \
    --specdir /home/jenkins/overlays//test_specs/ \
    --output /home/jenkins/work/bbb_prolog.sh


So, ovgen.py takes a classdir, a list of ovfiles a testplan and a
specdir, and produces a xxx_prolog.sh file, which is then sourced by
the main test script

Here is information about ovgen.py source: ::

  Classes:
   OFClass
   OFLayer
   TestSpecs


::

  Functions:
   parseOFVars - parse Overlay Framework variables and definitions
   parseVars - parse variables definitions
   parseFunctionBodyName
   parseFunction
   baseParseFunction
   parseBaseFile
   parseBaseDir
   parseInherit
   parseInclude
   parseLayerVarOverride
   parseLayerFuncOverride
   parseLayerVarDefinition
   parseLayerCapList - look for BOARD.CAP_LIST
   parseOverrideFile
   generateProlog
   generateSpec
   parseGenTestPlan
   parseSpec
   parseSpecDir
   run



Sample generated test script
==================================

bbb_prolog.sh is 195 lines, and has the following vars and functions:
::


   from class:base-distrib:
     ov_get_firmware()
     ov_rootfs_kill()
     ov_rootfs_drop_caches()
     ov_rootfs_oom()
     ov_rootfs_sync()
     ov_rootfs_reboot()
     ov_rootfs_state()
     ov_logger()
     ov_rootfs_logread()

   from class:base-board:
    LTP_OPEN_POSIX_SUBTEST_COUNT_POS
    MMC_DEV
    SRV_IP
    SATA_DEV
    ...
    JTA_HOME
    IPADDR
    PLATFORM=""
    LOGIN
    PASSWORD
    TRANSPORT
    ov_transport_cmd()
    ov_transport_put()
    ov_transport_get()

   from class:base-params:
    DEVICE
    PATH
    SSH
    SCP

   from class:base-funcs:
    default_target_route_setup()

   from testplan:default:
    BENCHMARK_DHRYSTONE_LOOPS
    BENCHMARK_<TESTNAME>_<VARNAME>
    ...
    FUNCTIONAL_<TESTNAME>_<VARNAME>


========
Logs
========

When a test is executed, several different kinds of logs are
generated: devlog, systemlogs, the testlogs, and the console log.


created by Jenkins
====================

 * console log

   * this is located in ``/var/lib/jenkins/jobs/<test_name>/builds/<build_id>/log``
   * is has the output from running the test script (on the host)


created by ftc
=====================

 * console log

   * if 'ftc' was used to run the test, then the console log is
     created in the log directory, which is:
     ``/fuego-rw/logs/<test_name>/<board>.<spec>.<build_id>.<build_number>/``

   * it is called ``consolelog.txt``



created by the test script
================================

 * these are created in the directory:
   ``/fuego-rw/logs/<test_name>/<board>.<spec>.<build_id>.<build_number>/``
 * devlog has a list of commands run on the board during the test

   * named ``devlog.txt``

 * system logs have the log data from the board (e.g.
   /var/log/messages) before and after the test run:

   * named: ``syslog.before.txt`` and ``syslog.after.txt``

 * the test logs have the actual output from the test program on the target

   * this is completely dependent on what the test program outputs
   * named: ``testlog.txt``

     * this is the 'raw' log

   * there may be 'parsed' logs, which is the log filtered by log_compare operations:

      * this is named: ``testlog.p.txt`` or ``testlog.n.txt``
      * the 'p' indicated positive results and the 'n' indicates negative results

================
Core scripts
================

The test script is sourced by the Fuego ``main.sh`` script

This script sources several other scripts, and ends up including
``fuego_test.sh``

 * load overlays and set_overlay vars
 * pre_test $TEST_DIR
 * build
 * deploy
 * test_run
 * set_testres_file, bench_processing, check_create_logrun (if a benchmark)
 * get_testlog $TESTDIR, test_processing (if a functional test)
 * get_testlog $TESTDIR (if a stress test)
 * test_processing (if a regular test)

functions available to test scripts:
See :ref:`Test Script APIs`


Benchmark tests must provide a ``parser.py`` file, which extracts the
benchmark results from the log data.

It does this by doing the following: ::

  import common as plib
  f = open(plib.TEST_LOG)
  lines = f.readlines()
  ((parse the data))

This creates a dictionary with a key and value, where the key matches
the string in the ``reference.log`` file

The ``parser.py`` program builds a dictionary of values by parsing
the log from the test (basically the test output).
It then sends the dictionary, and the pattern for matching the
reference log test criteria to the routine:
``common.py:process_data()``

It defines ``ref_section_pat``, and passes that to ``process_data()``
Here are the different patterns for ``ref_section_pat``: ::

  9  "\[[\w]+.[gle]{2}\]"
  1  "\[\w*.[gle]{2}\]"
  1  "^\[[\d\w_ .]+.[gle]{2}\]"
  1  "^\[[\d\w_.-]+.[gle]{2}\]"
  1  "^\[[\w\d&._/()]+.[gle]{2}\]"
  4  "^\[[\w\d._]+.[gle]{2}\]"
  2  "^\[[\w\d\s_.-]+.[gle]{2}\]"
  3  "^\[[\w\d_ ./]+.[gle]{2}\]"
  5  "^\[[\w\d_ .]+.[gle]{2}\]"
  1  "^\[[\w\d_\- .]+.[gle]{2}\]"
  1  "^\[[\w]+.[gle]{2}\]"
  1  "^\[[\w_ .]+.[gle]{2}\]"


Why are so many different ones needed??
Why couldn't the syntax be: <var-name> <test> <value> on one line?

It turns out this is processed by an 'awk' script.  thus the weird
syntax.  We should get rid of the awk script and use python instead.


How is benchmarking graphing done?
===================================

See :ref:`Benchmark parser note`


docker tips
============

See :ref:`Docker Tips`
