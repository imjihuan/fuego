############################
Test Functional.arch timer
############################

This test appears to check that a target has an interrupt named
"arch_timer", and that it is running (``/proc/interrupts`` increments
over a 5-second period), and is assigned IRQ number 27.

This looks like something very specific to a Renesas lager board.

=======
Details
=======

This test unpacks a tarball called: ``dung-3.4.25-m2.tar.gz``
It runs the following scripts on target:

 * ``arch_timer-interrupt-lager.s``
 * ``dmesg-lager.sh``
 * ``proc-interrupts-lager.sh``

then checks that the log contains "Test passed" exactly
$FUNCTIONAL_ARCH_TIMER_RES_LINES_COUNT times

This variable is not defined (would have been nice to test it earlier
than in test_processing).  I thought maybe the lager board file would
have this, but it appears not to.

arch_timer-interrupt-lager.sh
===================================

This script uses ``common/interrupt-count.sh`` to measure the number of
occurrences of the arch_timer interrupt over a period of 5 seconds.

if the value is increasing, then it emits "Test passed"

dmesg-lager.sh
===================

This script uses ``common/dmesg.sh`` to search for the following
string: "ARM arch timer >56 bits at 10000kHz" in the dmesg output

proc-interrupts-lager.sh
===============================

This script uses ``common/proc-interrupts.sh`` to check for the
arch_timer interrupt, and see if it matches 27.

If the value matches, then it emits "Test passed"
