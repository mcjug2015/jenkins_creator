# jenkins_creator

Plugins needed:
Environment Injector Plugin
Hudson Post build task
SCM Sync Configuration Plugin
SSH plugin
Terraform Plugin(don't forget to configure this)

Once the box is up make sure you can do a git pull/push from/to git@github.com:mcjug2015/jenkins_config.git. For the backup job don't forget to install ssh plugin and put the jenkins public key into mcasg.org. ssh to it from commandline to be sure that it works.

If knocking doesn't work, check provisioning/misc/knockd.conf, it may be listening on the wrong interface. You may have to reprovision since box starts out non-sshable.

for aws provisioning jobs to work you'll need to do create a java properties file at /home/jenkins/secret/dt_aws/dt_aws.tfvars it will need to contain something like:
AWS_ACCESS_KEY_ID = ACCESS_KEY
AWS_SECRET_ACCESS_KEY = SECRET_KEY
DIGITALOCEAN_TOKEN = DO_TOKEN