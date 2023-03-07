======================================
API Reference
======================================

This page documents the Fuego core API, which consists of a set
of functions callable by a Fuego test, and a set of variables available
to tests from the Fuego system.

The following functions are available to test scripts.

FIXTHIS - core functions: should document which of the functions are internal, and which are intended for test script use

======================================
Functions available for tests to call
======================================
These are the functions that can be called by a test's script (``fuego_test.sh``)

You could consider this the library of functions provided by Fuego for the test
operation. 

Functions for interacting with the target
=========================================
These commands are used to provide generic methods to execute
commands on the board and to copy files to and from the
board.  Fuego insulates the test itself from the specific
commands needed to interact with the board (via, for example,
ssh, serial console, adb, telnet, ttc, etc.)

 * :ref:`cmd` - execute a command on the target
 * :ref:`get` - get a file or files from the target
 * :ref:`put` - put a file or files on the target
 * :ref:`safe_cmd` - execute a command, handling out-of-memory conditions

Functions for checking dependencies and requirements
====================================================
These function allow for checking that the test has required variables
defined, and that the board has required programs, libraries and modules.

 * `assert_has_program`_ - check that a program is present on the target, and abort the test if it is missing
 * `check_has_program`_ - check to see if a specified program is on the target
 * `assert_has_module`_ - check to see if a specified kernel module is on the board
 * `assert_define`_ - to be used externally - check that an environment variable is defined
 * `get_program_path`_ - find path to execute a progam on the target board
 * `is_abs_path`_ - check if a path is absolute (starts with /) or not
 * `is_empty`_ - fail if an environment variable is empty
 * `is_on_target`_ - check if a program or file is on the target board
 * `is_on_target_path`_ - check if a program is in one of the directories in the PATH on the target board

Functions for preparing board and executing tests
=================================================
 * `function_hd_test_mount_prepare`_ - make sure test filesystems are mounted and ready for testing
 * `function_hd_test_clean_umount`_ - unmount test filesystems
 * `function_log_this`_ - used to execute operations on the host (as opposed to on the board), and log their output
 * `function_report`_ - execute command on board and put stdout into the test log
 * `function_report_append`_ - execute command on board and append stdout to log
 * `function_report_live`_ - execute command on board, and capture stdout to a log on the host

Functions for parsing results
=============================
This is a simple function for checking results in a test log

 * `log_compare`_ - check results of test by scanning the test log for a regular expression

Functions for cleanup
=====================
These functions may be used

 * `kill_procs`_ - kill processes on the board
 * `target_reboot`_ - reboot the board

For batch tests
===============

 * `allocate_next_batch_id`_ - allocate and return the next unique batch id
 * `run_test`_ - run another test from the current test (almost always a batch test)

Misceleneous functions
======================

 * `run_python_` - used to run a python program on the host (inside the docker container)

For printing messages at various message output levels
======================================================
 * `dprint`_ - print a 'debug' message
 * `vprint`_ - print a 'verbose' message
 * `iprint`_ - print an 'info' message
 * `wprint`_ - print a 'warning' message
 * `eprint`_ - print an 'error' message

fuego_test.sh functions
=======================
This is a list of functions that a test can provide to the Fuego system
(in the test's fuego_test.sh script):

These functions correspond roughly to the test phases, which are normally
these phases (in this order): ::

  pre_test, pre_check, build, deploy, makepgk, run, post_test, processing

Here are the main fuego_test.sh functions:

 * `test_pre_check_` - check that the board has needed dependencies and attributes
 * `test_build_` - build the test software
 * `test_deploy_` - put the test software on the board
 * `test_run_` - execute the test software on the board
 * `test_processing_` - parse test output for results

Most tests will have most of these functions.  But any test can omit
functions that are not needed.  For example, if a test has no
dependencies, does not have a binary program that needs to be compiled,
or any script that needs to be deployed to the board, a test might omit
the ``test_pre_check``, ``test_build``, and ``test_deploy`` functions,
and only have the ``test_run`` and ``test_processing`` phases.

Here are functions that are allowed in ``fuego_test.sh``, that can be
used to override the normal Fuego operations.  Most tests will not
include these functions.

 * `test_snapshot_` - get board status and info (customize the "board snapshot" feature)
 * `test_fetch_results_` - get test results from the board (customize the fetch operation)
 * `test_cleanup_` - clean up the board after the test (customize the cleanup operation)

