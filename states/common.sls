/etc/cloud/templates/hosts.debian.tmpl:
  file.append:
    - text:
      - "207.154.245.182   av-test01"
      - "46.101.129.115    av-test02"
      - "46.101.117.77     av-test03"

av-test01:
  host.present:
    - ip: 207.154.245.182

av-test02:
  host.present:
    - ip: 46.101.129.115

av-test03:
  host.present:
    - ip: 46.101.117.77

/usr/local/share/ca-certificates/ca-test.crt:
  file.managed:
    - source: salt://files/ca-cacert.pem

update-ca-certificates:
  cmd.run:
    - require:
      - /usr/local/share/ca-certificates/ca-test.crt

test -f /etc/ssl/private/dhparam.pem || openssl dhparam -out /etc/ssl/private/dhparam.pem 4096:
  cmd.run: []

setfacl -m user:mongodb:rx /etc/ssl/private:
  cmd.run: []

/etc/ssl/private/hostcert.crt:
  file.managed:
    - contents_pillar: secrets:cert

/etc/ssl/private/hostcert.key:
  file.managed:
    - contents_pillar: secrets:certkey

cat /etc/ssl/private/hostcert.crt /etc/ssl/private/hostcert.key > /etc/ssl/private/hostcert.pem:
  cmd.run:
    - require:
      - /etc/ssl/private/hostcert.crt
      - /etc/ssl/private/hostcert.key

/etc/ssl/private/mongocert.crt:
  file.managed:
    - contents_pillar: secrets:mongo_cert

/etc/ssl/private/mongocert.key:
  file.managed:
    - contents_pillar: secrets:mongo_certkey

cat /etc/ssl/private/mongocert.crt /etc/ssl/private/mongocert.key > /etc/ssl/private/mongocert.pem:
  cmd.run:
    - require:
      - /etc/ssl/private/mongocert.crt
      - /etc/ssl/private/mongocert.key

/etc/mongodb.key:
  file.managed:
    - contents_pillar: secrets:mongo_replication_keyfile
    - user: mongodb
    - group: mongodb
    - mode: 0600
