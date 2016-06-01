all-packages:
  pkg.installed:
    - pkgs:
      - nano
      - wget
      - java-1.8.0-openjdk.x86_64
      - nginx
      - openssl-devel
      - python-devel
      - libffi-devel
      - python-pip
      - setools-console
      - gcc

/sbin/setenforce 0:
  cmd.run

/etc/sysconfig/selinux:
  file.managed:
    - source:
      - salt://jenkins_creator_copy/provisioning/misc/selinux_config

py_packages:
  pip.installed:
    - pkgs:
      - pyOpenSSL
    - require:
      - pkg: all-packages

jenkins.repo:
  pkgrepo.managed:
    - humanname: jenkins.repo
    - baseurl: http://pkg.jenkins-ci.org/redhat/
    - gpgkey: https://jenkins-ci.org/redhat/jenkins-ci.org.key
    - gpgcheck: 1

jenkins_user:
  group.present:
    - name: jenkins
    - gid: 4001
  user.present:
    - name: jenkins
    - fullname: Jenkins User
    - shell: /bin/bash
    - home: /home/jenkins
    - uid: 4001
    - gid: 4001
    - require:
      - group: jenkins_user
  file.managed:
    - name: /home/jenkins/.ssh/authorized_keys
    - user: jenkins
    - group: jenkins
    - mode: 644
    - source:
      - salt://jenkins_creator_copy/provisioning/terraform/mac_key.pub

jenkins_sudo_user:
  group.present:
    - name: jenkins_sudo
    - gid: 4002
  user.present:
    - name: jenkins_sudo
    - fullname: Jenkins Sudo User
    - shell: /bin/bash
    - home: /home/jenkins_sudo
    - uid: 4002
    - gid: 4002
    - require:
      - group: jenkins_sudo_user
  file.managed:
    - name: /home/jenkins_sudo/.ssh/authorized_keys
    - user: jenkins_sudo
    - group: jenkins_sudo
    - mode: 644
    - source:
      - salt://jenkins_creator_copy/provisioning/terraform/mac_key.pub

jenkins:
  pkg:
    - installed
    - require:
      - pkg: all-packages
      - pkgrepo: jenkins.repo
      - user: jenkins_user
  service.running:
    - enable: True

jenkins_config_repo:
  cmd.run:
    - names:
      - git config --global user.name "The Victor"
      - git config --global user.email "the.victor@gmail.com"
    - user: jenkins
    - require:
      - user: jenkins_user

do_cert:
  module.run:
    - name: tls.create_self_signed_cert
    - require:
      - pip: py_packages
    - CN: "localhost"
    - ST: "MD"
    - L: "Rockville"
    - O: "MCJUG"
    - cacert_path: "/etc/nginx"
    - tls_dir: "ssl"

/etc/nginx/conf.d/jenkins_nginx.conf:
  file.managed:
    - source:
      - salt://jenkins_creator_copy/provisioning/misc/jenkins_nginx.conf
    - require:
      - pkg: all-packages

nginx:
  service.running:
    - enable: True
    - require:
      - pkg: all-packages
      - file: /etc/nginx/conf.d/jenkins_nginx.conf

{% if not salt['file.file_exists' ]('/home/jenkins/.ssh/id_rsa') %}
/home/jenkins/.ssh/:
  file.directory:
    - user: jenkins
    - group: jenkins
    - mode: 755
    - makedirs: True
    - require:
      - service: jenkins

generate_ssh_key_jenkins:
  cmd.run:
    - name: ssh-keygen -q -N '' -f /home/jenkins/.ssh/id_rsa
    - user: jenkins
    - require:
      - file: /home/jenkins/.ssh/
{% endif %}
