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
its test home directory
(``/fuego-core/tests/Benchmark.<testname>``).  Functional tests
may also provide a ``parser.py``, when they return more than a single
testcase result from the test.  However, this is optional.  If a
Functional test does not have a ``parser.py`` script, then a generic one
is used (called ``generic_parser.py``), that just sets the result for
the test based on the return code from the test program and the single
result from running ``log_compare`` in the ``test_processing`` portion
of the test script.

The overall operation of ``parser.py`` is as follows: ``parser.py``
reads the test log for the current run and parses it, extracting one or
more testcase or measure results.  These are stored in a python
dictionary which is passed to the results processing engine.  Normally
the parsing is done by scanning the log using simple regular
expressions. However, since this is a python program, an arbitrarily
complex parser can be written to extract the result data from the test
log.

Outline
=============

The program usually has the following steps:

 * Import the parser library
 * Specify a search pattern for finding one or more measurements (or
   testcases) from the test log
 * Call the ``parse_log`` function, to get a list of
   matches for the search pattern
 * Build a dictionary of result values
 * Call the ``process`` function.

   * The ``process`` function evaluates the results from the test, and
     determines the overall pass/fail status of a test, based on a
     :ref:`criteria.json` file
   * The ``process`` function also saves the information
     to the aggregate results file for this test (``flat_plot_data.txt``),
     and re-generates the chart data for the test
     (``flot_chart_data.json``).


Testcase and measure names
==============================

The ``parser.py`` program provides the name for the measures and
testcases read from the test log file.  It also provides the result
values for these items, and passes the parsed data values to the
processing routine.

These test names must be consistent in the ``parser.py`` program,
``reference.json`` file and the ``criteria.json`` file.

Please see :ref:`Fuego naming rules` for rules and guidelines
for test names in the Fuego system.


===========
SAMPLES
===========

Here is a sample ``parser.py`` that does simple processing of a single
metric.  This is for ``Benchmark.Dhrystone``.

Note the two calls to parser library functions: ``parse_log()`` and
``process()``.

::

  #!/usr/bin/python

  import os, re, sys

  sys.path.insert(0, os.environ['FUEGO_CORE'] + '/scripts/parser')
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

 * ``FUEGO_CORE``

This is used to add ``/fuego-core/scripts/parser`` to the python
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

  run_python $PYTHON_ARGS $FUEGO_CORE/tests/${TESTDIR}/parser.py



============
SOURCE
============

Located in ``fuego-core/tests/$TESTDIR/parser.py``.

=============
SEE ALSO
=============

 * :ref:`parser_func_parse_log`, :ref:`parser_func_process`
 * function_processing, :ref:`Parser module API`, Benchmark_parser_notes.
