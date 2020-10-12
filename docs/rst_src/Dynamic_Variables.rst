

###########################
Dynamic Variables
###########################

"Dynamic variables" in Fuego are variables that can be passed to a
test on the command line, and used to customize the operation of a
test, for a particular test run.

In general testing nomenclature this is referred to as test
parameterization.

The purpose of dynamic variables is to support "variant" testing,
where a script can loop over a test multiple times, changing the
variable to different values.

In Fuego, during test execution dynamic variable names are expanded to
full variables names that are prefixed with the name of the test.  A
dynamic variable overrides a spec variable of the same name.

Here is an example of using dynamic variables: ::

  $ ftc run-test -b beaglebone -t Benchmark.Dhrystone --dynamic-vars "LOOPS=100000000"


This would override the default value for BENCHMARK_DHRYSTONE_LOOPS,
setting it to 100000000 (100 million) for this run.  Normally, the
default spec for Benchmark.Dhrystones specifies a value of 10000000
(10 million) for LOOPS.

This feature is intended to be useful for (among other things) doing
'git bisect's of a bug, passing a different git commit id for each
iteration of the test.

See :ref:`Test_variables <Test variables>` for more information.

Notes
==========

Note that dynamic vars are added to the runtime ``spec.json`` file, which
is saved in the log directory for the run being executed.

This ``spec.json`` file is copied from the one specified for the run
(usually from the test's home directory).

If dynamic variables have been defined for a test, then they are
listed by name in the run-specific ``spec.json`` file, as the value of the
variable "dyn_vars".  The reason for this is to allow someone who
reviews the test results later to easily see whether a particular test
variable had a value that derived from the spec, or from a dynamic
variable.  This is important for proper results interpretation.
