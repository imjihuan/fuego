.. _adding_a_new_test:

############################
Adding a new test
############################

========================
Overview of Steps
========================

To add a new test to Fuego, you need to perform the following steps:

 * 1. Decide on a test name and type
 * 2. Make the test directory
 * 3. Get the source (or binary) for the test
 * 4. Write a test script for the test
 * 5. Add the test_specs (if any) for the test
 * 6. Add log processing to the test
 * 6-a. (if a benchmark) Add parser.py and criteria and reference
   files
 * 7. Create the Jenkins test configuration for the test

==========================
Decide on a test name
==========================

The first step to creating a test is deciding the test name.  There
are two types of tests supported by Fuego: functional tests and
benchmark tests.  A functional test either passes or fails, while a
benchmark test produces one or more numbers representing some
performance measurements for the system.

Usually, the name of the test will be a combination of the test type
and a name to identify the test itself.  Here are some examples:
*bonnie* is a popular disk performance test.  The name of this test in
the fuego system is *Benchmark.bonnie*.  A test which runs portions of
the posix test suite is a functional test (it either passes or fails),
and in Fuego is named *Functional.posixtestsuite*.  The test name
should be all one word (no spaces).

This name is used as the directory name where the test materials will
live in the Fuego system.

======================================
Create the directory for the test
======================================

The main test directory is located in
/fuego-core/tests/*<test_name>*

So if you just created a new Functional test called 'foo', you would
create the directory:

 * /fuego-core/tests/Functional.foo

================================
Get the source for a test
================================

The actual creation of the test program itself is outside
the scope of Fuego.  Fuego is intended to execute an existing
test program, for which source code or a script already exists.

This page describes how to integrate such a test program into the
Fuego test system.

A test program in Fuego is provided in source form so that it can
be compiled for whatever processor architecture is used by the
target under test. This source may be in the form of a tarfile,
or a reference to a git repository, and one or more patches.

Create a tarfile for the test, by downloading the test source
manually, and creating the tarfile.  Or, note the reference for the
git repository for the test source.

tarball source
================

If you are using source in the form of a tarfile, you add the name of
the tarfile (called 'tarball') to the test script.

The tarfile may be compressed.  Supported compression schemes, and
their associated extensions are:

 * uncompressed (extension='.tar')
 * compressed with gzip (extension='.tar.gz' or '.tgz')
 * compressed with bzip2 (extension='.bz2')

For example, if the source for your test was in the tarfile
'foo-1.2.tgz' you would add the following line to your test script, to
reference this source: ::

  tarball=foo-1.2.tgz


git source
===============

If you are using source from an online git repository, you reference
this source by adding the variables 'gitrepo' and 'gitref' to the test
script.

In this case, the 'gitrepo' is the URL used to access the source, and
the 'gitref' refers to a commit id (hash, tag, version, etc.) that
refers to a particular version of the code.

For example, if your test program is built from source in an online
'foo' repository, and you want to use version 1.2 of that (which is
tagged in the repository as 'v1.2', on the master branch,  you might
have some lines like the following in the test's script. ::

  gitrepo=http://github.com/sampleuser/foo.git
  gitref=master/v1.2


script-based source
=====================

Some tests are simple enough to be implemented as a single script
(that runs on the board).  For these tests, no additional source is
necessary, and the script can just be placed directly in the test's
home directory. In *fuego_test.sh* you must set the following
variable: ::


 local_source=1


During the deploy phase, the script is sent to the board directly from
the test home directory instead of from the test build directory.


=================
Test script
=================

The test script is a small shell script called ``fuego_test.sh``. It
specifies the source tarfile containing the test program, and provides
implementations for the functions needed to build, deploy, execute,
and evaluate the results from the test program.

The test script for a functional test should contain the following:

 * source reference (either tarball or gitrepo and gitref)
 * function test_pre_check (optional)
 * function test_build
 * function test_deploy
 * function test_run
 * function test_processing

The test_pre_check function is optional, and is used to check that
the test environment and target configuration and setup are correct
in order to run the test.

Sample test script
========================

Here is the ``fuego_test.sh`` script for the test
Functional.hello_world.  This script demonstrates a lot of the core
elements of a test script.::


	#!/bin/bash

	tarball=hello-test-1.0.tgz

	function test_build {
	    make
	}

	function test_deploy {
	    put hello  $BOARD_TESTDIR/fuego.$TESTDIR/
	}

	function test_run {
	    report "cd $BOARD_TESTDIR/fuego.$TESTDIR; \
            ./hello $FUNCTIONAL_HELLO_WORLD_ARG"
	}

	function test_processing {
	    log_compare "$TESTDIR" "1" "SUCCESS" "p"
	}


Description of base test functions
=========================================

The base test functions (test_build, test_deploy, test_run, and
test_processing) are fairly simple.  Each one contains a few
statements to accomplish that phase of the test execution.

You can find more information about each of these functions at the
following links:

 * :ref:`test_pre_check <func_test_pre_check>`
 * :ref:`test_build <func_test_build>`
 * :ref:`test_deploy <func_test_deploy>`
 * :ref:`test_run <func_test_run>`
 * :ref:`test_processing <func_test_processing>`


=======================
Test spec and plan
=======================

Another element of every test is the *test spec*.  A file is used
to define a set of parameters that are used to customize the test
for a particular use case.

You must define the test spec(s) for this test, and add an entry to
the appropriate testplan for it.

Each test in the system must have a test spec file.  This file
is used to list customizable variables for the test.

If a test program has no customizable variables, or none are desired,
then at a minimum a *default* test spec must be defined, with no test
variables.

The test spec file is:

 * named 'spec.json' in the test directory,
 * in JSON format,
 * provides a ``testName`` attribute, and a ``specs``
   attribute, which is a list,
 * may include any named spec you want, but must define at least the
   'default' spec for the test

   * Note that the 'default' spec can be empty, if desired.

Here is an example one that defines no variables. ::


	{
		  "testName": "Benchmark.OpenSSL",
		  "specs": {
		      "default": {}
		  }
	}


And here is the spec.json of the Functional.hello_world example, which
defines three specs: ::


	{
		  "testName": "Functional.hello_world",
		  "specs": {
		      "hello-fail": {
		          "ARG":"-f"
		      },
		      "hello-random": {
		          "ARG":"-r"
		      },
		      "default": {
		          "ARG":""
		      }
		  }
	}


Next, you may want to add an entry to one of the testplan files.
These files are located in the directory
``/fuego-core/overlays/testplans``.

Choose a testplan you would like to include this test, and edit the
corresponding file. For example, to add your test to the list of tests
executed when the 'default' testplan is used, add an entry ``default``
to the 'testplan_default.json' file.

Note that you should add a comma after your entry, if it is not the
last one in the list of *tests*.

Please read :ref:`Test Specs and Plans <test_specs_and_plans>` for
more details.


========================
Test results parser
========================
Each test should also provide some mechanism to parse the results
from the test program, and determine the success of the test.

For a simple Functional test, you can use the :ref:`log_compare
<func_log_compare>` function to specify a pattern to search for in the
test log, and the number of times that pattern should be found in
order to indicate success of the test.  This is done from the
:ref:`test_processing <func_test_processing>` function in the test
script.

Here is an example of a call to log_compare: ::

	function test_processing {
		  log_compare "$TESTDIR" "11" "^TEST.*OK" "p"
	}


This example looks for the pattern *^TEST.*OK*, which finds lines in
the test log that start with the word 'TEST' and are followed by the
string 'OK' on the same line.  It looks for this pattern 11 times.

:ref:`log_compare <func_log_compare>` can be used to parse the logs of
simple tests with line-oriented output.

For tests with more complex output, and for Benchmark tests that
produce numerical results, you must add a python program called
'parser.py', which scans the test log and produces a data structure
used by other parts of the Fuego system.

See :ref:`parser.py <parser_py>` for information about this program.



====================================
Pass criteria and reference info
====================================

You should also provide information to Fuego to indicate how to
evaluate the ultimate resolution of the test.

For a Functional test, it is usually the case that the whole test
passes only if all individual test cases in the test pass.  That is,
one error in a test case indicates overall test failure.  However, for
Benchmark tests, the evaluation of the results is more complicated.
It is required to specify what numbers constitute success vs. failure
for the test.

Also, for very complicated Functional tests, there may be complicated
results, where, for example, some results should be ignored.

You can specify the criteria used to evaluate the test results, by
creating a ':ref:`criteria.json <criteria_json>`' file for the test.

Finally, you may wish to add a file that indicates certain information
about the test results.  This information is placed in the
':ref:`reference.json <reference_json>`' file for a test.

Please see the links for those files to learn more about what they are
and how to write them, and customize them for your system.

=================================
Jenkins job definition file
=================================

The last step in creating the test is to create the Jenkins job for
it.

A Jenkins job describes to Jenkins what board to run the test on, what
variables to pass to the test (including the test spec (or variant),
and what script to run for the test.

Jenkins jobs are created using the command-line tool 'ftc'.

A Jenkin job has the name ``<node_name>.<spec>.<test_type>.<test_name>``

You create a Jenkins job using a command like the following:

 * ``$ ftc add-jobs -b myboard -t Functional.mytest [-s default]``

The ftc 'add-jobs' sub-command uses '-b' to specify the board,
'-t' to specify the test, and '-s' to specify the test spec that
will be used for this Jenkins job.

In this case, the name of the Jenkins job that would be created would
be:

 * myboard.default.Functional.mytest

This results in the creation of a file called config.xml, in the
/var/lib/jenkins/jobs/<job_name> directory.






=========================
Publishing the test
=========================

Tests that are of general interest should be
submitted for inclusion into fuego-core.

Right now, the method of doing this is to create a commit and send
that commit to the fuego mailing list, for review, and hopefully
acceptance and integration by the fuego maintainers.

In the future, a server will be provided where test developers can
share tests that they have created in a kind of "test marketplace".
Tests will be available for browsing and downloading, with results
from other developers available to compare with your own results.
There is already preliminary support for packaging a test using the
'ftc package-test' feature.  More information about this service will
be made available in the future.

=======================
Technical Details
=======================

This section has technical details about a test.

Directory structure
========================

The directory structure used by Fuego is documented at
[[Fuego directories]]



Files
========

A test consists of the following files or items:

==============  ==============  ====================================  =============================================================================== =========
File or item    format          location                              description                                                                     test type
==============  ==============  ====================================  =============================================================================== =========
config.xml      Jenkins XML     /var/lib/jenkins/jobs/{test_name}     Has the Jenkins (front-end) configuration for the test                            all
tarfile         tar format      /fuego-core/tests/{test_name}         Has the source code for the test program                                          all
patches         patch format    /fuego-core/tests/{test_name}         Zero or more patches to customize the test program (applied during the unpack     all
                                                                      phase
base script     shell script    /fuego-core/tests/{test_name}         Is the shell script that implements the different test phases in Fuego            all
                                /fuego_test.sh
test spec       JSON            /fuego-core/tests/{test_name}         Has groups of variables (and their values) that can be used with this test        all
                                /spec.json
test plan(s)    JSON            /fuego-core/overlays/testplan         Has the testplans for the entire system                                           all
parser          python          /fuego-core/tests/{test_name}         Python program to parse benchmark metrics out of the log, and provide a           all, but
                                /parser.py                            dictionary to the Fuego plotter                                                   can be
                                                                                                                                                        missing
                                                                                                                                                        for
                                                                                                                                                        functional
                                                                                                                                                        tests

pass criteria   JSON            /fuego-core/tests/{test_name}          Has the "pass" criteria for the test                                             all
                                /criteria.json
reference info  JSON            /fuego-core/tests/{test_name}          Has additional information about test results,such                               benchmark
                                /reference.json                        as the units for benchmark measurements                                          only

reference.log   Fuego-          /fuego-core/tests/{test_name}          Has the threshold values and comparison operators for                            benchmark
                specific        /reference.log                         benchmark metrics measured by the test                                           only

p/n logs        text            (deprecated)                           Are logs with the results (positive or negative) parsed out,                    functional
                                                                       for determination of test pass/fail                                             only
==============  ==============  ====================================  =============================================================================== =========

