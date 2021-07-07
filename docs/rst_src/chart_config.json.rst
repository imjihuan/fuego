#####################
chart config.json
#####################

A ``chart_config.json`` file should be defined for each test.  This file
controls what charts are drawn in the Jenkins interface for the test
it is associated with.

==========
Schema
==========

``chart_config.json`` holds a single object, with attributes
describing values for the configuration of the charts for a test.  The
following attributes are supported:

 * **chart_type** - this indicates the type of chart to
   present in the Jenkins interface for a test job

   * It's value must be one of:

     * **measure_plot**
     * **testcase_table**
     * **testset_summary_table**
     * **measure_table**

 * **match_board** - if true, this indicates that a job page in Jenkins
   should only display the results for boards that match the job.

   * By default, Fuego displays the results for all boards on a job page
     for a test.  This is to allow users to compare results between boards.
     However, it is often desirable to only show the data for a single
     board (the one that the job actually refers to).

   * possible values are:

     * **true**
     * **false**

 * **measures** - this is a list of measures for which plots will be drawn

   * Each measure is specified by it's tguid, which must be
     specified in full (see :ref:`Fuego naming rules`)

   * If no measures are listed in the ``chart_config.json`` file,

all the measures produced by the test will be plotted.

The purpose of the "measures" field is to limit the charting to only a
few important, or characteristic, measures.  Some Benchmark tests save
many results, and the user may want to focus on only a few measures
that they are specifically interested in.

Here is an example, from the test Benchmark.cyclictest: ::

  {
      "chart_type": "measure_plot",
      "measures": ["default.latencies.max_latency",
         "default.latencies.avg_latency"]
  }

============
Defaults
============

If a test has no ``chart_config.json``, then default values are used, as
follows:

 * For Benchmark tests, create a measure_plot for all measures found in
   any run of that test.

   * Each measure_plot has one measure, shown with values
     for all boards that have had that test run.
   * The value and reference value (threshold) for each measure are
     plotted relative to each run of the test (by Jenkins build number).

 * For Functional tests, create a testcase table for each board.

   * Each testcase table has the result status for each result, and a
     set of summary lines at the bottom of the table, for each run of
     the test (by Jenkins build number)

 * For ``Functional.LTP``, create a testset_summary_table for each board

   * Summary counts of pass/fail/error/skip status are shown for each
     testset (collection of test cases) for each run.

====================
Planned features
====================

Additional features are planned for future releases of Fuego, including the
following:

 * Additional chart_types:

   * testset_summary_plots - a plot of summary data by test set

 * Control over measure grouping:

   * The ability to place multiple measures in the same plot

 * Control over board grouping:

   * The ability to only show a single board, or specific
     groups of boards, in single plots

 * Control over header data

   * The ability to customize the meta-data placed in table headers

============
See also
============

 * See :ref:`Jenkins Visualization` for more information about the charts
   that are configured by this file.
