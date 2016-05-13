#!/bin/bash


# install saltstack globally, invoke saltstack top. this will be invoked by cloud init and vagrant.
/usr/bin/curl -o /tmp/epel-release.rpm http://mirror.sfo12.us.leaseweb.net/epel/7/x86_64/e/epel-release-7-6.noarch.rpm
/usr/bin/rpm -Uvh /tmp/epel-release.rpm
/usr/bin/yum install -y salt-minion