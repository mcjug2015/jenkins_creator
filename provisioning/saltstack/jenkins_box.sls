jenkins.repo:
  pkgrepo.managed:
    - humanname: jenkins.repo
    - baseurl: http://pkg.jenkins-ci.org/redhat/
    - gpgkey: https://jenkins-ci.org/redhat/jenkins-ci.org.key
    - gpgcheck: 1

jenkins:
  pkg:
    - installed
    - require:
      - pkg: java-1.8.0-openjdk.x86_64
      - pkgrepo: jenkins.repo

nano:
  pkg:
    - installed

wget:
  pkg:
    - installed

java-1.8.0-openjdk.x86_64:
  pkg:
    - installed