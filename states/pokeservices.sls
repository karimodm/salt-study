systemctl restart mongod nginx gunicorn:
  cmd.run: []

/etc/systemd/system/haproxy.service.d/throttle_restart.conf:
  file.managed:
    - source: salt://files/haproxy-throttle_restart.conf
    - makedirs: true
