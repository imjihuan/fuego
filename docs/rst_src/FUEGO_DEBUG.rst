.. _fuego_debug:

###############
FUEGO DEBUG
###############

.. note::
  FUEGO_DEBUG is now deprecated.  Please used the newer
  :ref:`FUEGO_LOGLEVELS  <FUEGO LOGLEVELS>` feature instead of this.
  As of Fuego version 1.4,
  FUEGO_DEBUG is still supported for backwards compatibility.

The environment variable FUEGO_DEBUG is used to control debug output
during execution of a Fuego test.

If this variable is not set, no debugging messages (or less messages)
are produced.

The variable is a bitmask.  If it is defined at all, then the script
system will produce shell trace messages as part of the test log.

The following bitmask values can be used to turn on debugging for
different parts of the system:

 * 1 = debug the main execution of test phases
 * 2 = debug the parser
 * 4 = debug the criteria processor
 * 8 = debug the chart generator code

Combinations are allowed, but must be in decimal.

Example: ::

  export FUEGO_DEBUG=15

This would turn on debug messages for all areas.
