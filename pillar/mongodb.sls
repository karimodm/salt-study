mongodb:
  lookup:
    use_repo: True
  keyid: 9ECBEC467F0CEB10
  version: 3.0
  oscode: wheezy # 3.0 is only available for this dist
  mongodb_package: mongodb-org
  mongodb_user: mongodb
  mongodb_group: mongodb
  mongod: mongod
  conf_path: /etc/mongod.conf
  log_path: /mongodb/log
  db_path: /data/mongodb
  mongod_settings:
    systemLog:
      destination: file
      logAppend: true
      path: /var/log/mongodb/mongod.log
    storage:
      engine:
        wiredTiger
      dbPath: /data/mongodb
      journal:
        enabled: true
    net:
      port: 27017
      ssl:
        mode: requireSSL
        PEMKeyFile: /etc/ssl/private/mongocert.pem
        CAFile: /usr/local/share/ca-certificates/ca-test.crt
        allowConnectionsWithoutCertificates: true
        allowInvalidHostnames: true
    security:
      keyFile: /etc/mongodb.key
      clusterAuthMode: keyFile
