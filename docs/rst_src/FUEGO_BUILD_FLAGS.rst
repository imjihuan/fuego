.. _fuego_build_flags:

##################
FUEGO BUILD FLAGS
##################

This variable may be defined in a board file or in a tools file, and
is used to specify build attributes for test programs built by Fuego
for that board or toolchain (respectively)

Currently, this can only have the value: **no_static**

Other values may be supported (in a space-separated list) in the
future.

By default, many Fuego tests will attempt to build static binaries, as
these require less dependencies on the target.  However, some
toolchains do not support compiling static binaries.  For such a toolchain,
this flag should be used in the toolchain shell script,
to indicate to the Fuego build system to build dynamic programs
instead.

This flag can also be used in a board file,
to indicate to the Fuego build system to build dynamic programs
for that board (whether or not the toolchain supports static
linking or not).

Example: put this line in a toolchain setup script,
(``/fuego-ro/toolchains/$TOOLCHAIN-tools.sh``) or in your board
configuration file (``/fuego-ro/boards/myboard.board``): ::

  FUEGO_BUILD_FLAGS="no_static"

