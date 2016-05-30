# jenkins_creator

Once the box is up make sure you can do a git pull/push from/to git@github.com:mcjug2015/jenkins_config.git You may need to add githubs key and do:
```
git config --global user.name "The Victor"
git config --global user.email "the.victor@gmail.com"
```
For the backup job don't forget to install ssh plugin and put the jenkins public key into mcasg.org. ssh to it from commandline to be sure that it works.