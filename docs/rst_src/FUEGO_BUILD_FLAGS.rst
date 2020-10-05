.. _feugo_build_flags:

##################
FUEGO BUILD FLAGS
##################

This variable may be defined in a board file or in a tools file, and
is used to specify build attributes for test programs built by Fuego
for that board or toolchain (respectively)

Currently, this can have the value: **no_static**

Other values may be supported (in a space-separated list) in the
future.

By default, many Fuego tests will attempt to build static binaries, as
these require less dependencies on the target.  However, some
toolchains do not support compiling static binaries.  For a board that
uses such a a toolchain, this flag should be used in the board file,
to indicate to the Fuego build system to build dynamic programs
instead.

Example (put this line your board configuration file, or in your
$PLATFORM-tools.sh file): ::

  FUEGO_BUILD_FLAGS="no_static"

