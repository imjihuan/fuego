.. _fuego_board_function_lib.sh_:

############################
fuego board function lib.sh
############################

====================
Description
====================

``fuego_board_function_lib.sh`` is library of shell functions for
performing certain board-side operations in a distribution-independent
way.  This set of utility functions is provided so that commonly used
operations can be performed on a variety of distributions (both
desktop and embedded distributions of Linux) without having to write
special-case implementations.

The library is written purely in POSIX, so it can be used for
board-side testing on almost all Linux platforms.
The library is normally copied to the board during the test's deploy
phase.  It resides in found in the host computer in the 'scripts'
directory.  This is found at
``/fuego-core/engine/scripts/fuego_board_function_lib.sh`` inside the
Docker container.

Deploying the library
=======================

To put the script on board being tested, copy it to the board during
the test's 'deploy' phase (in test_deploy in the test's ``fuego_test.sh``
file), with a command like so: ::

 put $FUEGO_CORE/engine/scripts/fuego_board_function_lib.sh $BOARD_TESTDIR/fuego.$TESTDIR

Using the library
=====================

Once the script is on the board, you can use it in your test's
board-side shell script by sourc'ing it into the script, and calling
its functions.

Assuming you have a shell script running in the
$BOARD_TESTDIR/fuego.$TESTDIR directory, you could have the following
lines inside your script: ::

  . fuego_board_function_lib.sh
  set_init_manager

This 'sources' the script (function library) into your current shell
environment, and then calls the 'set_init_manager' routine, which is
one of the functions in the library.

Functionality overview
=======================

``fuego_board_function_lib.sh`` supports the following operations:

   1) Detecting the init manager (proc 1) running on the system
   2) Detecting the type of logger service running on the system
   3) Starting and stopping system services in a distribution-neutral
      way

=======================
Function reference
=======================

 * set_init_manager - sets 'init_manager' to either 'systemd' or
   'sysvinit'
 * detect_logger_service - sets 'logger_service' to either 'syslog-ng'
   or 'syslog'
 * exec_service_on_target - is used to start or stop a named service
   on the target board
