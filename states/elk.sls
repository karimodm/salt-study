docker_key:
  cmd.run:
    - name: curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

docker_repo:
  pkgrepo.managed:
    - humanname: Docker Repo
    - name: deb [arch=amd64] https://download.docker.com/linux/debian jessie stable
    - require:
      - docker_key

docker-ce:
  pkg.installed:
    - require:
      - docker_repo

docker:
  service.running:
    - enable: true
    - require:
      - pkg: docker-ce

/etc/elkstack.yml:
  file.managed:
    - source: salt://files/elk.yml

/etc/systemd/system/elkstack.service:
  file.managed:
    - source: salt://files/elkstack.service
    - mode: 0644
    - require:
      - /etc/elkstack.yml
      - service: docker

systemctl_reload_elkstack:
  cmd.run:
    - name: systemctl daemon-reload
    - require:
      - /etc/systemd/system/elkstack.service

/usr/local/bin/docker-compose:
  file.managed:
    - source: https://github.com/docker/compose/releases/download/1.16.1/docker-compose-Linux-x86_64
    - source_hash: e2c7c848e1fa388a2e5b8945fdb2660bf8d8adb1
    - mode: 0755

elkstack:
  service.running:
    - enable: True
