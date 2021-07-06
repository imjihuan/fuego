#!/bin/bash
# 2021 (c) Toshiba corp.
#
# Install Debian common steps
set -e

debian_version=${1:stretch}

# netperf is in non-free
echo deb http://deb.debian.org/debian $debian_version main non-free > /etc/apt/sources.list
echo deb http://security.debian.org/debian-security $debian_version/updates main >> /etc/apt/sources.list

# Fuego python dependencies
# - python-lxml: ftc, loggen
# - python-simplejson: ftc
# - python-yaml: ftc
# - python-openpyxl: ftc (also LTP)
# - python-requests: ftc (also fuego_release_test)
# - python-reportlab: ftc
# - python-parsedatetime: ftc
# - python-pexpect: ssh_exec (part of ttc)
# - python-pip: to install filelock, flake8
# - filelock: parser
mkdir -p /usr/share/man/man1
apt-get update -q=2 && apt-get -q=2 -V --no-install-recommends install \
	python-lxml python-simplejson python-yaml python-openpyxl \
	python-requests python-reportlab python-parsedatetime \
	python-pexpect python-pip python-setuptools python-wheel
pip install filelock

# Fuego command dependencies
apt-get -q=2 -V --no-install-recommends install \
	git sshpass openssh-client sudo net-tools wget curl lava-tool \
	bash-completion iproute2

# Default SDK for testing locally or on an x86 board
apt-get -q=2 -V --no-install-recommends install \
	build-essential cmake bison flex automake kmod libtool \
	libelf-dev libssl-dev libsdl1.2-dev libcairo2-dev libxmu-dev \
	libxmuu-dev libglib2.0-dev libaio-dev pkg-config rsync u-boot-tools

# Default test host dependencies
# - iperf iperf3 netperf: used as servers on the host
# - bzip2 bc: used for local tests by Functional.bzip2/bc
# - python-matplotlib: Benchmark.iperf3 parser
# - python-xmltodict: AGL tests
# - flake8: Functional.fuego_lint
# - netpipe-tcp - used by Benchmark.netpipe (provides the netpipe server)
# - iputils-ping - for /bin/ping command, used by some tests
# FIXTHIS: install dependencies dynamically on the tests that need them
apt-get -q=2 -V --no-install-recommends install \
	iperf iperf3 bzip2 bc python-matplotlib python-xmltodict \
	netpipe-tcp iputils-ping
pip install flake8

# miscelaneous packages:
# python-serial - used by serio
# diffstat and vim - used by Tim
# time - useful for timing command duration
apt-get -q=2 -V --no-install-recommends install \
    python-serial \
    diffstat \
    vim \
    time

# install packages used by NuttX SDK
apt-get -q=2 -V --no-install-recommends install \
    genromfs

# FIXTHIS: determine if these tools are really necessary
# apt-get -q=2 -V --no-install-recommends install \
#	apt-utils python-paramiko \
#	xmlstarlet rsync \
#	inotify-tools gettext netpipe-tcp \
#	at minicom lzop bsdmainutils \
#	mc netcat openssh-server

echo "dash dash/sh boolean false" | debconf-set-selections
DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash
if [ -n "$http_proxy" ]; then
	sed -i -e 's/#use_proxy = on/use_proxy = on/g' /etc/wgetrc
	echo -e "http_proxy=$http_proxy\nhttps_proxy=$https_proxy" >> /etc/environment
fi