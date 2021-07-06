#!/bin/bash
# 2021 (c) Toshiba corp.
#
# Install Jenkins specific
set -e

JENKINS_PORT=${1:-8090}
JENKINS_VERSION=${2:-2.249.3}
JENKINS_SHA=${3:-534014c007edbb533a1833fe6f2dc115faf3faa2}
uid=${4:-}
gid=${5:-}

JENKINS_URL=https://pkg.jenkins.io/debian-stable/binary/jenkins_${JENKINS_VERSION}_all.deb
export JENKINS_UC=https://updates.jenkins.io
export REF=/var/lib/jenkins/plugins
export JENKINS_HOME=/var/lib/jenkins
export JENKINS_PORT=$JENKINS_PORT

# Jenkins dependencies
apt-get -q=2 -V --no-install-recommends install \
    default-jdk daemon psmisc adduser procps unzip
pip install python-jenkins==1.4.0

echo -e "JENKINS_PORT=$JENKINS_PORT" >> /etc/environment

if [ -z $gid ]; then
    getent group jenkins >/dev/null || groupadd jenkins
else
    getent group ${gid} >/dev/null || groupadd -g ${gid} jenkins
fi

if [ -z $uid ]; then
    id jenkins >/dev/null 2>&1 || useradd -l -m -d "${JENKINS_HOME}" -g jenkins -G sudo -s /bin/bash jenkins
else
    id jenkins >/dev/null 2>&1 || useradd -l -m -d "${JENKINS_HOME}" -u ${uid} -g ${gid} -G sudo -s /bin/bash jenkins
fi

wget -nv ${JENKINS_URL}
echo "${JENKINS_SHA} jenkins_${JENKINS_VERSION}_all.deb" | sha1sum -c -

# allow Jenkins to start and install plugins, as part of dpkg installation
printf "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d
dpkg -i jenkins_${JENKINS_VERSION}_all.deb
rm jenkins_${JENKINS_VERSION}_all.deb

# ==============================================================================
# Jenkins post installation
# ==============================================================================
source /etc/default/jenkins && \
    JENKINS_ARGS="$JENKINS_ARGS --prefix=/fuego" && \
    sed -i -e "s#JENKINS_ARGS.*#JENKINS_ARGS\=\"${JENKINS_ARGS}\"#g" /etc/default/jenkins

source /etc/default/jenkins && \
    JAVA_ARGS="$JAVA_ARGS -Djenkins.install.runSetupWizard=false -Dhudson.model.DirectoryBrowserSupport.allowSymlinkEscape=true" && \
    if [ -n "$http_proxy" ]; then \
        PROXYSERVER=$(echo $http_proxy | sed -E 's/^http://' | sed -E 's/\///g' | sed -E 's/(.*):(.*)/\1/') && \
        PROXYPORT=$(echo $http_proxy | sed -E 's/^http://' | sed -E 's/\///g' | sed -E 's/(.*):(.*)/\2/') && \
        JAVA_ARGS="$JAVA_ARGS -Dhttp.proxyHost="${PROXYSERVER}" -Dhttp.proxyPort="${PROXYPORT}" -Dhttps.proxyHost="${PROXYSERVER}" -Dhttps.proxyPort="${PROXYPORT}; \
    fi && \
    sed -i -e "s#^JAVA_ARGS.*#JAVA_ARGS\=\"${JAVA_ARGS}\"#g" /etc/default/jenkins;

sed -i -e "s#8080#$JENKINS_PORT#g" /etc/default/jenkins

# set up Jenkins plugins
cp frontend-install/install-plugins.sh \
    frontend-install/jenkins-support \
    frontend-install/clitest \
    /usr/local/bin/

# start and stop jenkins to pre-populate some settings
service jenkins start && \
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

#/usr/local/bin/install-plugins.sh \
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
/usr/local/bin/install-plugins.sh \
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

cp frontend-install/plugins/flot-plotter-plugin/flot.hpi $JENKINS_HOME/plugins/flot.jpi

# jenkins should automatically unzip any plugins in the plugin dir
# make the mod.js symlink well after flot is installed
service jenkins start && sleep 30 && \
    rm $JENKINS_HOME/plugins/flot/flot/mod.js && \
    ln -s /fuego-core/scripts/mod.js $JENKINS_HOME/plugins/flot/flot/mod.js

mkdir -p $JENKINS_HOME/userContent/docs
ln -sf /fuego-rw/logs $JENKINS_HOME/userContent/fuego.logs
cp docs/fuego-docs.pdf $JENKINS_HOME/userContent/docs/fuego-docs.pdf

cp frontend-install/config.xml $JENKINS_HOME/config.xml
cp frontend-install/jenkins.model.JenkinsLocationConfiguration.xml $JENKINS_HOME/jenkins.model.JenkinsLocationConfiguration.xml
sed -i -e "s#8080#$JENKINS_PORT#g" $JENKINS_HOME/jenkins.model.JenkinsLocationConfiguration.xml

chown -R jenkins:jenkins $JENKINS_HOME/