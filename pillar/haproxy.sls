haproxy:
  defaults:
    mode: tcp
  global:
    httpstats:
      enable: yes
      port: 12000
  frontends:
    nginx:
      bind: 0.0.0.0:443
      default_backend: nginx
  backends:
    nginx:
      options: "httpchk GET /status"
      defaultserver:
        inter: "10s fall 2 rise 3"
      servers:
        nginx-01:
          name: nginx-01
          host: av-test01
          port: 8080
          check: "send-proxy check check-ssl ca-file /usr/local/share/ca-certificates/ca-test.crt verify required"
        nginx-02:
          name: nginx-02
          host: av-test02
          port: 8080
          check: "send-proxy check check-ssl ca-file /usr/local/share/ca-certificates/ca-test.crt verify required"
        nginx-03:
          name: nginx-03
          host: av-test03
          port: 8080
          check: "send-proxy check check-ssl ca-file /usr/local/share/ca-certificates/ca-test.crt verify required"
