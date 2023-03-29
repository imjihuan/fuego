.. _genreports:

##################
Generating Reports
##################

Usually, test results from Fuego tests are examined in the
:doc:`Jenkins User interface`.
However, Fuego also provides the capability to generate reports
outside of Jenkins.

A report consists of data from one or more test runs, collected
and presented in the report in an organized fashion.
The Fuego system includes the capability to generate lists of
test results, providing a number of options to control the content,
format, and location of reports.

The command used to generate reports in Fuego is ``ftc gen-report``

=================
ftc gen-report
=================
The ``ftc gen-report`` command gives you control over the results
that are reported, as well as the content (exact fields and headers)
and format of the report.

Using ``ftc gen-report``, you can:

 * select the test runs from which to report results
 * select the header fields to show in the report
 * select the data fields to show in the report
 * filter the data by results (for example to show only failures)
 * select the format of the report
 * select the location for the report output file

Overall command usage
=====================
To generate a report, you use ``ftc gen-report`` and use
command line options to control the data and format of
the report.

The overall command usage is: ::

  ftc gen-report [filter-options] [field-options] [format-option]

The online command usage (obtainable with ``ftc gen-report help``
is shown in the section `ftc gen-report usage help`_ below).

Details about the options for generating reports is shown in
the following sections.

Selecting data elements to include in the report
================================================
A report consists of data from one or more test runs, collected
and presented in the report.

Each report has a header section and a body section.

Header section
--------------
The fields in the header section are meta-data about the tests
included in the report, such as the set of test names, boards
that the tests were run on, the kernel versions tested, the start_time
of the tests, and the date that the report was generated.

You can control which fields are shown in the header section of
the report, using the ``--header-fields`` option.

The list of header fields available is:

 * test
 * board
 * kernel
 * timestamp
 * report_date

Header fields that have multiple values will be shown as a comma-separated
list (like the board names), or as a range of values with a start and end
(e.g. for the timestamp field).

If no ``--header-fields`` option is used, then the default
set of header fields displayed in the header section of the
resport (and their field order), is: ::

  test,board,kernel,timestamp,report_date


Data section
------------
The data section of the report has data about test results for the
selected runs.  This includes information such as the test names, board,
testcase names, and results.

The data in the report is obtained from a set of test runs that
are selected for the report (see below).  The data consists
of information about the test run (including, importantly, the
status of each test), and can also contain detailed
information about individual testcase results.

You can control which fields are shown (and the order they
are shown in) in the data section of
the report, using the ``--fields`` option.

The list of fields available for inclusion in the report is:

 * test_name - full test name
 * test - short test name
 * spec - test spec used for the run
 * board - board that test ran on
 * kernel - kernel that test ran on
 * timestamp - time and date of test start
 * start_time - test start time (in seconds since the epoch)
 * tguid - test case identifier
 * tguid:result - test case result
 * status - test result (the summary result for the whole test, after
   the test criteria is applied)
 * duration_ms - the duration of the test in milliseconds

The order of the fields in each report line corresponds to the order
in which the fields are specified as arguments to the ``--fields``
option.  If no ``--fields`` option is used, then the default
set of fields (and their order), is: ::

  test_name,spec,board,timestamp,tguid,tguid:result

Difference between 'status' and 'tguid:result'
----------------------------------------------
For each test displayed in the report, the test's status
may be shown.  The 'status' field for a test run is the
overall result of the entire test.  Only one of these is
shown per test run.

Depending on the fields displayed in the report, a report
may also display individual testcase names and results.
In the report generator, a testcase name is called a 'tguid'.
This stands for "testcase globally unique identifier".  Each
tguid consists of a string containing one or more elements
indicating the test suite name, test set name, test case name and
measurement name (in the case of benchmark measurement results)

The result for each test case is one of PASS, FAIL, SKIP or ERROR.
The result for a measurement is always a number.

An example of a tguid for a measurement is: ::

  IOzone.2048_Kb_Record_Write.Random_write.Score

The associated tguid for this particular test case is: ::

  IOzone.2048_Kb_Record_Write.Random_write

These indicate that this test case and measurement are for the
IOzone test suite, the 2048_KB_Record_Write test set, and
the Random_write test case within that set.  The actual
benchmark measurement for this test case is named its
'Score' by this test.

A single Fuego test will only have a single 'status', but may
have multiple test cases (tguid) that can appear in a report.


Selecting data to include in the report
============================================
You can filter the set of runs (and test cases within those runs) to
include in the report by using the ``--where`` option.  The string
following the the ``--where`` option is called a "where clause".  It is
used to specify a condition that must be met for a run (or a piece of
test result data) to be included in the report.  This is similar in
functionality to the WHERE used in the SQL database query language, but
with different syntax.

Multiple where clauses can be specified for a single report,
either as a comma-separated list following a single
``--where`` option, or via separate ``--where`` options.
(See below for some examples.)

Where clauses are used to select the data that will be included in the
report.  This includes filtering the set of runs whose data will be
included, as well as individual testcase items or results that will be
included.  For example, you can use a where clause to select test runs
by board name, test name, or the 'spec' that was used for a run.  You
can also use where clauses to select tests by start time, batch_id, or
build_number.  You can filter by the result for a full test (known as
it's "status"), as well as filter the data from each test by individaul
testcase names, and testcase results (both strings and numbers).

In order for an element to be included in the report (a run or a
result), it must match all specified where clauses.  That is,
the filter is an ``AND`` operation between all the where clauses that
are specified.

where clause syntax
-------------------
A single 'where clause' consists of a field_name, an operator, and a value,
like this: ::

   board=beaglebone

Allowed field names are:

 * **test** - the full or shortened test name
 * **type** - the test type (value may be either "Functional" or "Benchmark")
 * **spec** - the variant or 'spec' used for the run
 * **board** - the board
 * **start_time** - the time when the test was started
 * **batch_id** - a batch id string for the run
 * **status** - the overall result of a test run
 * **build_number** - the build number for the run
 * **tguid** - an individual testcase identifier (globally unique id)
 * **tguid:result** - an individual testcase result

Allowed operators are:

 * '**=**' - the field has a value equal to the specified value
 * '**<**' - the field has a value less than the specified value
 * '**<=**' - the field has a value less than or equal to the specified value
 * '**>**' - the field has a value greater than the specified value
 * '**>=**' - the field has a value greather than or equal to the specified value
 * '**!=**' - the field has a valud that is not equal to the specified value
 * '**=~**' - the field has a value that matches the specified regular expression

The '=~' (match) operator is used with a regular expression
that the field value must match, in order for
the run (or data element) to be included in the report.
The regular expression is expressed in python 're' syntax.
See https://docs.python.org/2/library/re.html#regular-expression-syntax
for information about the regular expression syntax supported
with the '=~' (match) operator.

Here are some example where clauses: ::

  example 1: --where test=LTP

  example 2: --where board=beaglebone,test=bonnie

  example 3: --where board=beaglebone --where test=bonnie

  example 4: --where "start_time>2 hours ago"

  example 5: --where batch_id=12

  example 6: --where "tguid=~.*udp.*"

  example 7: --where tguid:result=FAIL

  example 8: --where test=fio,"tguid:result>10000"


Here are descriptions of these examples:

 * example 1 says to generate a report of LTP test runs
 * example 2 says to show test results for the 'bonnie' test on the
   'beaglebone' board
 * example 3 says the same thing as example 2.
   Examples 2 and 3 are different ways of expressing
   multiple where clauses for a single report generation command.
   Their effect is identical.
 * example 4 says to show tests started in the last 2 hours
 * example 5 says to show tests with batch_id=12
 * example 6 says to show tests results where the testcase identifier
   includes the string 'udp'
 * example 7 says to show test results that failed.
 * example 8 says to show test results for the 'fio' test, where the
   benchmark result was greater than 10,000.

Here are some additional tips for specifying where clauses:

  * When using a where clause that has spaces, enclose the value, or the whole
    expression in quotes, to avoid the shell splitting the command line
    argument
  * When using '>' or '<', enclose the expression in quotes, to avoid
    the shell interpreting the comparison operators as output or input
    redirection, respectively
  * When using shell wildcard characters (such as '*' or '?') in a '=~' regular
    expression, enclose the expression in quotes, to avoid
    the shell interpreting the wilcards as file-matching strings.

start_time tricks
------------------
It can be a bit tricky to specify the right start_time for the where
clause. Say, for example, you want to get the report for tests within
the last few hours.  This is possible;  
the parsing for start_time in the where clause is flexible. But it may
be confusing.

In general, Fuego supports specifying the start_time
value in a where clause using English strings that specify absolute
or relative time.  For example, the following strings are supported:

 * --where "start_time>2023-02-24 10:15"
 * --where "start_time>today at 10:00"
 * --where "start_time>oct 1 2022"
 * --where "start_time>1 hour ago"

The last of these examples uses a phrase that has relative time sense.
That is, the time is expressed relative to the time of invocation of
the ``ftc``.

In Fuego, start_time comparison operations are in absolute time sense,
not in relative time sense, even if the time value is
expressed using relative wording.  Thus ::

  --where "start_time>1 hour ago"

will include tests started "within the last hour". That is: show tests with a
start_time time that has a value greater than the time 1 hour
before the ``ftc gen-report`` command was run).

The where clause: ::

  --where "start_time>2023-02-24 00:01"

means include tests with a start time after 12:01 am Feb 24, 2023.

As a help, if you use the ``-v`` option with ``ftc gen-report``,
Fuego  will tell you in human-readable form what the start_time
value is that Fuego interpreted for your where clause.

Here's an example: ::

  $ ftc -v gen-report --where "start_time>last year"
  start_time value in 'where' is '2022-01-01 09:00:00.000002'
  ======================================================================
           **** Fuego Test Report ****
  ...


Using batch_id to group runs for a report
------------------------------------------
Another way to group test runs for a report is by using a 'batch_id'.

When you run a batch test in Fuego, all the individual tests in the
batch are assigned the same ``batch_id``.  This batch id is printed
during the test run, or you can use ``ftc gen-report`` with the
``--fields`` option to see the batch-id for any test or set of tests.

Using a 'batch-id' makes it easy to generate a report for a
collection of tests, by using a where clause that specifies the batch_id.

Even if you are not using a Fuego batch test (where a batch_id
is assigned automatically), you can manually assign
a batch-id to a collection of tests, by setting the variable
``FUEGO_BATCH_ID`` to some unique string, before executing the
``ftc run-test`` command line, for a set of tests.

Here is an example of using a custom 'batch_id' for a collection
of tests, to enable generating a report for that collection
of test runs: ::

  export FUEGO_BATCH_ID=CI-loop-26
  ftc run-test -b beaglebone,minnowboard -t fuego_board_check
  ...
  ftc run-test -b beaglebone,raspberry-pi -t fio
  ...
  ftc run-test -b minnowboard -t cyclictest
  ...

  ftc gen-report --where batch_id=CI-loop-26
  ...


Filtering the data by results
------------------------------
You can also filter the data for a test report by
specifyihg where clauses that specify matches or comparisons for
test results (status), individual testcase results
or Benchmark test measurement results.

A common report filter is one where only errors, skips and failures
are reported, and PASS results are ignored (that is, omitted from
the report).  This can be done by filtering on the field 'tguid:result'

Here is an example: ::

  ftc gen-report --where "start_time>last week" --where tguid:result!=PASS

This would generate a report with a list of all failing tests and
testcase results, in the last week.

If you are not interested in ERROR or SKIP results, you might use
a more specific result filter, looking only at FAIL results. ::

  ftc gen-report --where "start_time>last week" --where tguid:result=FAIL

Or, you might only want a summary of tests
that failed in the last week, ignoring individual testcase results
within those tests.  To do that, you need to specify a custom
field list that does not include ``tguid:result``::

  ftc gen-report --where "start_time>last week" --where status=FAIL \
    --fields test,spec,board,build_number,timestamp,status


Specifying the format and location for the report
=================================================
Fuego supports outputting the report data in a few different formats.

By default, the report is output in text format, to the stdout
of the 'ftc' command.  To specify a different
format for the report, use the ``--format`` option.

The following ouput formats are supported:

 * **txt** - plain text
 * **html** - HTML format
 * **rst** - reStructured text
 * **pdf** - PDF file format
 * **excel** - Excel spreadsheet format
 * **csv** - comma separated values
 
The default format, if none is specified with the ``--format`` option,
is 'txt' (plain text).

Each of the other formats are well-known document formats.

Extra text report format options
---------------------------------
A few extra options are available to control the formatting of
the output, when using the 'txt' output format.

  * *-f* -  use fixed column widths in the text output format
  * *-q* -  quiet mode: omit the header section and headings in text output format

By default, when outputting data in the text output format, Fuego will
automatically adjust the column widths according to the sizes of the
strings in that column.  However, it may be desirable to present the values
at fixed offsets in each line, so that the data may be more easily
parsed by other tools.  To use a fixed width of 20 characters for each
column (starting at 2nd character of each line), use the '-f' option.
Here is an example of report output, without the '-f': ::

  $ ftc gen-report --where board=bbb,test=bc,build_number=1
  ======================================================================
           **** Fuego Test Report ****
  test                : bc
  board               : bbb
  kernel              : 4.4.155-ti-r155
  timestamp           : 2022-03-09_19:07:49
  report_date         : 2023-03-15_03:12:19
  ======================================================================
  ---------------------------------------------------------------------
    test_name     spec    board timestamp           tguid tguid:result 
  ---------------------------------------------------------------------
    Functional.bc default bbb   2022-03-09_19:07:49 bc    PASS         
  ---------------------------------------------------------------------

And here is an example of same report, *with* the '-f' option: ::

  $ ftc gen-report -f --where board=beaglebone,test=bc,build_number=1
  ======================================================================
           **** Fuego Test Report ****
  test                : bc
  board               : bbb
  kernel              : 4.4.155-ti-r155
  timestamp           : 2022-03-09_19:07:49
  report_date         : 2023-03-15_03:12:04
  ======================================================================
  --------------------------------------------------------------------------------------------------------------------------------
    test_name            spec                 board                timestamp            tguid                tguid:result
  --------------------------------------------------------------------------------------------------------------------------------
    Functional.bc        default              bbb                  2022-03-09_19:07:49  bc                   PASS
  --------------------------------------------------------------------------------------------------------------------------------


You can get more concise output, in text mode, using the '-q' option.

When you use '-q' with ``ftc gen-report`` and you are in text mode, only
the data section of the report is shown.  The header section is omitted,
and the heading for the rows of data are also omitted.  Only the fields
for each line of data in the report are printed.  Also, the
report data starts in column 0, instead of column 2. (That is, the
report data is not indented by 2 spaces).

The purpose of 'quiet mode' (the '-q' option) in report generation
is to allow you to extract data from the Fuego test results, in a
format that can easily be parsed by other tools.

Here is an example: ::

  $ ftc gen-report -q --where board=beaglebone,build_number=1,tguid=Read.Seq.speed \
     --fields tguid:result
  21457.00


Output location
----------------
Fuego can output report data to stdout (the output of the ``ftc`` command),
or save the data to a file.  The filename for a report sent to a file
follows the pattern: "Test_report_<date_and_time>.<ext>".

The default output location depends on the format used for the report.
The output directory can be changed using the ``-o`` option.

Here is the default output location for the different output format types:

 * txt - output to stdout
 * html - output to stdout
 * rst - output to stdout
 * csv - output to /fuego-rw/reports/Test_report_<date-and-time>.csv
 * excel - output to /fuego-rw/reports/Test_report_<date-and-time>.xls
 * pdf - output to /fuego-rw/reports/Test_report_<date_and_time>.pdf

The 'txt', 'html' and 'rst' formats are output to stdout, unless a
report directory is specified (using the ``-o`` option).
The 'csv', 'excel', and 'pdf' formats are
written to a file in the Fuego reports directory.  By default the
report directory is ``/fuego-rw/reports``, inside the docker container.
This directory is visible on the host in the ``fuego-rw/reports``
directory where you installed Fuego.

You can use "-o -" to use the default report directory for 'txt',
'html' and 'rst' formats.  Instead of writing the report to stdout,
the Fuego will write reports using these formats
to ``fuego-rw/reports``, using the standard report filename and
an appropriate filename extension.

.. important:: When using a Fuego container, the report directory
   that is used with the ``ftc gen-report`` command will be relative
   to the root of the container, not the host filesystem.  That is,
   if you run: ``ftc gen-report -o /tmp``, from outside the container,
   the report file will be placed in the ``/tmp`` directory inside
   the container, *NOT* the ``/tmp`` directory  on the host.

   This may cause confusion.  When the Fuego reports directory
   (``fuego-rw/reports``) is used, this distinction is not a problem
   since the fuego-rw directory is visible in both the container and the
   host.


===========================
ftc gen-report usage help
===========================
Here is output generated when you type ``ftc gen-report help``: ::

  ftc gen-report: Generate a report from a set of runs

  Usage: ftc gen-report [--where <where-clause1>[,<where_clausen>]...] \
            [-f] [-q]
            [--format [txt|html|pdf|excel|csv|rst]] \
            [--header_fields <field_list>] \
            [--fields <field_list>] \
            [--layout <report_name>]
            [-o <report_dir>]

  Generates a report from test run data as specified.  The where option
  controls which runs are included in the report.  The format option controls
  the text encoding of the report, and the layout specifies a report style.
  If no arguments are provided, the defaults of "all tests", "txt" output,
  and a layout consisting of summary results is used.

  -f   use fixed column widths in the text output format
  -q   omit table header and column headings in text output format

  txt, html and rst formats are output to stdout, unless a report dir is
  specified.  pdf, excel and csv formats are written to a file in the
  report diretory.  By default the report directory is /fuego-rw/reports,
  but this can be overridden with the -o option. Use "-o -" to use the
  default report directory for txt, html and rst formats.

  The --where option can be used to specify one or more 'where' specifiers
  to filter the list of runs. Each where clause is separated by a comma.
  A 'where clause' consists of a field_name, an operator and a value.
  Allowed field names are: test, type, spec, board, start_time, result,
  batch_id, status, build_number, tguid, and tguid:result.
  Allowed operators are: '=','<','<=','>','>=','!=','=~'.  The '=~' operator
  means the value is a regular expression to match, for the indicated field.
  Here are some example where options:
     --where test=LTP
     --where test=bonnie,board=beaglebone
     --where "start_time>2 hours ago"
     --where batch_id=12
     --where tguid=~.*udp.*
     --where tguid:result=FAIL

  The --header_fields and --fields options allow specifying a list of
  field names (comma-separated) for inclusion in the header and body
  of the report, respectively.  The default field lists, if none are
  specified are: (for headers) test,board,kernel,timestamp,report_date
  and (for fields) test_name,spec,board,timestamp,tguid,tguid:result.

  Here is an example:
    ftc gen-report --header_fields test --fields timestamp,tguid,tguid:result

