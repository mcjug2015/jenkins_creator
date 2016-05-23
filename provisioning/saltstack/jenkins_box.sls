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

/sbin/setenforce 0:
  cmd.run

/etc/sysconfig/selinux:
  file.managed:
    - source:
      - salt://jenkins_creator_copy/provisioning/misc/selinux_config

pyOpenSSL:
  pip.installed:
    - require:
      - pkg: all-packages

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
      - pkg: all-packages
      - pkgrepo: jenkins.repo
  service.running:
    - enable: True

do_cert:
  module.run:
    - name: tls.create_self_signed_cert
    - require:
      - pip: pyOpenSSL
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

{% if not salt['file.file_exists' ]('/etc/jenkins_stuff/.ssh/id_rsa') %}
/etc/jenkins_stuff/.ssh/:
  file.directory:
    - user: jenkins
    - group: jenkins
    - mode: 755
    - makedirs: True
    - require:
      - service: jenkins

generate_ssh_key_jenkins:
  cmd.run:
    - name: ssh-keygen -q -N '' -f /etc/jenkins_stuff/.ssh/id_rsa
    - user: jenkins
    - require:
      - file: /etc/jenkins_stuff/.ssh/
{% endif %}
