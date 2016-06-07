# jenkins_creator

Once the box is up make sure you can do a git pull/push from/to git@github.com:mcjug2015/jenkins_config.git. For the backup job don't forget to install ssh plugin and put the jenkins public key into mcasg.org. ssh to it from commandline to be sure that it works.

If knocking doesn't work, check provisioning/misc/knockd.conf, it may be listening on the wrong interface. You may have to reprovision since box starts out non-sshable.