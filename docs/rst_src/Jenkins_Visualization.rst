#######################
Jenkins Visualization
#######################

Fuego test results are presented in the Jenkins interface via a number
of mechanisms.

===========================
built-in Jenkins status
===========================

Jenkins automatically presents the status of the last few tests (jobs)
that have been executed, on the job page for those jobs.

A list of previous builds of the job are shown in the left-hand pane
of the page for the job, showing colored balls indicating the test
status.

FIXTHIS - add more details here

 * What are the different job statuses

   * Pass, fail, unstable vs. stable
   * What do the colors mean

================
flot plugin
================

The flot plugin for Jenkins provides visualization of Fuego test
results.

In Fuego 1.0 and previous (JTA), this plugin only showed plot data for
Benchmark results.  In Fuego 1.2, all tests have charts presented,
showing recent test results.  For benchmarks, the results are shown as
plots (graphs) of measure data, and for functional tests, tables are
shown with either individual results for each testcase, or summary
data for the testsets in the test.

See :ref:`flot` for more information.

====================
Charting details
====================

Fuego results charts consists of either plots (a graph of results
versus build number) or tables (a table of results versus build
number).

There are 3 different chart output options in Fuego 1.2:

 1) A plot of benchmark measures (called "measure_plot")
 2) A table of testcase results (called "testcase_table")
 3) A table of testcase summary counts per testset (called "testset_summary_table")

A user can control what type of visualization is used for a test using
a file called :ref:`chart_config.json`.  This file is in the test
directory for each individual test.  See the wiki page for that file
for additional details.

Scope of data displayed
============================

The page for a particular job, in Jenkins, shows the data for all of
the specs and boards related to the test. This can be confusing, but
it allows users to compare results between boards, and between
different test specs for the same test.

For example, a job that runs the test Benchmark.bonnie, using the
'default' test spec job (e.g. board1.default.Benchmark.bonnie) shows
results for:

 * Boards: board1, and also other boards
 * Specs: default, noroot
 * Measures: (the ones specified in ``chart_config.json``)

============================
Planned for the future
============================

In future releases of Fuego, additional chart types are envisioned:

A fourth chart type is:

  4) A plot of testcase summary counts per testset (called testset_summary_plot)

=============================
Detailed chart information
=============================

Internally, output (by the :ref:`flot` module) is controlled by a file
called: ``flot_chart_data.json``

Inside that, there is a data structure indicating the configuration
for one or more charts, called the chart_config.  This is placed there
during chart processing, by the results parser system.  A section of
that file, the chart_config element, is a direct copy of the data from
``chart_config.json`` that comes from the test directory for the test.

Information flow
======================

The internal module fuego_parser_results.py is used to generate
results.json.  That module takes the results from multiple run.json
files, and puts it into a single results file.

The internal module ``prepare_chart_data.py`` is used to generate
``flat_plot_data.txt``.  The data in this file is stored as a series of
text lines, one per result for every testcase in every run of the
test.

This file is then used to create a file called: flot_chart_data.json,
which has the data pre-formated as either 'flot' data structures, or
HTML tables.

A file called chart_config.json is used to determine what type of
charts to include in the file, and what data to include.

Here's an ASCII diagram of this flow:

.. note::
   Programs are in rectangles (with '+' corners), and data files are in
   "double-line rounded rectangles" with '/' and '\' corners.

::

  +-------------+    //===========\\    +---------+    //========\\
  |test program | -> ||testlog.txt|| -> |parser.py| -> ||run.json|| ----+
  +-------------+    \\===========//    +---------+    \\========//     |
                                                                        |
    +-------------------------------------------------------------------+
    |
    |   +---------------------+     //==================\\
    +-> |prepare_chart_data.py| <-> ||flat_plot_data.txt||
        +---------------------+     \\==================//
            ^              |
            |              |
  //=================\\    |   //===============================\\    +------+
  ||chart_config.json||    +-> ||  flot_chart_data.json         || -> |mod.js| -> (table or graph)
  \\=================//        ||(HTML table or flot graph data)||    +------+
                               \\===============================//


The flot program mod.js is used to draw the actual plots and tables
based on ``flot_chart_data.json``.  mod.js is included in the web page for
the job view by Jenkins (along with the base flot libraries and jquery
library, which flot uses).

measure_plot
===============

A measure_plot is a graph of measures for a benchmark, with the
following attributes: ::

  title=<test>-<testset>
  X series=build number
  Y1 series=result
  Y1 label=<board>-<spec>-<test>-<kernel>-<tguid>
  Y2 series=ref
  Y2 label=<board>-<spec>-<test>-<kernel>-<tguid>-ref


It plots measures (y) versus build_numbers.

Here's example data for this: ::

 "charts": [
    {  # definition of chart 1
      "title": "Benchmark.fuego_check_plots-main.shell_random"
      "chart": {
         "chart_type": "measure_plot",
         "data": [
           {
              "label": "min1-default_spec-Benchmark.fuego_check_plots-v4.4-main.shell_random",
              "data": [ ["1","1006"],["2","1116"] ],
              "points": {"symbol": "circle"}
           },
           {
              "label": "min1-default_spec-Benchmark.fuego_check_plots-v4.4-main.shell_random-ref",
              "data": [ ["1","800"],["2","800"] ],
              "points": ["symbol":"cross"}
           }
         ]
         # note: could put flot config object here
      }
  }
 ]


FIXTHIS - add testset, and draw one plot per testset.

measure_table
===================

A measure_table is a table of test spec with the following attributes:

 * row=(one per line with matching testspec/build-number in flat_chart_data.txt)
 * columns=test set, build_number, testcase value, testcase ref value, testcase
   result(PASS/FAIL), duration
 * Sort rows by testspec, then by build_number

Here was the format of the first attempt: ::

  title=<board>-<test>-<spec> (kernel)
  headers:
     board:
     kernel(s):
     test spec:
  ---------------------------------------------------------------
                            |    build number
  measure items  | test set |   b1   |   b2   |   b3   |   bN   |
  X1             |  <ts1>   | value1 | value2 | value3 | valueN |
  X1(ref)        |  <ts1>   | ref(X1)| ref(X1)| ref(X1)| ref(X1)|
  <bn>           |  <ts2>   |                ...
    (row-span    |  <ts2>   |                ...
  as appropriate)|  <ts3>   |                ...
  <b2n>          |  <ts3>   |                ...


And, 'valueN' is displayed in a correct color, e.g. GREEN if value1 is
in the expectation interval specified by 'ref', otherwise in RED, so
that we can display more info in a chart.

testcase_table
====================

A testcase_table is a table of testcases (usually for a functional
test), with the following attributes: ::

  title=<board>-<spec>-<test>-<kernel>-<tguid>
  headers:
     board:
     test:
     kernel:
     tguid:
  row=(one per line with matching tguid in flat_chart_data.txt)
  columns=build_number, start_time/timestamp, duration, result


It shows testcase results by build_id (runs).

Daniel's table has: ::

  overall title=<test>
    chart title=<board>-<spec>-<testset>-<testcase>
    headers:
       board:
       kernel_version:
       test_spec:
       test_case:
       test_plan:
       test_set:
       toolchain:
   build number | status | start_time | duration


Cai's table has: ::

   overall title=<test>
   summary:
      latest total:
      latest pass:
      latest fail
      latest untest:
   table:
   "no" | <test-name>  | test time |
                               | start-time |
                               | end-time |
                               | board version |
                               | test dir |
                               | test device |
                               | filesystem |
                               | command line |
   --------------------------------------------
   testcase number | testcase     | result |


This shows the result of only one run (the latest)

Tim's testcase table has:
(one table per board-testname-testset) ::

   overall title=<test>
   header:
     board
     kernel version
     spec?
     filesystem
     test directory?
     command line?
   --------------------------------------------
   tguid | results
         | build_number |
         | b1 | b2 | bn |
   <tguid1>|result1|result2|resultn|
        totals
   pass: |    |    |    |
   fail: |    |    |    |
   skip: |    |    |    |
   error:|    |    |    |
   --------------------------------------------

testset_summary_table
==========================

A testset_summary_table is a table of testsets (usually for a complex
functional test) with the following attributes:

 * row=(one per line with matching testset/build-number in flat_chart_data.txt)
 * columns=test set, build_number, start_time/timestamp, testset pass count, testset fail count, duration
 * Sort rows by testset, then by build_number

::

  title=<board>
  headers:
     board:
     kernel(s):
  -----------------------------------------------------
                            |    counts
  build number   | test set | pass | fail| skip | err |
  <bn>           |  <ts1>   |
    (row-span    |  <ts2>   |
  as appropriate)|  <ts3>   |
  <b2n>          |  <ts1>   |
                 |  <ts2>   |


Here was the format of the first attempt: ::

  title=<board>-<spec>-<test>-<kernel>
  headers:
     board:
     test:
     kernel:
  -------------------------------------------------------------------------
                                                |    counts
  testset | build_number | start time| duration | pass | fail| skip | err |
  <ts>    | ...|


It shows testset summary results by runs

Here's an alternate testset summary arrangement, that I'm not using at
the moment: ::

   --------------------------------------------
   testset | results
           | b1                      | b2    | bn    |
           | pass | fail | skip | err |p|f|s|e|p|f|s|e|
   <ts>    | <cnt>| <cnt>| <cnt>| <cnt>...            |
        totals
   --------------------------------------------



testset_summary_plot
==========================

A testset_summary_plot is a graph of testsets (usually for a complex
functional test) with the following attributes: ::

  title=<board>-<spec>-<test>-<kernel>
  X series=build number
  Y1 series=pass_count
  Y1 label=<board>-<spec>-<test>-<kernel>-<testset>-pass
  Y2 series=fail_count
  Y2 label=<board>-<spec>-<test>-<kernel>-<testset>-fail


It graphs testset summary results versus build_ids

structure of chart_data.json
==================================

Here's an example: ::

 {
  "chart_config": {
     "type": "measure_plot"
     "title:": "min1-Benchmark.fuego_check_plots-default"
     "chart_data": {
        data
 }


Feature deferred to a future release
========================================

 * Ability to specify the axes for plots
 * Ability to specify multiple charts in chart_config

  * Current Daniel code tries to automatically do this based on test_sets

========================================
Architecture for generic charting
========================================

Assuming you have a flat list of entries with attributes for
board, testname, spec, tguid, result, etc., then you can use treat this like
a sql database, and do the following:

 * Make a list of charts to build

   * Have a chart-loopover-key = type of data to use for loop over charts
   * Or, specify a list of charts

 * Define a key to use to extract data for a chart (the chart-key)
 * For each chart:

   * Make a list of rows to build

     * Have a row-loopover-key = filter for rows to include
     * Or, specify a list of rows

   * Define a key to use to extract data for each row
   * If sub-columns are defined:

     * Make a sub-column-key
     * Make a two-dimensional array to hold the sub-column data

   * For each entry:

     * Add the entry to the correct row and sub-column

   * Sort by the desired column
   * Output the data in table format

     * Loop over rows in sort order
     * Generate the html for each row

       * Loop over sub-columns, if defined

   * Return html

There's a similar set of data (keys, looping) for defining plot data.
With keys selecting the axes.
