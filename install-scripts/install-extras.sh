#!/bin/bash
# 2021 (c) Toshiba corp.
#
# Install extra
set -e

nojenkins=0
[ "$1" = "--nojenkins" ] && nojenkins=1

# ==============================================================================
# get ttc script and helpers
# ==============================================================================
[ -d /usr/local/src/ttc ] || git clone https://github.com/tbird20d/ttc.git /usr/local/src/ttc
/usr/local/src/ttc/install.sh /usr/local/bin
# as of ttc version 2.0.2, this should not be needed
#perl -p -i -e "s#config_dir = \"/etc\"#config_dir = \"/fuego-ro/conf\"#" /usr/local/bin/ttc

# ==============================================================================
# get ebf script and helpers
# ==============================================================================
if [ $nojenkins -eq 0 ]; then
	apt-get -q=2 -V --no-install-recommends install jq
	[ -d /usr/local/src/board-farm-rest-api ] || git clone https://github.com/TimesysGit/board-farm-rest-api.git /usr/local/src/board-farm-rest-api
	cp /usr/local/src/board-farm-rest-api/cli/ebf /usr/local/bin/ebf
	chmod a+x /usr/local/bin/ebf
fi

# ==============================================================================
# Serial Config
# ==============================================================================
[ -d /usr/local/src/serio ] || git clone https://github.com/frowand/serio.git /usr/local/src/serio
if [ $nojenkins -eq 0 ]; then
	cp frontend-install/0001-Fix-host-parsing-for-serial-device-with-in-name.patch \
		frontend-install/0002-Output-data-from-port-during-command-execution.patch \
		/tmp/
	if patch -d /usr/local/src/serio -p1 -N -s --dry-run </tmp/0001-Fix-host-parsing-for-serial-device-with-in-name.patch; then
		patch -d /usr/local/src/serio -p1 </tmp/0001-Fix-host-parsing-for-serial-device-with-in-name.patch
	fi
	if patch -d /usr/local/src/serio -p1 -N -s --dry-run </tmp/0002-Output-data-from-port-during-command-execution.patch; then
		patch -d /usr/local/src/serio -p1 </tmp/0002-Output-data-from-port-during-command-execution.patch
	fi
	chown -R jenkins /usr/local/src/serio
fi
cp /usr/local/src/serio/serio /usr/local/bin/
ln -sf /usr/local/bin/serio /usr/local/bin/sercp
ln -sf /usr/local/bin/serio /usr/local/bin/sersh

[ -d /usr/local/src/serlogin ] || git clone https://github.com/tbird20d/serlogin.git /usr/local/src/serlogin
[ $nojenkins -eq 0 ] && chown -R jenkins /usr/local/src/serlogin
cp /usr/local/src/serlogin/serlogin /usr/local/bin

# ==============================================================================
# fserver
# ==============================================================================
[ -d /usr/local/lib/fserver ] || git clone https://github.com/tbird20d/fserver.git /usr/local/lib/fserver
ln -sf /usr/local/lib/fserver/start_local_bg_server /usr/local/bin/start_local_bg_server

# ==============================================================================
# ftc post installation
# ==============================================================================
ln -sf /fuego-core/scripts/ftc /usr/local/bin/
cp fuego-core/scripts/ftc_completion.sh /etc/bash_completion.d/ftc
echo ". /etc/bash_completion" >> /root/.bashrc

# ==============================================================================
# Lava
# ==============================================================================
ln -sf /fuego-ro/scripts/fuego-lava-target-setup /usr/local/bin
ln -sf /fuego-ro/scripts/fuego-lava-target-teardown /usr/local/bin