###################
Benchmark.bonnie
###################

===============
Description
===============

Bonnie++ is a filesystem benchmark that measures basic speed of
several operations, including data read and write speed, the number of
seeks per second, and the number of file metadata operations per
second.

=============
Resources
=============

 * `Using Bonnie++ for filesystem performance benchmarking <https://www.linux.com/news/using-bonnie-filesystem-performance-benchmarking>`_,
   by Ben Martin, Linux.com, July 2008 (accessed Oct. 2017)

 * `Bonnie++ wikipedia entry <https://en.wikipedia.org/wiki/Bonnie%2B%2B>`_
 * `Bonnie++ home page <https://www.coker.com.au/bonnie++/>`_

===========
Results
===========

=========
Tags
=========

 * filesystem

===============
Dependencies
===============

Bonnie has no build dependencies.

There is a separate command line option for running it as the 'root'
user.

Bonnie uses the following test variables at runtime:

 * ``BENCHMARK_BONNIE_MOUNT_BLOCKDEV`` - name of block device where
   filesystem to be tested in located, or "ROOT"

 * ``BENCHMARK_BONNIE_MOUNT_POINT`` - directory name where the filesystem
   should be mounted (if needed), and the tests run.

 * ``BENCHMARK_BONNIE_SIZE`` - specifies the size, in megabytes, of the
   files used for IO performance measurements

   * This is the parameter to the -s command line option

 * ``BENCHMARK_BONNIE_RAM`` - specifies the size of the board's RAM in
   megabytes, or "0" if ram size sanity checks should be disabled

   * This is the parameter to the -r command line option

 * ``BENCHMARK_BONNIE_NUM_FILES`` - is a colon-separate 4-tuple indicating
   the number of files, the file max size, the file min size, and the
   number of directories to spread the files into, for metadata tests

   * The default value, if not specified is: "16:0:0:1".  This results in 16K
     files with maximum and minimum size 0, in 1 directory.

 * ``BENCHMARK_BONNIE_ROOT`` - should be set to "true" if the bonnie should
   try to execute as the root user on the board.

==========
Status
==========

 * OK

=========
Notes
=========

If a test executes too quickly, bonnie does not report the result, and
instead produces '+++++'s in the entries for those tests.  Specifically,
bonnie will emit this if a test result was less than .5 seconds (MinTime
in the source code).  If this happens for you, consider using or writing
a spec that increases the size of the files, or the number of files used
for tests.

