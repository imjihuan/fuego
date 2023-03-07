.. _genreports:

##################
Generating Reports
##################

The Fuego system includes the capability to generate reports
of test results, providing a number of options to control the
content, format and location of reports.

=================
ftc gen-report
=================

[ FIXTHIS - Rework all of this, and add details]

Another command which may be quite important is ``ftc gen-report``.
Usually, test results are examined in the :ref:`Jenkins User interface`.
However, you can also generate lists of results at the command line
using ``ftc gen-report``

This command gives you control over the results that are reported,
as well as the content (exact fields and headers) and format of the
report.

In summary, ``ftc gen-report`` can:

 * select the test runs to report results from
 * select the header fields to show in the report
 * select the data (result) fields to show in the report
 * filter the data by results (for example showing only failures)
 * select the format of the report

Selecting test runs to include in the report
============================================

 * using "where" clauses

   * selecting by board, test, spec, batch_id, build_number

 * how to specify starttimes:
   * recent tests
   * tests in a particular date range

:: note: Some nuances about specifying dates and times

 * selecting by recent tests:
   * highest build number
   * tests within the last 24 hours

Selecting data elements to include in the report
================================================

 * --header-fields option
 * --fields option

Filtering the data by results
=============================
 * using where clauses to filter by tguid and tguid:result

 * showing anything that is NOT success
 * showing only failures


Specifying the format and location for the report
=================================================

 * --format option
 * -o option

