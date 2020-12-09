######################
Test Functional.cmt
######################

This test appears to check that a target has an interrupt named
"sh_cmt.0", and that it is running (``/proc/interrupts`` increments over a
5-second period), and is assigned IRQ number 174.

This looks like something very specific to some Renesas lager board.

===========
Details
===========

This test unpacks a tarball called: dung-3.4.25-m2.tar.gz It runs the
following scripts on target:

 * ``cmt/cmt-interrupt.sh``
 * ``cmt/dmesg.sh``
 * ``cmt/proc-interrupts.sh``

then checks that the log contains "Test passed" exactly
$FUNCTIONAL_CMT_LINES_COUNT times

This variable is not defined (would have been nice to test it earlier
than in test_processing).  I thought maybe another board file would
have this, but it appears not to.

cmt/cmt-interrupt.sh
=========================

This script uses ``common/interrupt-count.sh`` to measure the number of
occurrences of the 'sh_cmt.0' interrupt over a period of 5 seconds.

If the value is increasing, then it emits "Test passed"

cmt/dmesg.sh
=================

This script uses ``common/dmesg.sh`` to search for the following string:
"sh_cmt sh_cmt.0: used for clock events" in the dmesg output

cmt/proc-interrupts.sh
=============================

This script uses ``common/proc-interrupts.sh`` to check for the 'sh_cmt.0'
interrupt, and see if it matches 174.

If the value matches, then it emits "Test passed"
