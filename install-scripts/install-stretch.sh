#!/bin/bash
# 2021 (c) Toshiba corp.
#
# Install Debian version specific packages
set -e

#TODO: find alternate package for netperf in buster version
apt-get -q=2 -V --no-install-recommends install netperf

# bsdmainutils provides hexdump, which is needed for netperf test
apt-get -q=2 -V --no-install-recommends install \
    bsdmainutils