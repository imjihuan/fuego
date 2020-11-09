####################
Target Packages
####################

A 'target package' is a binary archive file that contains the
materials that are needed on a board, to execute a test.  It is in
'tar' format, and contains the materials that would normally be
deployed to the board during the 'deploy' phase of test execution.

=============================
Building a target package
=============================

To build a target package, use "ftc run-test" and specify a subset of
phases to run.  Specifically, specify to run the 'pretest, 'build',
'deploy' and 'makepkg' phases.

Example: ::

   ftc run-test -b beaglebone -t Functional.hello_world -p "pbdm"

The package will be created and placed in the directory ``/fuego-rw/cache/``
with the name: ``$TOOLCHAIN-$TESTNAME-board-package.tar.gz``

==========================================
Making a full cache of target packages
==========================================

To make all of the target packages for a particular board, use the
script ``make_cache.sh``.

This script is located at ``fuego-core/engine/scripts/make_cache.sh``.  To
use it, provide a board name as a command line argument.

It will call 'ftc' to create all of the target package files that it
can (ie that build successfully).

===================
Developer notes
===================

To support this features, a new test execution phase was added to
Fuego.  The new phase is called 'makepkg', and the letter 'm' is used
in the phase string used with the '-p' option to 'ftc run-test'. By
default, the "makepkg" phase is not executed (that is, during a
"normal" run of a test).  This phase must be specifically requested in
order for Fuego to execute it during a test run.

If the 'makepkg' phase is specified, then deploy is altered to put the
materials into the directory ``/fuego-rw/stage/fuego.<testname>``.
Then, after deployment the internal function 'makepkg' is called to
create the target package file.  The file is called
``/fuego-rw/cache/$TOOLCHAIN-$TESTNAME-board-package.tar.gz``.

Outstanding work
=======================

This system captures the materials that would be in
``$BOARD_TESTDIR/fuego.$TESTNAME`` after the deploy phase.  If a
test's 'test_deploy' function manipulates items on the target board
that are outside this directory, those changes will not be captured in
the target package.

For that, we will need to add 2 things:

 - ability to specify multiple target locations for files
 - pre-install and post-install scripts, just like Debian and RedHat packages

Note that by default, the packages are relocatable since they omit the
absolute path in the files contained in them.  They should all be
relative to the ``$BOARD_TESTDIR/fuego.$TESTNAME directory.``
