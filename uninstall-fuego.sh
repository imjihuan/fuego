#!/bin/bash

# Remove Jenkins plugins
[ -d /usr/share/jenkins/ref/plugins/ ] && rm -rf /usr/share/jenkins/ref/plugins

# uninstall Jenkins
service jenkins stop
dpkg -P jenkins

[ -f /usr/local/bin/install-plugins.sh ] && rm -f /usr/local/bin/install-plugins.sh
[ -f /usr/local/bin/jenkins-support ] && rm -rf /usr/local/bin/jenkins-support
[ -f /usr/local/bin/clitest ] && rm -rf /usr/local/bin/clitest
[ -d /var/lib/jenkins ] && rm -rf /var/lib/jenkins
sed -i '/^JENKINS_PORT=/d' /etc/environment

# uninstall ttc script
[ -d /usr/local/src/ttc ] && rm -rf /usr/local/src/ttc

# uninstall ebf script
[ -d /usr/local/src/board-farm-rest-api ] && rm -rf /usr/local/src/board-farm-rest-api
[ -f /usr/local/bin/ebf ] && rm -f /usr/local/bin/ebf

# uninstall serial config
[ -d /usr/local/src/serio ] && rm -rf /usr/local/src/serio
[ -f /usr/local/bin/serio ] && rm -rf /usr/local/bin/serio
[ -f /usr/local/bin/sercp ] && rm -rf /usr/local/bin/sercp
[ -f /usr/local/bin/sersh ] && rm -rf /usr/local/bin/sersh
[ -d /usr/local/src/serlogin ] && rm -rf /usr/local/src/serlogin
[ -f /usr/local/bin/serlogin ] && rm -rf /usr/local/bin/serlogin

# uninstall fserver
[ -d /usr/local/lib/fserver ] && rm -f /usr/local/bin/fserver
[ -f /usr/local/bin/start_local_bg_server ] && rm -rf /usr/local/bin/start_local_bg_server

# uninstall ftc
[ -f /usr/local/bin/ftc ] && rm -rf /usr/local/bin/ftc
[ -f /etc/bash_completion.d/ftc ] && rm -rf /etc/bash_completion.d/ftc

# remove lava target files
[ -f /usr/local/bin/fuego-lava-target-setup ] && rm -rf /usr/local/bin/fuego-lava-target-setup
[ -f /usr/local/bin/fuego-lava-target-teardown ] && rm -rf /usr/local/bin/fuego-lava-target-teardown

# remove links
[ -d /fuego-ro ] && rm /fuego-ro
[ -d /fuego-rw ] && rm /fuego-rw
[ -d /fuego-core ] && rm /fuego-core

# Change owner permissions back
[ -z $SUDO_USER ] && user=$USER || user=$SUDO_USER
[ -d ./fuego-ro ] && chown -R $user:$user ./fuego-ro
[ -d ./fuego-rw ] && chown -R $user:$user ./fuego-rw
[ -d ./fuego-core ] && chown -R $user:$user ./fuego-core
