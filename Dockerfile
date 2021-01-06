# ==============================================================================
# WARNING: this Dockerfile assumes that the container will be created with
# several bind mounts (see docker-create-container.sh)
# ==============================================================================
# FIXTHIS: build this as an extension of the nonjenkins image

FROM debian:stretch-slim
MAINTAINER tim.bird@sony.com

# ==============================================================================
# Proxy variables
# ==============================================================================

ARG HTTP_PROXY
ENV http_proxy ${HTTP_PROXY}
ENV https_proxy ${HTTP_PROXY}

# ==============================================================================
# Prepare basic image
# ==============================================================================

ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /
RUN echo deb http://deb.debian.org/debian stretch main non-free > /etc/apt/sources.list
RUN echo deb http://security.debian.org/debian-security stretch/updates main >> /etc/apt/sources.list
RUN if [ -n "$HTTP_PROXY" ]; then echo 'Acquire::http::proxy "'$HTTP_PROXY'";' > /etc/apt/apt.conf.d/80proxy; fi

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
RUN mkdir -p /usr/share/man/man1
RUN apt-get update -q=2 && apt-get -q=2 -V --no-install-recommends install \
	python-lxml python-simplejson python-yaml python-openpyxl \
	python-requests python-reportlab python-parsedatetime \
	python-pexpect python-pip python-setuptools python-wheel
RUN pip install filelock

# Fuego command dependencies
RUN apt-get -q=2 -V --no-install-recommends install \
	git sshpass openssh-client sudo net-tools wget curl lava-tool \
	bash-completion iproute2

# Default SDK for testing locally or on an x86 board
RUN apt-get -q=2 -V --no-install-recommends install \
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
RUN apt-get -q=2 -V --no-install-recommends install \
	iperf iperf3 netperf bzip2 bc python-matplotlib python-xmltodict \
    netpipe-tcp iputils-ping
RUN pip install flake8

# miscelaneous packages:
# python-serial - used by serio
# diffstat and vim - used by Tim
# time - useful for timing command duration
RUN apt-get -q=2 -V --no-install-recommends install \
    python-serial \
    diffstat \
    vim \
    time

# install packages used by NuttX SDK
RUN apt-get -q=2 -V --no-install-recommends install \
    genromfs

# FIXTHIS: determine if these tools are really necessary
#RUN apt-get -q=2 -V --no-install-recommends install \
#	apt-utils python-paramiko \
#	xmlstarlet rsync \
#	inotify-tools gettext netpipe-tcp \
#	at minicom lzop bsdmainutils \
#	mc netcat openssh-server

# bsdmainutils provides hexdump, which is needed for netperf test
RUN apt-get -q=2 -V --no-install-recommends install \
	bsdmainutils

RUN /bin/bash -c 'echo "dash dash/sh boolean false" | debconf-set-selections ; dpkg-reconfigure dash'
RUN if [ -n "$HTTP_PROXY" ]; then echo "use_proxy = on" >> /etc/wgetrc; fi
RUN if [ -n "$HTTP_PROXY" ]; then echo -e "http_proxy=$HTTP_PROXY\nhttps_proxy=$HTTP_PROXY" >> /etc/environment; fi

# ==============================================================================
# Install Jenkins with the same UID/GID as the host user
# ==============================================================================

ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=${uid}
ARG JENKINS_PORT=8090
# see https://updates.jenkins.io/download/war/ for latest Jenkins versions
#ARG JENKINS_VERSION=2.164.2
#ARG JENKINS_SHA=4536f43f61b1fca6c58bd91040fa09304eea96ab
#ARG JENKINS_VERSION=2.235.3
#ARG JENKINS_SHA=89a37ed1b3c8c14ff94cc66c3f2254f281b60794
ARG JENKINS_VERSION=2.249.3
ARG JENKINS_SHA=534014c007edbb533a1833fe6f2dc115faf3faa2

ARG JENKINS_URL=https://pkg.jenkins.io/debian-stable/binary/jenkins_${JENKINS_VERSION}_all.deb
ARG JENKINS_UC=https://updates.jenkins.io
ARG REF=/var/lib/jenkins/plugins
ENV JENKINS_HOME=/var/lib/jenkins
ENV JENKINS_PORT=$JENKINS_PORT

# Jenkins dependencies
RUN apt-get -q=2 -V --no-install-recommends install \
	default-jdk daemon psmisc adduser procps unzip
RUN pip install python-jenkins==1.4.0

RUN echo -e "JENKINS_PORT=$JENKINS_PORT" >> /etc/environment
RUN getent group ${gid} >/dev/null || groupadd -g ${gid} ${group}
RUN useradd -l -m -d "${JENKINS_HOME}" -u ${uid} -g ${gid} -G sudo -s /bin/bash ${user}
RUN wget -nv ${JENKINS_URL}
RUN echo "${JENKINS_SHA} jenkins_${JENKINS_VERSION}_all.deb" | sha1sum -c -
# allow Jenkins to start and install plugins, as part of dpkg installation
RUN printf "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d
RUN dpkg -i jenkins_${JENKINS_VERSION}_all.deb
RUN rm jenkins_${JENKINS_VERSION}_all.deb

# ==============================================================================
# get ttc script and helpers
# ==============================================================================
RUN git clone https://github.com/tbird20d/ttc.git /usr/local/src/ttc
RUN /usr/local/src/ttc/install.sh /usr/local/bin
RUN perl -p -i -e "s#config_dir = \"/etc\"#config_dir = \"/fuego-ro/conf\"#" /usr/local/bin/ttc

# ==============================================================================
# get ebf script and helpers
# ==============================================================================
RUN apt-get -q=2 -V --no-install-recommends install jq
RUN git clone https://github.com/TimesysGit/board-farm-rest-api.git /usr/local/src/board-farm-rest-api ; \
  cp /usr/local/src/board-farm-rest-api/cli/ebf /usr/local/bin/ebf ; \
  chmod a+x /usr/local/bin/ebf

# ==============================================================================
# Serial Config
# ==============================================================================

RUN git clone https://github.com/frowand/serio.git /usr/local/src/serio
COPY frontend-install/0001-Fix-host-parsing-for-serial-device-with-in-name.patch \
  frontend-install/0002-Output-data-from-port-during-command-execution.patch \
  /tmp/
RUN /bin/bash -c 'patch -d /usr/local/src/serio -p1 </tmp/0001-Fix-host-parsing-for-serial-device-with-in-name.patch ; \
  patch -d /usr/local/src/serio -p1 </tmp/0002-Output-data-from-port-during-command-execution.patch ; \
  chown -R jenkins /usr/local/src/serio ; \
  cp /usr/local/src/serio/serio /usr/local/bin/ ; \
  ln -s /usr/local/bin/serio /usr/local/bin/sercp ; \
  ln -s /usr/local/bin/serio /usr/local/bin/sersh'

RUN /bin/bash -c 'git clone https://github.com/tbird20d/serlogin.git /usr/local/src/serlogin ;  chown -R jenkins /usr/local/src/serlogin ; cp /usr/local/src/serlogin/serlogin /usr/local/bin'

# ==============================================================================
# fserver
# ==============================================================================

RUN /bin/bash -c 'git clone https://github.com/tbird20d/fserver.git /usr/local/lib/fserver ; \
  ln -s /usr/local/lib/fserver/start_local_bg_server /usr/local/bin/start_local_bg_server'

# ==============================================================================
# Jenkins post installation
# ==============================================================================

RUN source /etc/default/jenkins && \
	JENKINS_ARGS="$JENKINS_ARGS --prefix=/fuego" && \
	sed -i -e "s#JENKINS_ARGS.*#JENKINS_ARGS\=\"${JENKINS_ARGS}\"#g" /etc/default/jenkins

RUN source /etc/default/jenkins && \
	JAVA_ARGS="$JAVA_ARGS -Djenkins.install.runSetupWizard=false -Dhudson.model.DirectoryBrowserSupport.allowSymlinkEscape=true" && \
	if [ -n "$HTTP_PROXY" ]; then \
		PROXYSERVER=$(echo $http_proxy | sed -E 's/^http://' | sed -E 's/\///g' | sed -E 's/(.*):(.*)/\1/') && \
		PROXYPORT=$(echo $http_proxy | sed -E 's/^http://' | sed -E 's/\///g' | sed -E 's/(.*):(.*)/\2/') && \
		JAVA_ARGS="$JAVA_ARGS -Dhttp.proxyHost="${PROXYSERVER}" -Dhttp.proxyPort="${PROXYPORT}" -Dhttps.proxyHost="${PROXYSERVER}" -Dhttps.proxyPort="${PROXYPORT}; \
	fi && \
	sed -i -e "s#^JAVA_ARGS.*#JAVA_ARGS\=\"${JAVA_ARGS}\"#g" /etc/default/jenkins;

RUN sed -i -e "s#8080#$JENKINS_PORT#g" /etc/default/jenkins

# set up Jenkins plugins
COPY frontend-install/install-plugins.sh \
    frontend-install/jenkins-support \
    frontend-install/clitest \
    /usr/local/bin/

# start Jenkins onces to initialize directories?
RUN service jenkins start && \
	sleep 30 && \
    service jenkins stop

# install plugins - these versions are for Jenkins version 2.164.2
# Explicitly install script-security v1.68, otherwise
# v1.74 will automatically be installed as a dependency of
# the junit plugin. Make sure to install before junit plugin.
# Explicitly install junit:1.27

# install other plugins from Jenkins update center
# NOTE: not sure all of these are needed, but keep list
# as compatible as possible with 1.2.1 release for now
# Do NOT change the order of the plugins, unless you know what
# you are doing.  Otherwise, the install-plugins.sh script will
# install the wrong versions of other plugins based on dependency
# information in the plugin files.

#RUN /usr/local/bin/install-plugins.sh \
#    script-security:1.68 \
#    structs:1.20 \
#    workflow-step-api:2.22 \
#    workflow-api:2.40 \
#    junit:1.27 \
#    scm-api:2.6.3 \
#    ant:1.9 \
#    antisamy-markup-formatter:1.5 \
#    bouncycastle-api:2.17 \
#    command-launcher:1.3 \
#    description-setter:1.10 \
#    display-url-api:2.3.1 \
#    external-monitor-job:1.7 \
#    greenballs:1.15 \
#    icon-shim:2.0.3 \
#    javadoc:1.5 \
#    jdk-tool:1.2 \
#    ldap:1.20 \
#    mailer:1.23 \
#    matrix-auth:2.3 \
#    matrix-project:1.14 \
#    pam-auth:1.5 \
#    pegdown-formatter:1.3 \
#    windows-slaves:1.4

# install plugins for latest LTS Jenkins (currently 2.249.3)
RUN /usr/local/bin/install-plugins.sh \
    script-security \
    structs \
    workflow-step-api \
    workflow-api \
    junit \
    scm-api \
    ant \
    antisamy-markup-formatter \
    bouncycastle-api \
    command-launcher \
    description-setter \
    display-url-api \
    external-monitor-job \
    greenballs \
    icon-shim \
    javadoc \
    jdk-tool \
    mailer \
    matrix-auth \
    matrix-project \
    pam-auth \
    pegdown-formatter \
    windows-slaves

COPY frontend-install/plugins/flot-plotter-plugin/flot.hpi $JENKINS_HOME/plugins/flot.jpi

# jenkins should automatically unzip any plugins in the plugin dir
# make a symlink for mod.js well after flot is installed
RUN service jenkins start && sleep 30 && \
    rm $JENKINS_HOME/plugins/flot/flot/mod.js && \
    ln -s /fuego-core/scripts/mod.js $JENKINS_HOME/plugins/flot/flot/mod.js

RUN ln -s /fuego-rw/logs $JENKINS_HOME/userContent/fuego.logs
COPY docs/fuego-docs.pdf $JENKINS_HOME/userContent/docs/fuego-docs.pdf

COPY frontend-install/config.xml $JENKINS_HOME/config.xml
COPY frontend-install/jenkins.model.JenkinsLocationConfiguration.xml $JENKINS_HOME/jenkins.model.JenkinsLocationConfiguration.xml
RUN sed -i -e "s#8080#$JENKINS_PORT#g" $JENKINS_HOME/jenkins.model.JenkinsLocationConfiguration.xml

RUN chown -R jenkins:jenkins $JENKINS_HOME/

# ==============================================================================
# ftc post installation
# ==============================================================================

RUN ln -s /fuego-core/scripts/ftc /usr/local/bin/
COPY fuego-core/scripts/ftc_completion.sh /etc/bash_completion.d/ftc
RUN echo ". /etc/bash_completion" >> /root/.bashrc

# ==============================================================================
# Lava
# ==============================================================================

RUN ln -s /fuego-ro/scripts/fuego-lava-target-setup /usr/local/bin
RUN ln -s /fuego-ro/scripts/fuego-lava-target-teardown /usr/local/bin

# ==============================================================================
# Setup startup command
# ==============================================================================

# FIXTHIS: when running multiple Fuego containers, or if the host is already
#  running the netperf server, netperf will complain because the port is taken
ENTRYPOINT service jenkins start && service netperf start && iperf3 -V -s -D -f M && /bin/bash
