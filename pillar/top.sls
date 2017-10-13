base:
  '*':
    - common
    - haproxy
    - nginx
    - mongodb
    - secrets
  av-test01:
    - secrets_av-test-01
  av-test02:
    - secrets_av-test-02
  av-test03:
    - secrets_av-test-03
