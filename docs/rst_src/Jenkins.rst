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

Jenkins is used to organize the tests provided by Fuego, and present
the user interface for test selection, test execution, and information
about test history, logs, etc.

Jenkins is also used to see the tests for a particular set of boards.

Jenkins also provides the triggers for the test system.  That is,
Jenkins initiates jobs, as configured by the user, for starting tests
and collecting test results.


======================
Miscelaneous notes
======================

 * Fuego logs (test log, devlog, syslog and parsed log - see :ref:`Log
   files` are not available through the Jenkins interface (as of
   Aug-2016).  This seems like a big oversight. See :ref:`Issue 0010`

 * builds are marked by Jenkins as: successful, failed, stable, unstable.

   * a freestyle build is successful if the return code from executing
     the code snippet is 0
   * a freestyle build is considered 'failed' if
     the return code from executing the code snippet is non-zero
   * a build is stable unless explicitly marked otherwise by some
     Jenkins action

    * they are usually marked so in a post-test operation, by
      something like TextFinder, groovy, or some other thing

       * see  `<http://stackoverflow.com/questions/8148122/
         how-to-mark-a-build-unstable-in-jenkins-when-running-shell-scripts>`_
