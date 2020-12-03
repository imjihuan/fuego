###################
Functional.LTP
###################

===============
Description
===============

LTP is the Linux Test Project test, which is actually a "super-test"
which contains literally thousands of sub-tests in all kinds of
categories.

=============
Resources
=============

 * `Project source on github <https://github.com/linux-test-project/>`_
 * `LTP page on Wikipedia <https://en.wikipedia.org/wiki/Linux_Test_Project>`_
 * `Kernel test automation with LTP <https://lwn.net/Articles/625969/>`_ -
   by Cyril Hrubis LWN.net, December 2014


============
Results
============

LTP has thousands of sub-tests, which themselves can be grouped into
collections.

Tests results are organized into testsets, that correspond to these
collections.  A Fuego spec can be used to select what collections to
execute, and also what sub-test cases to skip.

========
Tags
========

 * kernel, posix, realtime

================
Dependencies
================

This test has no dependencies for either the build, or the running
system, in the current configuration used by Fuego.

===========
Status
===========

 * Can be run, but has lot of bugs
 * see :ref:`Functional.LTP_issues`

=========
Notes
=========

For notes about LTP internals, see :ref:`LTP_Notes`

A number of fuego-specific features are available for dealing with
LTP.  Since it is quite large, the build and deployment of LTP can
take a substantial amount of time.  Also, LTP is often already
pre-installed on the target board (along with the distribution), so
building LTP is not required.

Special Fuego variables and specs are available to deal with different
LTP installation and usage scenarios.

Variables
============

 * ``FUNCTIONAL_LTP_TESTS`` (spec variable 'tests') - list the LTP test
   collections to execute

   * Usually specified in the spec

 * ``FUNCTIONAL_LTP_SKIPLIST`` (spec variable 'skiplist') - list the
   individual LTP tests to not execute

   * May be specified in a spec or in the board file

 * ``FUNCTIONAL_LTP_BOARD_SKIPLIST`` - list individual LTP tests to
   not execute

   * Should only be specified in the board file

   * Is used to avoid overwriting the spec 'skiplist'

 * ``FUNCTIONAL_LTP_HOMEDIR`` - specifies a non-default, persistent, location
   where LTP resides on the board

   * This is placed in the board file for a board that has LTP pre-installed


Specs
============

 * Special Fuego LTP specs:

    * **install**

      * Use this to deploy LTP, but not run any tests

    * **make_pkg**

      * Use this to create a tarfile which can be manually installed
        on the target

Special build and deployment scenarios
=============================================

The ``Functional.LTP`` test in Fuego supports 2 major different usage
scenarios, with some helper specs to accomplish setting up for them.

Normally, Fuego installs all test materials needed for a test,
executes the test, then removes all the test materials.  However, in
the case of LTP, the materials are so big that putting them on the
target for every test may be too much overhead.

Also, sometime LTP is already installed on a board, and there's no
need for Fuego to build and deploy LTP to the board in the first
place.

Here are the 2 main scenarios:

 1 - Build LTP, deploy it, and run the requested tests

   * This is the default Fuego scenario, and if no other variables
     are used, this is what will occur

 2 - Check for LTP already on target, and run the requested tests

   * If the variable FUNCTIONAL_LTP_HOMEDIR is set in the board file, then
     ``Functional.LTP`` will skip deploying LTP to the target
   * Fuego will still install a few custom scripts and files for each test
   * LTP tests will run relatively quickly (because build and deploy are omitted)

     * However, LTP test data will take up a lot of space on the target
       (on my system, about 500M)


There are special test specs for setting up LTP persistently on the target:

 * spec: **install** - builds and deploys LTP to the test directory

   * You should set ``FUNCTIONAL_LTP_HOMEDIR`` in the board file.  This is the
     persistent directory where LTP will be installed

 * spec: **make_pkg** - builds LTP, and then creates a tar file that can
   be manually installed on the target

   * The tar file is called ltp.tar.gz, and is left in the log directory
     for the test
   * A link should be provided (called 'tar.gz') to download this tar file
     from the Jenkins server, on the job page for this.

Steps
--------------

Here are exact steps to follow, to build Fuego's LTP, and install it on target

 * decide where to install LTP (recommendation is /opt/ltp)

 * set the ``FUNCTIONAL_LTP_HOMEDIR`` variable in your board file

   * It should have quotes (like other board variables) and look something like this:

::

  FUNCTIONAL_LTP_HOMEDIR="/opt/ltp"


 * Make directory ``/opt/ltp`` on the target board
 * Create a job for the board, with spec "install"

   * 'ftc add-job -b myboard -t Functional.LTP -s install'

 * Execute the job in Jenkins or from ftc

   * 'ftc build-job myboard.install.Functional.LTP'

 * Verify on the target that the materials are present

   * Login, and check that ``/opt/ltp`` is populated

 * Create and execute other LTP jobs (with different specs)

   * e.g. 'ftc add-job -b myboard -t Functional.LTP -s quickhit'
   * e.g. 'ftc add-job -b myboard -t Functional.LTP -s selectionwithrt'
   * Build them using Jenkins or ftc

