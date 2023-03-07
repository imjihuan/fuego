.. _cmd:

========
cmd
========

NAME
========

cmd

SYNOPSIS
============

 * cmd <command and args>

DESCRIPTION
===============
The 'cmd' function is used to execute a command on the board.

It is important to quote arguments with spaces, so that they don't get separated
during execution.

It adds a statement to the devlog, and then calls ov_transport_cmd.
It's basically a simple wrapper around that function.


EXAMPLES
============

Here is an example ::

  cmd "echo 'this echo is on the target'; uptime; $BOARD_TESTDIR/fuego.$TESTDIR/some_program"

ENVIRONMENT and ARGUMENTS
=============================
The arguments are passed unchanged to ov_transport_cmd.

RETURN
==========
Returns non-zero on error

SOURCE
==========
Located in ''scripts/functions.sh''

SEE ALSO
============
 * ov_transport_cmd, report_devlog









