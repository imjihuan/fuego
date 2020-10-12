

###################
Board Snapshot
###################

Fuego provides a feature to grab a "snapshot" of board status
information and save that along with other data associated with the
run. The idea is that this status information might be helpful for
diagnosing the issue when a problem is encountered during a test
(either test failure or an error during test execution).

This status information is obtained during the ``snapshot`` phase of
test execution.

The default snapshot operation saves a few different key pieces of
information including:
 * the board's "Firmware revision", which is usually the version of
   the kernel running on the board, if the board is running Linux.
 * the shell environment variables (on the host) during test execution
 * the output from :ref:`ov_rootfs_state <function_ov_rootfs_state>`.

Currently (as of Fuego version 1.5), the ``ov_rootfs_state`` function
saves the following data from the board:

 * uptime
 * memory usage
 * disk usage
 * mounted filesystems
 * current user processes
 * interrupts

The board status data is saved in the file: ``machine_snapshot.txt``
in the log directory for a run (under ``/fuego-rw/logs``).


==================================
Overriding snapshot operations
==================================
Saving a snapshot on every test invocation may take too long,
or not be needed.  Therefore, there are multiple ways to customize
the snapshot operation.

 * by omitting the ``snapshot`` phase of test execution
 * by using a test-specific ``test_snapshot`` function
 * by using a board-specific ``ov_rootfs_state`` function

The ``snapshot`` phase of execution is included in the default
list of phases that are executed when a test is run.  That is, it
is "turned on" by default.  But if the phases are manually enumerated,
this phase can be omitted.

The ``snapshot`` phase of test execution is represented by the
character 's'.  To omit the snapshot phase, specify the list of phases
to run (using the '-p' option with ``ftc run-test``), and don't include
's' in the list of phase characters for the run.

To override the operation on a per-test basis, a test can define its
own ``test_snapshot`` function.  If defined, then this function will be
called in place of ``ov_rootfs_state`` in the Fuego core.  For
example, a networking test may want to save information about the
status of networking devices or connections on the systems, rather
than the default snapshot information.

See :ref:`test_snapshot  <function_test_snapshot>` for information about
how to define this function in a ``fuego_test.sh`` script.

To override the operation on a per-board basis, the function
``ov_rootfs_state`` can can be overridden.  This is done by creating a
custom distribution overlay file, and then using the ``DISTRIB``
variable in the board file for a board.  For details about
how to override a distribution function, see :ref:`Adding or
Customizing a Distribution <adding_or_customizing_a_distribution>`
