##################
parser.py
##################

===========
PROGRAM
===========

``parser.py``

===============
DESCRIPTION
===============

``parser.py`` is a Python program that is used by each test to parse the
test log for a test run, check the threshold(s) for success or
failure, and store the data used to generate charts.

Each benchmark should include an executable file called 'parser.py' in
the test directory (/fuego-core/engine/tests/Benchmark.<testname>).
Functional tests may also provide a ``parser.py``, when they return more
than a single testcase result from the test.  However, this is
optional.  If a Functional test does not have a parser.py script, then
a generic one is used (called ``generic_parser.py``), that just sets the
result for the test based on the return code from the test program and
the single result from running executing
function_log_compare in the function_test_processing portion of the test
script.

The test log for the current run is parsed by parser.py, and one or
more testcase results (measures or pass/fail results) are extracted,
and then provided via a dictionary to the results processing engine.
Normally this is done by scanning the log using simple regular
expressions. However, since this is a python program, an arbitrarily
complex parser can be written to extract result data from the test
log.

Outline
=============

The program usually has the following steps:

 * Import the parser library
 * Specify a search pattern for finding one or more measurements (or
   testcases) from the test log
 * Call the parser_func_parse_log function, to get a list of
   matches for the search pattern
 * Build a dictionary of result values
 * Call the parser_func_process function, to save the information
   to the aggregate results files, and to re-generate the chart data for the test

   * The process() function evaluates the results from the test, and determines
     the overall pass/fail status of a test, based on a :ref:`criteria.json` file


Testcase and measure names
==============================

The parser.py program provides the name for the measures and testcases
read from the test log file.  It also provides the result values for
these items, and passes the parsed data values to the processing
routine.

These test names must be consistent in the parser.py program,
reference.json file and the criteria.json file.

Please see :ref:`Fuego naming rules` for rules and guidelines
for test names in the Fuego system.


===========
SAMPLES
===========

Here is a sample ``parser.py`` that does simple processing of a single
metric.  This is for Benchmark.Dhrystone.

Note the two calls to parser library functions: parse_log() and process().

::

  #!/usr/bin/python

  import os, re, sys

  sys.path.insert(0, os.environ['FUEGO_CORE'] + '/engine/scripts/parser')
  import common as plib

  regex_string = "^(Dhrystones.per.Second:)(\ *)([\d]{1,8}.?[\d]{1,3})(.*)$"

  measurements = {}
  matches = plib.parse_log(regex_string)

  if matches:
      measurements['default.Dhrystone'] = [{"name": "Score", "measure" : float(matches[0][2])}]

  sys.exit(plib.process(measurements))



=============================
ENVIRONMENT and ARGUMENTS
=============================

``parser.py`` uses the following environment variable:

 * FUEGO_CORE

This is used to add ``/fuego-core/engine/scripts/parser`` to the python
system path, for importing the ``common.py`` module (usually as
internal module name 'plib').

The parser library expects the following environment variables to be set:

 * ``FUEGO_RW``
 * ``FUEGO_RO``
 * ``FUEGO_CORE``
 * ``NODE_NAME``
 * ``TESTDIR``
 * ``TESTSPEC``
 * ``BUILD_NUMBER``
 * ``BUILD_ID``
 * ``BUILD_TIMESTAMP``
 * ``PLATFORM``
 * ``FWVER``
 * ``LOGDIR``
 * ``FUEGO_START_TIME``
 * ``FUEGO_HOST``
 * ``Reboot``
 * ``Rebuild``
 * ``Target_PreCleanup``
 * ``WORKSPACE``
 * ``JOB_NAME``

``parser.py`` is called with the following invocation, from
function_processing:

::

  run_python $PYTHON_ARGS $FUEGO_CORE/engine/tests/${TESTDIR}/parser.py



============
SOURCE
============

Located in ``fuego-core/engine/tests/$TESTDIR/parser.py``.

=============
SEE ALSO
=============

 * parser_func_parse_log, parser_func_process
 * function_processing, :ref:`Parser module API`, Benchmark_parser_notes.
