#######################
Fuego directories
#######################

This page describes the Fuego directory structure,
and what the items in each area are used for.

=====================================
In the 'fuego' source repository
=====================================

 * ``docs`` - contains documentation for the Fuego system
 * ``frontend-install`` - has material for configuring the Jenkins
   installation for Fuego

    * ``plugins`` - has plugins installed to Jenkins in the docker container

      * ``flot-plotter-plugin`` source for the flot plotting plugin

 * ``fuego-host-scripts`` - contains scripts for creating and launching
   the Fuego container
 * ``fuego-core`` - has the Fuego core scripts and tests.  This directory
   is a separate git repository, populated during installation.
 * ``fuego-ro`` - has runtime data used by the Fuego system in the container
 * ``fuego-rw`` - has runtime data used by the Fuego system in the container


========================
Inside the container
========================

 * ``/fuego-core`` - the fuego core directory, containing tests,
   scripts and the overlay generator for executing Fuego tests.
   This is bind-mounted to the ``fuego-core`` repository on the host
   when the Fuego container is created.

   * ``engine`` (*deprecated*) - symlink for backwards compatibility
     with older versions of Fuego tests.  Use of 'engine' in a Fuego
     directory path should be avoided in all new code.
   * ``overlays`` - contains the Fuego "class" system of shell functions
     for performing board-related operations.

     * ``base`` - contains the base Fuego functions and variables
     * ``distribs`` - contains files for defining functions for different
       distributions that a board might be running
     * ``testplans`` (*deprecated*) - contains testplan files (in json format)
     * ``test_specs`` (*deprecated*) - contains test spec files (in json format)

   * ``scripts`` - core scripts which implement the Fuego test framework
   * ``tests`` - materials for the actual Fuego tests

     * ``Benchmark.foo`` - has the tarfile, patches, base script,
       ``parser.py``, ``test.spec`` and other files, for a particular
       benchmark test
     * ``Functional.bar`` - has the tarfile, patches, base script,
       ``test.spec`` and other files, for a particular functional test

 * ``/fuego-ro`` - has read-only data used by Fuego.
   This is bind-mounted from inside the container to the host system.

   * ``boards`` - place for board configuration files
   * ``conf`` - place where Fuego configuration is stored
   * ``toolchains`` - place for toolchain data and installation scripts

 * ``/fuego-rw`` - has runtime data used by the Fuego system in the
   container, and actually stored on the host (for persistence).
   This is bind-mounted from inside the container to the host system

   * ``boards`` - place for writable board-specific data

     * ``<board_name>`` - place for artifacts for a particular board

   * ``buildzone`` - place where test programs are built

     * ``Functional.<test_name>-<toolchain_name>`` - directory for build
       materials for a test and toolchain combination

   * ``logs`` - place where test run logs are stored

     * ``<test_name>`` - log and result files for a test

       * ``<board>.<spec>.<build_id>.<build_number>`` - the 'run' directory
         for a test execution.  Some of the files in this directory are:

         * ``consolelog.txt`` - link to Jenkins console log, or local file,
           if test was executed using ftc
         * ``devlog.txt`` - the developer log for a test - list of operations
           executed during the test
         * ``machine-snapshot.txt`` - information about the system immediately
           prior to test execution
         * ``prolog.sh`` - test environment variables and functions used
           at test execution time.  These are derived from definitions in
           overlay files (fuegoclass files) and from spec files.
         * ``run.json`` - test run file.  This has the results of the test
           in a formatted file.
         * ``syslogs.<time>.txt`` - system logs for test runs (from the target)
           (before the test and after the test)
         * ``testlog.txt`` - test log for a test run. This has the output
           from the actual test program execution.

 * ``/var/lib/jenkins`` - Jenkins system configuration and data files

   * ``jobs`` - holds the Jenkins test definition files
     (``config.xml`` for each test) as well as test output for each test run

            * ``<jobname>``

              * ``builds`` - data about all test runs for this test

                * ``<build_number>`` - jenkins data and console log for a
                  particular test run (``build.xml`` and log)

   * ``plugins`` - place where Jenkins stores plugin code and data
   * ``userContent`` - material that is served by Jenkins for the user
     interface

     * ``docs`` - has the Fuego PDF documents
     * ``fuego.logs`` - link to ``/fuego-rw/logs`` - so that logs are accessible
       from Jenkins user interface

   * ``updates`` - used for Jenkins update operations
   * ``logs`` - has Jenkins process logs

     * ``slaves`` - has Jenkins control logs for each target board

       * ``<target>`` - has the slave logs for the indicated target

