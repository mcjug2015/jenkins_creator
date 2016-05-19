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
      - pkg: misc-packages
      - pkgrepo: jenkins.repo
  service.running:
    - enable: True

misc-packages:
  pkg.installed:
    - pkgs:
      - nano
      - wget
      - java-1.8.0-openjdk.x86_64
      - nginx

openssl-packages:
  pkg.installed:
    - pkgs:
      - openssl-devel
      - python-devel
      - libffi-devel
      - python-pip

pyOpenSSL:
  pip.installed:
    - require:
      - pkg: openssl-packages
