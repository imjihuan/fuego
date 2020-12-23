#########################
Test Functional.crashme
#########################

This test runs the crashme program.

You can find information about crashme here:
`<http://www.linuxcertif.com/man/1/crashme/>`_

crashme creates some random data, and tries to execute it to see if
the system or environment will crash.

============
Details
============

This test unpacks a tarball called: crashme_2.4.tar.bz2 and deploys a
single binary file (crashme) to the target.

The test spec for this defines the following variables:

 * NBYTES: 1000
 * INC: 1000
 * SRAND: 2
 * NTRYS: 100
 * NSUB: 3000

These are passed to crashme as follows:

 * crashme NBYTES.INC SRAND NTRYS NSUB 2

The final 2 in the command line is the verbosity level.

The tests checks for the string "0 ...  3000" occuring once in the log
output.

