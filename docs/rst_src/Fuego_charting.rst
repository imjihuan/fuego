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

See :ref:`Jenkins Visualization` for information about charts that are
produced for the Jenkins interface.  See :ref:`process <parser func
process>`  and :ref:`chart_config.json <chart config.json>` for information about the variables
and files used for chart creation, and
how they can be customized.
