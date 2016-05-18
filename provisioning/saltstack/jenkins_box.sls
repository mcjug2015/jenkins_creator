do_cert:
  module.run:
    - name: tls.create_self_signed_cert
    - require:
      - pkg: openssl
    - kwargs: {
          ST: "MD",
          L: "Rockville",
          O: "MCJUG",
          cacert_path: "/etc/nginx",
          tls_dir: "ssl"
      }
    - reload_modules: true

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
  service.running:
    - enable: True

nano:
  pkg:
    - installed

wget:
  pkg:
    - installed

java-1.8.0-openjdk.x86_64:
  pkg:
    - installed

nginx:
  pkg:
    - installed

openssl:
  pkg:
    - installed