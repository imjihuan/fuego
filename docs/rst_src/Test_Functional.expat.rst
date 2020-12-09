######################
Test Functional.expat
######################

This test conducts a test of XML processing performed by the
libexpat.so library.  Specifically, it runs the xmlts (XML Test Suite)
to test the library.

You can find information about crashme here:
`<http://www.linuxcertif.com/man/1/crashme/>`_

crashme creates some random data, and tries to execute it to see if
the system or environment will crash.

============
Details
============

This test unpacks a tarball called: expat-2.0.0.tar.gz and applies a
patch ``xmltest.sh.patch``, which adds pass/fail strings to the test
results.

The build phase also untars and build the xml test suite (from
xmlts20080827.tar.gz)

For the deploy phase, the test suite is tarred up, put on the target,
and extracted there.  Also the file xmlwf is put on the target.

For the actual test, a program called 'runtestspp is run, as well a
program called ``xmltest.sh``.


The test_processing phase checks for ``EXPAT_SUBTEST_COUNT_POS`` and
``EXPAT_SUBTEST_COUNT_NEG``.  The positive test looks for the string
"100%%: Checks: 48|passed".  (This is a bit of a weird string to check
for multiple times.)

