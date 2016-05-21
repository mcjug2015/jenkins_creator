#!/bin/bash


# install/config saltstack globally, invoke saltstack top. this will be invoked by cloud init and vagrant.
# assumes a copy of jenkins creator lives under /tmp/jenkins_creator/
/usr/bin/curl -o /tmp/epel-release.rpm http://mirror.sfo12.us.leaseweb.net/epel/7/x86_64/e/epel-release-7-6.noarch.rpm
/usr/bin/rpm -Uvh /tmp/epel-release.rpm
/usr/bin/yum install -y salt-minion

#let salt have access to all the projects files
/usr/bin/cp -R /tmp/jenkins_creator/ /tmp/jenkins_creator/provisioning/saltstack/

/usr/bin/salt-call --log-level=debug --local state.apply --file-root=/tmp/jenkins_creator/provisioning/saltstack/