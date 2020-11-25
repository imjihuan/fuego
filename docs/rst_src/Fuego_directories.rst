#######################
Fuego directories
#######################

This page describes the fuego directory structure,
and what the items in each area are used for.


========================
Inside the container
========================

 * ``/fuego-core`` - the fuego core directory, containing tests,
   scripts and the overlay generator for executing Fuego tests


   * ``fuego`` - directory for fuego back-end system

     * This is populated from the ``fuego-core`` repository when the container
       is created, and provides landing places for other symlinks in the system
     * ``engine`` - symlink for backwards compatibility with older versions
       of Fuego tests
     * ``overlays``

       * ``base`` - contains the base fuego functions and variables
       * ``distribs`` - contains files for defining different targert
         distribution attributes
       * ``testplans`` - contains testplan files (in json format)
       * ``test_specs`` - contains test spec files (in json format)

         * Note that each spec is in a named file (eg. ``Functional.bc.spec``)
           in this directory

     * ``scripts`` - core scripts which implement the Fuego test framework
     * ``tests`` - actual test materials themselves, including the
       base script for each test

       * ``Benchmark.foo`` - has the tarfile, patches, base script, parser.py
         and reference.log for a particular benchmark test
       * ``Functional.bar`` - has the tarfile, patches, base script, results
         comparison logs (*_p.log and *_n.log) for a particular functional test

 * ``/fuego-ro`` - has runtime data used by Fuego, but not writable by fuego

   * Note that this is bind-mounted from inside the container to the host system
   * ``boards`` - place for board configuration files
   * ``conf`` - place where Fuego configuration is stored
   * ``toolchains`` - place where toolchains may be installed

 * ``/fuego-rw`` - has runtime data used by the Fuego system in the
   container, and actually stored on the host (for persistence)

   * Note that this is bind-mounted from inside the container to the host system

   * ``buildzone`` - place where test programs are built

     * ``Functional.foo-platform-name`` - directory for build materials
       for that test and platform combination

   * ``logs`` - place where test run logs are stored

     * ``Functional.<test_name>`` - log files for a particular test test

       * ``<board>.<spec>.<build_id>.<build_number>`` - the 'run' directory
         for a test execution

         * ``devlog.txt`` - the developer log for a test - list of operations
           executed during the test
         * ``syslogs.<time>.txt`` - system logs for test runs (from the target)
           (before the test and after the test)
         * ``testlog.txt`` - test logs for test runs (from the actual test programs)
         * ``consolelog.txt`` - link to Jenkins console log, or local file,
           if test was executed using ftc

     * ``Benchmark.<test_name>`` - logs files for a benchmark test

       * plot.data
       * plot.png
       * ``<board>.<spec>.<build_id>.<build_number>`` -
         the 'run' directory for a test execution

         * all of the above, plus:
         * ``Benchmark.<test_name>.info.json``
         * ``Benchmark.<test_name>.<metric>.json``

   * ``boards`` - place where board-specific test data is stored



 * ``/var/lib/jenkins`` - where Jenkins system configuration and data files live

   * ``jobs`` - holds the Jenkins test definition files (``config.xml`` for each test) as well
     as test output for each test run

            * ``<jobname>``

              * ``builds`` - data about all test runs for this test

                * ``<build_number>`` - jenkins data and console log for a
                  particular test run (``build.xml`` and log)

   * ``plugins`` - place where Jenkins stores plugin code and data

     * This is populated from the fuego source repository ``frontend-install/plugins``
       when the container is created

   * ``userContent`` - material that is served by Jenkins for the user interface

     * ``docs`` - has the Fuego PDF documents
     * ``fuego.logs`` - link to ``/fuego-rw/logs`` - so that logs are accessible
       from Jenkins user interface

   * ``updates`` - used for Jenkins update operations
   * ``logs`` - has Jenkins process logs

     * ``slaves`` - has Jenkins control logs for each target board

       * ``<target>`` - has the slave logs for the indicated target


=====================================
In the 'fuego' source repository
=====================================

 * ``docs`` - contains documentation for the Fuego system
 * ``frontend-install`` - has material for configuring the Jenkins
   installation for Fuego

    * ``plugins`` - has plugins installed to Jenkins in the docker container

      * ``flot-plotter-plugin`` source for the flot plotting plugin

 * ``fuego-host-scripts`` - contains scripts for creating and launching
   the fuego container
 * ``fuego-scripts`` - contains miscellaneous scripts used at
   container build time and runtime
 * ``fuego-ro`` - has runtime data used by the Fuego system in the container
 * ``fuego-rw`` - has runtime data used by the Fuego system in the container


========================================
In the 'fuego-core' source repository
========================================

 * ``engine`` - symlink for backwards compatibility with tests from
   older Fuego versions
 * ``overlays`` - has the fuego script system and data

   * ``base`` - contains the base fuego functions and variables
   * ``distribs`` - contains files for defining different targert
     distribution attributes
   * ``testplans`` - contains testplan files (in json format)

 * ``scripts`` - core scripts which implement the Fuego test framework
 * ``tests`` - has the actual test materials themselves, including the
   base script for each test

   * ``Benchmark.foo`` - has the tarfile, patches, base script, ``parser.py``
     and ``reference.log`` for a particular benchmark test
   * ``Functional.bar`` - has the tarfile, patches, base script, results
     comparison logs (*_p.log and *_n.log) for a particular functional test
