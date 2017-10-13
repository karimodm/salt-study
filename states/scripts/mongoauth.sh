#!/bin/bash

{%- set mongo_adminuser = salt['pillar.get']('secrets:mongo_adminuser') %}
{%- set mongo_adminpass = salt['pillar.get']('secrets:mongo_adminpass') %}
{%- set mongo_user = salt['pillar.get']('secrets:mongo_user') %}
{%- set mongo_pass = salt['pillar.get']('secrets:mongo_pass') %}

set -x

if grep -q 'authorization: enabled' /etc/mongod.conf; then
  exit 0
fi

mongo --ssl --sslAllowInvalidHostnames --sslCAFile /usr/local/share/ca-certificates/ca-test.crt admin <<<'db.createUser( { user: "{{ mongo_adminuser }}", pwd: "{{ mongo_adminpass }}", roles: [ { role: "root", db: "admin" }, { role: "userAdminAnyDatabase", db: "admin" } ] })'

cat >>/etc/mongod.conf <<EOF
security:
  authorization: enabled
EOF

service mongod restart

mongo --ssl --sslAllowInvalidHostnames --sslCAFile /usr/local/share/ca-certificates/ca-test.crt -u {{ mongo_adminuser }} -p {{ mongo_adminpass }} --authenticationDatabase "admin" app <<<'db.createUser( { user: "{{ mongo_user }}", pwd: "{{ mongo_pass }}", roles: [ { role: "readWrite", db: "app" } ] } )'

cat >>/etc/mongod.conf <<EOF
replication:
  replSetName: rs0
EOF

service mongod restart

mongo --ssl --sslAllowInvalidHostnames --sslCAFile /usr/local/share/ca-certificates/ca-test.crt -u {{ mongo_adminuser }} -p {{ mongo_adminpass }} --authenticationDatabase "admin" admin <<<'rs.initiate( { _id : "rs0", members: [ { _id : 0, host : "av-test01" }, { _id : 1, host : "av-test02" }, { _id : 2, host : "av-test03", arbiterOnly: true } ] } )'
