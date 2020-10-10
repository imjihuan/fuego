.. _fuego_loglevels:

######################
FUEGO LOGLEVELS
######################

The environment variable ``FUEGO_LOGLEVELS`` is used to control message
output (including debug messages) during execution of a Fuego test.

================
Introduction
================

The ``FUEGO_LOGLEVELS`` variable specifies a string containing a list of
areas and log level combinations, separated by commas.  The area and
loglevel are joined by a colon.

Here is an example: ::

  export FUEGO_LOGLEVELS="deploy:verbose,criteria:debug"


Note that a sample of this line is provided in the Jenkins job for
every test.  It is, by default, commented out. However, you can easily
turn on ``FUEGO_LOGLEVELS`` by uncommenting this line.  You can customize
the log level to use for different execution areas by changing the
value of the variable.

To change this line in a Jenkins job, select the job in the Jenkins
interface, then select "Configure", and edit the line in "Execute
Shell - Command" box, in the "Build" section of the job configuration.

If the ``FUEGO_LOGLEVELS`` variable is not set, the default logging level
for all areas of test execution is "info".

===============
Log levels
===============

There are 5 logging levels available, and messages from Fuego are
categorized into these 5 different levels:

 * error
 * warning
 * info
 * verbose
 * debug

Specifying a particular level means that all messages above that level
will be output.  Messages at level 'error' are always shown, no matter
what log level is specified.

=================
Execution areas
=================

Area names correspond to phases, and to sub-phases of the test
execution stepx.
The following area names are supported:

 * pre_test
 * pre_check
 * build
 * makepkg
 * deploy
 * snapshot
 * run
 * post_test
 * processing
 * parser
 * criteria
 * charting

=================
Output functions
=================

With this feature, 5 new functions have been added to the Fuego core.
These functions may be used in your test shell script (``fuego_test.sh``), so
that your output may be managed the same way that core output is managed.

The following functions are available:

 * dprint - print output if the message level is 'debug'.
 * vprint - print output if the message level is 'debug' or 'verbose'.
 * iprint - print output if the message level is 'debug', verbose',
   or 'info'.
 * wprint - print output if the message level is 'debug', 'verbose',
   'info', or warning'.
 * eprint - print output always (message level 'error')

Deprecated FUEGO_DEBUG
=========================

``FUEGO_LOGLEVELS`` replaces the earlier :ref:`FUEGO_DEBUG <FUEGO DEBUG>`
variable for controlling debug output of Fuego.  However, as of Fuego
version 1.4, ``FUEGO_DEBUG`` is still supported for backwards
compatibility.
