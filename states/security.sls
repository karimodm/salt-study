fail2ban:
  pkg.installed: []

iptables-persistent:
  pkg.installed: []

/etc/iptables/rules.v4:
  file.managed:
    - source: salt://templates/firewallrules.jinja
    - template: jinja

#iptables-restore </etc/iptables/rules.v4:
#  cmd.run:
#    - require:
#      - file: /etc/iptables/rules.v4
