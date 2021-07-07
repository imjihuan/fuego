.. _tools_sh:

###################
tools.sh
###################

The tools.sh file provides the definitions for variables used for each
platform's toolchains.

A single tools.sh file is located at the directory
``/fuego-ro/toolchains/tools.sh`` This file uses the PLATFORM environment
variable to load a ``tools.sh`` file for a particular toolchain.

An individual platform tools file should be named ``<PLATFORM>-tools.sh``, and
be located in the ``/fuego-ro/toolchains`` directory.

A new ``<PLATFORM>-tools.sh`` files must be added whenever a toolchain or SDK
is added to the system.

For example, for the platform ``poky-qemuarm``, the file
``/fuego-ro/toolchains/poky-qemuarm-tools.sh`` sets the variables needed
to compile programs with that toolchain.

The variables that should be exported are:

 * CC - C compiler
 * CXX - C++ compiler
 * CPP - C pre-processor
 * CXXCPP - C++ pre-processor
 * CONFIGURE_FLAGS - flags for the configure script
 * RANLIB - archive index generator (for libs)
 * AS - assembler
 * LD - linker
 * ARCH - architecture
 * CROSS_COMPILE - tool prefix used to build the kernel
 * PREFIX - prefix used with most tools
 * HOST - used with configure --host=$HOST, to specify the machine you are building for
 * SDKROOT - used as prefix for /usr/lib and /usr/include directories

The above variables are directly referenced by the Fuego system.

A few other variables may be used optionally by the build instructions for
individual tests.

 * CFLAGS
 * LDFLAGS

Variable usage details
======================

.. note::

  Note that some tools variables are referenced in patch files. These
  don't count as uses from ``-tools.sh``. because they are defined as
  part of the program build instructions with the program itself.

Here are some specific tools variables and what tests use them:

 * CFLAGS - compiler flags

   * used by Benchmark.netpipe, Benchmark.cyclictest, Benchmark.tiobench, Benchmark.dbench, Benchmark.ffsh, Benchmark.Dhrystone, Benchmark.lmbench2, Benchmark.himeno, Benchmark.nbench_byte, Benchmark.linpack, Benchmark.GLMark, Benchmakr.Whetstone, Functionall.synctest, Functiona.posixtestsuite, Functiona.scrashme, LTP, Functional.rmaptest, Functional.linus_stress, Functional.crashme

 * LDFLAGS - linker flags

   * used by Benchmark.netpipe, Benchmark.cyclictest, Benchmark.Dhrystone, Benchmark.signaltest, Benchmark.Whetstone, Functional.synctest, Functiona.posixtestsuite, Functiona.scrashme, LTP, Functional.rmaptest, Functional.linus_stress, Functional.crashme

 * HOST - this is passed to ``configure`` with ``--host=$HOST``

   * used by Benchmark.aim7, Benchmark.bonnie, Benchmark.dbench, Benchmark.ffsb, Benchmark.x11perf, Benchmark.iperf, Benchmark.gtkperf, Functional.ft2demos, netperf, Functional.glib, and Functional.stress.

 * SDKROOT - used as prefix for ``/usr/include`` and ``/usr/lib`` directories and files in builds

   * used by Benchmark.aim7, Benchmark.blobsallad, Benchmark.GLMark, Benchmark.GLMark, Benchmark.GLMark, Benchmark.gtkperf, Functional.aiostress, Functional.zlib, LTP, and Functional.ft2demos

