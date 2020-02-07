#
# setenv.sh - helper script to set build environment inside Fuego docker container
# for use for manually testing build commands
#
# This file should be 'source'ed and not executed
#
# To use do: $ source /fuego-ro/toolchains/setenv.sh <board>
#
# outline:
#  - get TOOLCHAIN (or PLATFORM) from board file
#  - source tools.sh environment

BOARD=$1
if [ -z "$BOARD" ] ; then
    echo "Usage: source setenv.sh <board>"
    exit 1
fi
FUEGO_RO=/fuego-ro
BOARDFILE=$FUEGO_RO/boards/$BOARD.board

if [ ! -f "$BOARDFILE" ] ; then
    echo "Error: Can not find board file $BOARDFILE"
    exit 1
fi

# extract TOOLCHAIN value from file
# omitting leading and trailing quotes in the value
export STRING=$(sed -n -e "/TOOLCHAIN=/s/TOOLCHAIN=\"\(.*\)\"/\1/p" $BOARDFILE)
if [ -z "$STRING" ] ; then
    export STRING=$(sed -n -e "/PLATFORM=/s/PLATFORM=\"\(.*)\"/\1/p" $BOARDFILE)
    if [ -z "$STRING" ] ; then
        echo "Error: can not read TOOLCHAIN or PLATFORM in board file $BOARDFILE"
        exit 1
    fi
fi

TOOLCHAIN="$STRING"
echo "Setting environment for TOOLCHAIN=$TOOLCHAIN"

# define this to report error in case something goes wrong
function abort_job() {
    echo "*** ABORTED: reason: $1"
    exit 1
}

source $FUEGO_RO/toolchains/tools.sh
