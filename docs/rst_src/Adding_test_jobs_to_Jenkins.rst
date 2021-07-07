.. _addtestjob:

############################
Adding test jobs to Jenkins
############################

Before performing any tests with Fuego, you first need to
add Jenkins jobs for those tests in Jenkins.

To add jobs to Jenkins, you use the 'ftc' command line tool.

Fuego comes with over a hundred different tests, and not
all of them will be useful for your environment or testing needs.

In order to add jobs to Jenkins, you first need to have
created a Jenkins node for the board for which you wish to add
the test.  If you have not already added a board definition,
or added your board to Jenkins, please see:
:ref:`Adding a board <adding_board>`

One your board is defined as a Jenkins node, you can add test
jobs for it.

There are two ways of adding test jobs, individually, and
using testplans.  In both cases, you use the 'ftc add-jobs'
command.

============================
Selecting tests or plans
============================

The list of all tests that are available can be seen
by running the command 'ftc list-tests'.

Run this command inside the docker container, by going to
the shell prompt inside the Fuego docker container, and typing ::


  (container_prompt)$ ftc list-tests


To see the list of plans that come pre-configured with Fuego,
use the command 'ftc list-plans'.

  (container_prompt)$ ftc list-plans


A plan lists a set of tests to execute.  You can examine the
list of tests that a testplan includes, by examining the testplan
file. The testplan files are in JSON format, and are in the
directory ``fuego-core/overlays/testplans``.

============================
Adding individual tests
============================

To add an individual test, add it using the 'ftc add-jobs'
command.  For example, to add the test "Functional.hello_world"
for the board "beaglebone", you would use the following command: ::


  (container prompt)$ ftc add-job -b beaglebone -t
  Functional.hello_world


Configuring job options
=========================

When Fuego executes a test job, several options are available to
control aspects of job execution.  These can be configued on the
'ftc add-job' command line.

The options available are:

 * timeout
 * rebuild flag
 * reboot flag
 * precleanup flag
 * postcleanup flag

See 'ftc add-jobs help' for details about these options and how to
specify them.

Adding tests for more than one board
======================================

If you want to add tests for more than one board at a time, you can do
so by specifying multiple board names after the '-b' option with
'ftc add-jobs'.Board names should be a single string argument, with
individual board names separated by commas.

For example, the following would add a job for Functional.hello_world
to each of the boards rpi1, rpi2 and beaglebone. ::


  (container prompt)$ ftc add-job -b rpi1,rpi2,beaglebone -t
  Functional.hello_world



================================
Adding jobs based on testplans
================================

A testplan is a list of Fuego tests with some options for each one.
You can see the list of testplans in your
system with the following command: ::


  (container prompt)$ ftc list-plans


To create a set of jobs related to docker image testing, for the
'docker' board on the system, do the following: ::


  (container prompt)$ ftc add-jobs -b docker -p testplan_docker


To create a set of jobs for a board called 'beaglebone',
do the following: ::


  (container prompt)$ ftc add-jobs -b myboard -p testplan_smoketest


The "smoketest" testplan has about 20 tests that exercise a variety of
features on a Linux system.  After running these commands, a set of
jobs will appear in the Jenkins interface.

Once this is done, your Jenkins interface should look something like
this:

.. image:: ../images/fuego-1.1-jenkins-dashboard-beaglebone-jobs.png
   :width: 900




