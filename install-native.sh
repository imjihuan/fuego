#!/bin/bash
# 2021 (c) Toshiba corp.
#
# Install feugo on native system
set -e

: "${JENKINS_VERSION:=2.249.3}"
: "${JENKINS_SHA:=534014c007edbb533a1833fe6f2dc115faf3faa2}"

usage(){
	echo ""
	echo "Usage: sudo ./install-native.sh [--help|-h] [-s <suite>] [-p <jenkins port>] [--nojenkins]"
	echo "Install fuego on Debian filesystem."
	echo ""
	echo "options:"
	echo "	--help  | -h		Show usage help"
	echo "	--suite | -s <suite>	Specify Debian suite"
	echo "	--port  | -p <port>	Jenkins port"
	echo "	--nojenkins		Install Fuego without Jenkins"
	echo ""
}

if [[ $EUID -ne 0 ]]; then
	echo "Sorry, you need root permissions"
	exit 1
fi

NO_JENKINS=
JENKINS_PORT=8090
DEBIAN_VERSION=stretch
uid=
gid=

while [ "$1" != "" ]; do
	case $1 in
		-s | --suite )
			shift
			DEBIAN_VERSION=$1
			;;
		-p | --port )
			shift
			JENKINS_PORT=$1
			;;
		-u | --uid )
			shift
			uid=$1
			;;
		-g | --gid )
			shift
			gid=$1
			;;
		--nojenkins )
			NO_JENKINS="--nojenkins"
			;;
		-h | --help )
			usage
			exit 0
			;;
		* )
			break
	esac
	shift
done

# get fuego-core repository, if not already present
if [ ! -f fuego-core/scripts/ftc ] ; then
    # set fuego-core branch to same as current fuego branch
    # get current git branch
    set -o noglob
    while IFS=" " read -r part1 part2 ; do
        if [ $part1 = "*" ] ; then
            branch=$part2
        fi
    done < <(git branch)
    set +o noglob
    git clone -b $branch https://bitbucket.org/fuegotest/fuego-core.git
fi

fuego_dir=$(pwd)

# Install debian common packages
./install-scripts/install-debian-common.sh $DEBIAN_VERSION

# Install debian version specific packages or configurations
if [ -f ./install-scripts/install-${DEBIAN_VERSION}.sh ]; then ./install-scripts/install-${DEBIAN_VERSION}.sh; fi

# Install Jenkins
if [ -z $NO_JENKINS ]; then ./install-scripts/install-jenkins.sh ${JENKINS_PORT} ${JENKINS_VERSION} ${JENKINS_SHA} ${uid} ${gid}; fi

# Install extra binaries downloading from repositories
./install-scripts/install-extras.sh $NO_JENKINS

# Set Jenkins enabled status in fuego.conf
[ "$NO_JENKINS" == "--nojenkins" ] && val=0 || val=1
sed -i "s/\(^jenkins_enabled=\).*/\1$val/" fuego-ro/conf/fuego.conf

if [ -z $NO_JENKINS ]; then
	# Start the Jenkins service
	systemctl daemon-reload
	service jenkins restart

	# provide permission to current user
	[ -z $SUDO_USER ] && user=$USER || user=$SUDO_USER
	usermod -a -G jenkins $user
	chmod -R 775 $fuego_dir/fuego-rw

	chown -R jenkins:jenkins $fuego_dir/fuego-ro
	chown -R jenkins:jenkins $fuego_dir/fuego-rw
	chown -R jenkins:jenkins $fuego_dir/fuego-core
fi

  # ==============================================================================
  # Create Links to fuego folders
  # ==============================================================================
  ln -sf $fuego_dir/fuego-ro /
  ln -sf $fuego_dir/fuego-rw /
  ln -sf $fuego_dir/fuego-core /

  # ==============================================================================
  # Small guide
  # ==============================================================================
  echo "Logout and Login current user session to work properly"
  echo "Run 'service netperf start' to start a netperf server"
  echo "Run 'iperf3 -V -s -D -f M' to start an iperf3 server"
  echo "Run 'ftc list-boards' to see the available boards"
  echo "Run 'ftc list-tests' to see the available tests"
  echo "Run 'ftc run-test -b local -t Functional.hello_world' to run a hello world"
  echo "Run 'ftc run-test -b local -t Benchmark.Dhrystone -s 500M' to run Dhrystone"
  echo "Run 'ftc gen-report' to get results"
