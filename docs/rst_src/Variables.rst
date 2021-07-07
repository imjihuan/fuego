.. _variables:

###############
Variables
###############

This is an index of all the variables used by Fuego: ::


  FIXTHIS - I don't have all the fuego variables documented here yet

See also :ref:`Core interfaces <core_interfaces>`

==
A
==

 * ``ARCHITECTURE`` : the processor architecture of the target board

   * Defined in the board file for a target

   * Used by toolchain and build scripts for building the tests

     * *NOTE: this appears to only be used by iozone.sh*

   * Example value: **arm**

 * ``ARCH`` : architecture used by the toolchain

   * Example value: **arm**

   * Set by :ref:`tools.sh <tools_sh>` based on TOOLCHAIN

 * ``AS`` : name of the assembler

   * Set by :ref:`tools.sh <tools_sh>` based on TOOLCHAIN
   * Commonly used during the build phase
     (in the function :ref:`test_build <function_test_build>`)

==
B
==

 * ``BAUD`` : Baud rate to be used with the serialport

   * Defined in the board file for a target
   * Used by serial transport
   * Example value: **115200**

 * ``BOARD_TESTDIR`` : directory on the target board where test data will
   be placed

   * Defined in the board file for a target
   * Example value: **/home/fuego**

==
C
==

 * ``CC`` : name of the C compiler

   * Set by :ref:`tools.sh <tools_sh>` based on TOOLCHAIN
   * Commonly used during the build phase
     (in the function :ref:`test_build <function_test_build>`)
   * Example value: **arm-linux-gnueabihf-gcc**

 * ``CONFIGURE_FLAGS`` : flags used with the 'configure' program

   * Set by :ref:`tools.sh <tools_sh>` based on TOOLCHAIN
   * Commonly used during the build phase
     (in the function :ref:`test_build <function_test_build>`)

 * ``CROSS_COMPILE`` : cross-compile prefix used for kernel builds

   * Set by :ref:`tools.sh <tools_sh>` based on TOOLCHAIN
   * Example value: **arm-linux-gnueabihf-**
   * *NOTE: this is often $PREFIX followed by a single dash*

 * ``CPP`` : name of the C pre-processor

   * Set by :ref:`tools.sh <tools_sh>` based on TOOLCHAIN

 * ``CXX`` : name of the C++ compiler

   * Set by :ref:`tools.sh <tools_sh>` based on TOOLCHAIN

 * ``CXXCPP`` : name of the C++ pre-processor

   * Set by :ref:`tools.sh <tools_sh>` based on TOOLCHAIN

==
F
==

 * ``FUEGO_BUILD_FLAGS`` : has special flags used to control builds
   (for some tests)

    * See :ref:`FUEGO_BUILD_FLAGS <fuego_build_flags>`

 * ``FUEGO_CORE`` : directory for Fuego core scripts and tests

    * This is defined in Jenkins and Fuego system-level configurations
    * This will always be ``/fuego-core`` inside the Docker container,
      but will have a different value outside the container.
    * Example value: **/fuego-core**

 * ``FUEGO_DEBUG`` : controls whether Fuego emits debug information during
   test execution.  This variables is now deprecated in favor of
   ``FUEGO_LOGLEVELS``

    * See :ref:`FUEGO_DEBUG  <fuego_debug>`

 * ``FUEGO_LOGLEVELS`` : controls what level of messages Fuego emits
   during test execution

    * See :ref:`FUEGO_LOGLEVELS  <fuego_loglevels>`

 * ``FUEGO_RO`` : directory for Fuego read-only data

    * This is defined in the Jenkins and Fuego system-level
      configurations
    * This will always be ``/fuego-ro`` inside the Docker container,
      but will have a different value outside the container.
    * Example value: **/fuego-ro**

 * ``FUEGO_RW`` : directory for Fuego read-write data

    * This is defined in Jenkins and Fuego system-level configurations
    * This will always be ``/fuego-rw`` inside the Docker container,
      but will have a different value outside the container.
    * Example value: **/fuego-rw**

 * ``FUEGO_TARGET_TMP`` : directory on target to use for syslogs

   * This is defined in the board file for a target board
   * This should specify a directory in the board filesystem that is
     persistent across reboots.  This is to override the default temp
     directory (of ``/tmp``), if that directory is erased on a board
     reboot.

 * ``FUEGO_TEST_PHASES`` : specifies a list of phases to perform during
   test execution

   * This is usually set by ``ftc run-test`` based on the '-p' option.
   * This is a space-separated list of strings, from the following
     possible individual phase strings: **pre_test**, **pre_check**, **build**,
     **deploy**, **snapshot**, **run**, **post_test**, **processing**,
     **makepkg**
   * Example value: **pre_test pre_check build deploy snapshot run
     post_test processing**

==
G
==

 * ``GEN_TESTRES_FILE`` : set to the value of TEST_RES, when a
   BATCH_TESTPLAN is in effect

==
I
==

 * ``IO_TIME_SERIAL`` : Time required for echoing the whole command and
   response

   * Defined in the board file
   * Used by the transport functions
   * Example value: **0.1**

 * ``IPADDR`` : IP address of the target board

   * Defined in the board file
   * Used by the transport functions
   * Example value: **10.0.1.74**

==
L
==

 * ``LD`` : name of the linker

   * Set by :ref:`tools.sh  <tools_sh>` based on TOOLCHAIN
   * Example value: **arm-linux-gnueabihf-ld**

 * ``LOGIN`` : login account name for the target

   * Defined in the board file for the target
   * Used by the transport functions
   * The account on the target should have sufficient rights to run a
     variety of tests and perform a variety of operations on the target
   * Example value: **root**

==
M
==

 * ``MAX_BOOT_RETRIES`` : Number of times to retry connecting to target
   during a :ref:`target_reboot <function_target_reboot>` operation.

   * Defined in the board file
   * Example value: **20**

 * ``MMC_DEV`` : device filename for an MMC device on the target

   * Defined in the board file
   * Used by filesystem test specs
   * Example value: **/dev/mmcblk0p2**

 * ``MMC_MP`` : mount point for a filesystem on an MMC device on the target

   * Defined in the board file
   * Used by filesystem test specs
   * Example value: **/mnt/mmc**

 * ``MOUNT_BLOCKDEV`` : device filename for a block device on the target

   * Defined in a filesystem test spec

     * e.g. in (bonnie, fio, ffsb, iozone, synctest, aiostress,
       dbench, tiobench).spec

   * Usually references either ``MMC_DEV``, ``SATA_DEV`` or ``USB_DEV``,
     depending on what the test spec indicates to test

   * Example value: **/dev/sda1**

 * ``MOUNT_POINT`` : mount point for a filesystem to be tested on the target

   * Defined in a filesystem test spec

      * e.g. in (bonnie, fio, ffsb, iozone, synctest, aiostress,
        dbench, tiobench).spec

   * Usually references either ``MMC_MP``, ``SATA_MP``, or ``USB_MP``, depending
     on what the test spec indicates to test

   * Example value: **/mnt/sata**

==
N
==

  * ``NODE_NAME`` : the name of the board

    * This is set by Jenkins, and is the first part of the
      Fuego job name

==
O
==

 * ``OF_ROOT`` : root of overlay system

   * Example value: **/home/jenkins/overlays/**

==
P
==

 * ``PASSWORD`` : password used with to login to the target board

   * Defined in the board file for a target
   * Used by the transport functions
   * It can be the empty string: ""
   * Example value: **mypass**

 * ``PLATFORM`` : name of the target "platform"  This is used to identify
   the toolchain used for building tests.  This has been deprecated.
   Please use ``TOOLCHAIN`` instead.

 * ``PREFIX`` : toolchain prefix

   * Set by :ref:`tools.sh <tools_sh>` based on TOOLCHAIN
   * Example value: **arm-linux-gnueabihf**
   * *NOTE: see also CROSS_COMPILE*

==
R
==

 * ``REP_DIR`` : directory where reports are stored

   * Example value: **/home/jenkins/logs/logruns/**

 * ``REP_GEN`` : report generator program

   * Example value: **/home/jenkins/scripts/loggen/gentexml.py**

 * ``REP_LOGGEN`` : program used to generate report logs?

   * Example value: **/home/jenkins/scripts/loggen/loggen.py**

==
S
==

 * ``SATA_DEV`` : device node filename for a SATA device on the target

   * Defined in the board file
   * Used by filesystem tests
   * Example value: **/dev/sda1**

 * ``SATA_MP`` : mount point for a filesystem on a SATA device on the target

   * Used by filesystem tests
   * Example value: **/mnt/sata**

 * ``SRV_IP`` : IP address of server machine (host machine where fuego runs)

   * Defined in base-board.fuegoclass

     * Obtained dynamically using the :command:`ip` command

   * Can be defined in a board file for a target, using an :command:`override`
     command
   * Used by networking tests (NetPIPE, iperf, netperf)
   * Example value: **10.0.1.1**

 * ``SSH_PORT`` : port to use for ssh connections on the target

   * Defined in the board file for the target
   * The default port for sshd is 22
   * Example value: **22**

 * ``SERIAL`` : port to use for serial connections on the target

   * Defined in the board file for the target
   * The device file name as detected in Docker container
   * Example value: **ttyACM0**

==
T
==

 * ``TESTLOG`` : full path to log for a particular test

   * Example value: **/home/jenkins/logs/Functional.bzip2/
     testlogs/bbb.2016-06-24_18-12-53.2.log**

 * ``TEST_RES`` : full path to JSON results file for a test

   * Example value: **/home/jenkins/logs/Functional.bzip2/testlogs/
     bbb.2016-06-24_18-12-53.2.res.json**

 * ``TESTDIR`` : name of the directory for a particular test

   * This is just the directory name, not the full path (see $TEST_HOME)
   * This is also used as the reference parse log prefix
   * Example value: **Functional.bzip2**

 * ``TEST_HOME`` : full path to the root of the test directory

   * Example value: **/fuego-core/tests/Functional.bzip2**

 * ``TOOLCHAIN`` : name of the toolchain used to build test programs for a
   board.

   * Defined in the board file
   * Used in ``tools.sh``
   * Example value: **debian-armhf**
   * *NOTE: this replaced 'PLATFORM', used in earlier versions of Fuego*

 * ``TRANSPORT`` : type of connection between the host system and the target
   system

   * Defined in the board file for the target
   * possible values: **ssh**, **serial**, **ttc**, **ssh2serial**,
     **local**

     * Others anticipated are: **adb**, **lava**

   * Used by the transport functions
   * Example value: **ssh**

 * ``TTC_TARGET`` : target name used with ``ttc`` command

   * Defined in the board file for the target
   * Used by the transport functions, for the ``ttc`` transport only
   * Example value: **beaglebone**

==
U
==

 * ``USB_DEV`` : device filename for an block device provided by a USB
   device on the target

   * Defined in the board file
   * Used by filesystem test specs
   * Example value: **/dev/sdb1**

 * ``USB_MP`` : mount point for a filesystem on an USB device on the target

   * Defined in the board file
   * Used by filesystem test specs
   * Example value: **/mnt/usb**

====================
UNDOCUMENTED (YET)
====================

 * ``TRIPLET``
 * ``LTP_OPEN_POSIX_SUBTEST_COUNT_POS``

   * Defined in board file for a target

 * ``LTP_OPEN_POSIX_SUBTEST_COUNT_NEG``

   * Defined in board file for a target

 * ``EXPAT_SUBTEST_COUNT_POS``

   * Defined in board file for a target

 * ``EXPAT_SUBTEST_COUNT_NEG``

   * Defined in board file for a target

 * ``OF_ROOT``
 * ``OF_CLASSDIR``
 * ``OF_DEFAULT_SPECDIR``
 * ``OF_OVFILES``
 * ``OF_CLASSDIR_ARGS``
 * ``OF_TESTPLAN_ARGS``
 * ``OF_SPECDIR_ARGS``
 * ``OF_OUTPUT_FILE``
 * ``OF_OUTPUT_FILE_ARGS``
 * ``OF_DISTRIB_FILE``
 * ``OF_OVGEN``
 * ``OF_BOARD_FILE``
 * ``BATCH_TESTPLAN``
 * ``OF_TESTPLAN``
 * ``OF_TESTPLAN_ARGS``
 * ``OF_OVFILES_ARGS``
