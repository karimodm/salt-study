include:
  - haproxy
  - nginx
  - mongodb

base:
  '*':
    - common
    - haproxy.install
    - haproxy.config
    - nginx.ng
    - mongodb
    - mongodb.tools
    - apiapp
    - pokeservices
    - security
    - logs
  av-test01:
    - mongousers_replicaset
    - elk
  av-test02:
    - mongoauth
  av-test03:
    - mongoauth
