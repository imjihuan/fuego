#!/bin/bash
# $1: architecture (e.g.: arm64 armel armhf mips mipsel powerpc ppc64el)

ARCH=$1

case $ARCH in
	arm64 | armel | armhf | mips | mipsel | powerpc | ppc64el)
		;;
	*)
		echo "Usage: install_cross_toolchain.sh <arch>"
		echo "Unsupported toolchain architecture: '$ARCH'"
		echo "Please use one of: arm64 armel armhf mips mipsel powerpc ppc64el"
        echo "If in doubt for arm, use 'armhf'"
		exit 1
		;;
esac

# use working directory as a lock
if [ -d /tmp/toolchain_install ] ; then
    echo "Cannot use /tmp/toolchain_install as it's already present"
    echo "Try again after other operation completes, or you remove it manually"
    exit
fi
mkdir -p /tmp/toolchain_install

echo deb http://deb.debian.org/debian stretch main > /etc/apt/sources.list.d/crosstools.list
dpkg --add-architecture "${ARCH}"
DEBIAN_FRONTEND=noninteractive apt-get update
DEBIAN_FRONTEND=noninteractive apt-get -yV install "crossbuild-essential-${ARCH}"

# libaio is needed for LTP
DEBIAN_FRONTEND=noninteractive apt-get -yV install libaio1:$ARCH

# manually install libio-dev from the arch-specific libaio-dev debian package
# (because 'apt-get install' removes any other libaio-dev package installed)
echo "Install libaio-dev:$ARCH... (in a way that's a bit tricky)"
SAVEDIR=$(pwd)
cd /tmp/toolchain_install
echo "  current directory: $(pwd)"
apt-get download libaio-dev:$ARCH
PKG=$(echo libaio-dev*.deb)
echo "  downloaded package: $PKG"
toolchain_dir=$(dpkg --contents $PKG | grep /usr/lib | head -n 2 | tail -n 1 | cut -b 59- )
echo "  toolchain_dir: $toolchain_dir"
# extract the package contents
dpkg -x $PKG .
# copy the file and symlink we need
cp -vd usr/lib/${toolchain_dir}libaio.* /usr/lib/${toolchain_dir}
# clean up
cd $SAVEDIR
rm -rf /tmp/toolchain_install
rm -f /etc/apt/sources.list.d/crosstools.list
