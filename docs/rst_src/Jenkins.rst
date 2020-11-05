############
Jenkins
############

Jenkins is a continuous integration system with a lot of features and
a rich plugin ecosystem.  It is used as the default front end (user
interface) for the Fuego test framework.

The Jenkins website is at: `<https://jenkins.io/>`_

=================================
How Jenkins is used by Fuego
=================================

Jenkins is used as the default graphical user interface to Fuego, for
managing tests executed by the system.  It serves as both the "front end"
and the "back end" user interface for the system.

Jenkins is used on the "front end" to organize the tests provided by
Fuego, and present the user interface (UI) for test selection, test
configuration, and test execution.

Jenkins is also used to see the tests for a particular set of boards.

Jenkins also provides the triggers for the test system.  That is,
Jenkins initiates jobs, based on events, timeframes, or polling of
the status of things.

On the "back end", Jenkins is used to monitor the execution of tests,
and to show test status and results.  Via the Jenkins interface, the
user can find out information about a test, the history of test
results, and view logs from test runs.  Jenkins provides the
visualization of test results for users to view.  (See
:ref:`Jenkins Visualization`.

Nomenclature
============

Jenkins was originally developed as a build-time continuous integration
system, and uses a few different terms for operations than Fuego does.
For example, a test definition in Jenkins is called a "job"  This is
the set of configuration items about a test that are used to execute
it.  The data associated with an actual execution of a test is called
a "build".  In Fuego, these are called "test" and "run" respectively.

======================
Miscelaneous notes
======================

 * builds are marked by Jenkins as: successful, failed, stable, unstable.

   * a freestyle build is successful if the return code from executing
     the code snippet is 0
   * a freestyle build is considered 'failed' if
     the return code from executing the code snippet is non-zero
   * a build is stable unless explicitly marked otherwise by some
     Jenkins action

    * they are usually marked in a post-test operation, by
      something like TextFinder, groovy, or some other thing

       * see  `<http://stackoverflow.com/questions/8148122/
         how-to-mark-a-build-unstable-in-jenkins-when-running-shell-scripts>`_
