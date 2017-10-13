base:
  '*':
    - haproxy: master
  'av-01':
    - mongodb: master
  'av-02':
    - mongodb: replica
  'av-03':
    - mongodb: arbiter
