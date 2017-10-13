install_filebeat:
  cmd.run:
    - name: wget -q https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-5.6.3-amd64.deb -O /tmp/filebeat.deb && dpkg -i /tmp/filebeat.deb

/etc/filebeat/filebeat.yml:
  file.managed:
    - source: salt://files/filebeat.yml

/etc/systemd/system/filebeat.service:
  file.managed:
    - source: salt://files/filebeat.service
    - mode: 0644
    - require:
      - install_filebeat

systemctl_reload_filebeat:
  cmd.run:
    - name: systemctl daemon-reload
    - require:
      - /etc/systemd/system/filebeat.service

filebeat:
  service.running:
    - enable: True
