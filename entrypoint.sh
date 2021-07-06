#!/bin/bash

[ "$1" != "--nojenkins" ] && service jenkins start

#TODO: netperf not present in buster, remove this condition once alternative found
[ -f /etc/init.d/netperf ] && service netperf start
iperf3 -V -s -D -f M
