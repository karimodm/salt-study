/etc/mongod.conf:
  file.append:
    - text:
      - "security:"
      - "  authorization: enabled"
      - "replication:"
      - "  replSetName: rs0"

service mongod restart:
  cmd.run: []
