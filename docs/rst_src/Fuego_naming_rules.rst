.. _fuego_naming_rules:

################################
Fuego naming rules
################################

To add boards or write tests for Fuego, you have to create a number of
files and define a number of variables.

Here are some rules and conventions for naming things in Fuego:

===================
Fuego test name 
===================

 * a Fuego test name must have one of the following prefixes:

   * 'Functional.'
   * 'Benchmark.'

 * the name following the prefix is known as the base test name, and 
   has the following rules:

   * it may only use letters, numbers and underscores

     * that is - no dashes

   * it may use upper and lower case letters

 * All test definition materials reside in a directory with the full 
   test name:

   * e.g. Functional.hello_world

=================
Test files
=================

 * the base script file has the name **fuego_test.sh**
 * the default spec file for a test has name **spec.json**
 * the default criteria file for a test has the name **criteria.json**
 * the reference file for a test has the name **reference.json**
 * the parser module for a test has the filename **parser.py**

====================
Test spec names 
====================

Test spec names are declared in the spec file for a test.
These names should consist of letters, numbers and underscores only.
That is, no periods should be used in spec names.

Every test should have at least one spec, called the 'default' spec.
If no spec file exists for a test, then Fuego generates a 'default'
spec (on-the-fly), which is empty (ie. has no test variables).

================
Board names 
================

 * boards are defined by files in the /fuego-ro/boards directory
 * their filenames consists of the board name, with the suffix ".board"

   * e.g. beaglebone.board

 * a board name should have only letters, numbers and underscores.

   * specifically, no dashes, periods, or other punctuation is allowed

==========================
Jenkins element names 
==========================

Several of the items in Fuego are represented in the Jenkins interface.
The following sections describe the names used for these elements.

Node name
===================

 * A Jenkins node corresponding to a board must have the same name as 
   the board.

   * e.g. beaglebone

Job name
=============

 * A Jenkins job is used to execute a test.
 * Jenkins job names should consist of these parts:
   <board>.<spec>.<test_name>

   * e.g. beaglebone.default.Functional.hello_world

 

===================
Run identifier 
===================

A Fuego run identifier is used to refer to a "run" of a test - that is
a particular invocation of a test and it's resulting output, logs and
artifacts.  A run identifier should be unique throughout the world, as
these are used in servers where data from runs from different hosts
are stored.

The parts of a run id are separated by dashes, except that the 
separator between the host and the board is a colon.

A fully qualified (global) run identifier consist of the following 
parts:

 * test name
 * spec name
 * build number
 * the word *on*
 * host
 * board

FIXTHIS - global run ids should include timestamps to make them
globally unique for all time


Example:
Functional.LTP-quickhit-3-on-timdesk:beaglebone


A shortened run identifier may omit the *on* and *host*.  This is
referred to as a local run id, and is only valid on the host where the
run was produced.

Example:
 * Functional.netperf-default-2-minnow

=============
timestamp 
=============

 * A Fuego timestamp has the format: YYYY-mm-dd_HH:MM:SS

   * e.g. 2017-03-29_10:25:14

 * times are expressed in localtime (relative to the host where they 
   are created)

====================
test identifiers 
====================

Also know as TGUIDs (or test globally unique identifiers), a test
identifier refers to a single unit of test operation or result from
the test system.  A test identifier may refer to a testcase or an
individual test measure.

They consist of a several parts, some of which may be omitted in some
circumstances

The parts are:

 * testsuite name
 * testset name
 * testcase name
 * measure name

Legal characters for these parts are letters, numbers, and underscores.
Only testset names may include a period ("."), as that is used as the
separator between constituent parts of the identifier. 

testcase identifiers should be consistent from run-to-run of a test, 
and should be globally unique.

test identifiers may be in fully-qualified form, or in shortened
form - missing some parts.  The following rules are used to convert
between from shortened forms to fully-qualified forms.

If the testsuite name is missing, then the base name of the test is 
used.

 * e.g. Functional.jpeg has a default testsuite name of "jpeg"

If the testset name is missing, then the testset name is "default".

A test id may refer to one of two different items:

 * a testcase id
 * a measure id

A fully qualified test identifier consists of a testsuite name,
testset name and a testcase name.  Shortened names may be used, in
which case default values will be used for some parts, as follows:

If a result id has only 1 part, it is the testcase name. The testset
name is considered to be *default*, and the testsuite name is the base
name of the test.

That is, for the fuego test Functional.jpeg, a shortened tguid of
*test4*, the fully qualified name would be:

 * jpeg.default.test4

If a result id has 2 parts, then the first part is the testset name
and the second is the testcase name, and the testsuite name is the
base name of the test.

measure id
===============

A measure identifier consists of a testsuide id, testset id, testcase
id and measure name.

A shortened measure id may not consist of less than 2 parts.  If it
only has 2 parts, the first part is the testcase id, and the second
part is the measure name.  In all cases the last part of the name is
the measure name, the second-to-last part of the name is the testcase
name.

If there are three parts, the first part is the testset name.

=======================
Test variable names 
=======================

Test variable names are defined in the board file, and by the user
via 'ftc set-var'.  Also they are generated from variables declared
in spec files.  The consist of all upper-case, using only letters and
underscores

Some test variable prefixes and suffixes are used in a consistent way.

Dependency check variables 
============================

The following is the preferred format for variables used in dependency
checking code:

 * **PROGRAM_FOO** - require program 'foo' on target.  The program
   name is upper-cased, punctuation or spaces are replaced with '_',
   and the name is prefixed with 'PROGRAM\_'.  The value of variable
   is full path on target where program resides.

    * ex: PROGRAM_BC=/usr/bin/bc

 * **HEADER_FOO** - require header file 'foo' in SDK.  The header
   filename is stripped of its suffix (I don’t know if that's a good
   idea or not), upper-cased, punctuation or spaces are replaced with
   '_', and the name is prefixed with 'HEADER\_'. The value of
   variable is the full path in the SDK of the header file:

    * ex:
      HEADER_FOO=/opt/poky2.1.2/sysroots/x86_64-pokysdk-
      linux/usr/include/foo.h


 * **SDK_LIB_FOO** - require 'foo' library in SDK.  The library
   filename is stripped of the 'lib' prefix and .so suffix,
   upper-cased, punctuation and spaces are replaced with '_', and the
   name is prefixed with 'SDK_LIB\_'.  The value of the variable is
   the full path in the SDK of the library.

   * ex: SDK_LIB_FOO=/opt/poky2.1.2/sysroots/x86_64-pokysdk-
     linux/usr/lib/libfoo.so
   * Note that in case a static library is required (.a), then the 
     variable name should include that suffix:
   * ex: SDK_LIB_FOO_A=/opt/poky1.2.1/sysroots/x86_64-pokysdk-
     linux/usr/lib/libfoo.a

 * **TARGET_LIB_FOO** - require 'foo' library on target.  The library
   filename is stripped of the 'lib' prefix and .so suffix (not sure
   this is a good idea, as we potentially lose a library version
   requirement), upper-cased, punctuation and spaces are replaced with
   '_', and the name is prefixed with 'TARGET_LIB\_'. The value of the
   variable is  the full path of the library on the target board.

   * ex: TARGET_LIB_FOO=/usr/lib/libfoo.so






