################
Fuego charting
################

Fuego has the capability of creating charts (either plots or tables)
from results data.  These charts are used either in the Jenkins
interface, or in reports generation.

This page has a few notes on Fuego's charting features, for users.

Charts are produced during the "processing" phase of test execution.
This is done after the test results have been parsed from the test log
and the results placed in the unified output format (run.json) file.

The chart output for a test is controlled via a file called
``chart_config.json``, which is located in a test's home directory.
If the ``chart_config.json`` file is missing, then Fuego produces a
chart using a default configuration, depending on the type of the
test.  For a Benchmark test Fuego will produce a measure plot by
default, and for a Functional test Fuego will produce a testcase
table.

Use the following resources to find out more about Fuego's charting
features.

References
==========

See :ref:`Jenkins Visualization` for information about the different
charts that are produced by Fuego for the Jenkins interface, and the
relationship between Fuego and Jenkins elements used in results
visualization.

See the documentation for the :ref:`process <parser func process>`
function (which is found in the parser library) for information about
the files used during the ``processing`` phase, and how that relates to
Fuego charting.

Finally, for information about the different chart types and
configuration options for charts supported by Fuego, see
:ref:`chart_config.json <chart config.json>`.
