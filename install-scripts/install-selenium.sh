#!/bin/bash
# 2022 (c) Sony Group
#
# Install selenium
set -e


# ==============================================================================
# precursor stuff
# ==============================================================================
apt-get update -q=2
apt-get -q=2 -V --no-install-recomends install \
    apt-transport-https \
    chromium \
    imagemagick \
    python3 \
    python3-pip \
    python3-pillow

apt-get -q=2 -V install \
    python-pexpect \
    python-selenium \


cd /tmp
curl https://chromedriver.storage.googleapis.com/73.0.3683.68/chromedriver_linux64.zip -o chrome-driver.zip ;\
unzip chrome-driver.zip -d /usr/local/bin ;\
chmod +x /usr/local/bin/chromedriver ;\
# rm -rf /var/lib/apt/lists/*
rm -rf chrome-driver.zip ;\



