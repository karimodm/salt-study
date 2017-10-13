nginx:
  ng:
   install_from_repo: true
   server:
     worker_processes: 4
     events:
       worker_connections: 19000
     worker_rlimit_nofile: 20000
   servers:
    managed:
      default:
        enabled: False
        config:
      api:
        enabled: True
        config:
          - server:
            - listen:
              - 0.0.0.0:8080
              - ssl
              - proxy_protocol
              - default_server
            - server_tokens:
              - "off"
            - ssl_certificate:
              - /etc/ssl/private/hostcert.crt
            - ssl_certificate_key:
              - /etc/ssl/private/hostcert.key
            - ssl_dhparam:
              - /etc/ssl/private/dhparam.pem
            - ssl_protocols:
              - "TLSv1.2 TLSv1.1 TLSv1"
            - ssl_session_cache:
              - "shared:SSL:20m"
            - ssl_session_timeout:
              - 180m
            - ssl_prefer_server_ciphers:
              - "on"
            - ssl_ciphers:
              - "ECDH+AESGCM:ECDH+AES256:ECDH+AES128:DHE+AES128:!ADH:!AECDH:!MD5"
            - real_ip_header:
              - proxy_protocol
            - set_real_ip_from:
              - 207.154.245.182/32
            - set_real_ip_from:
              - 46.101.129.115/32
            - set_real_ip_from:
              - 46.101.117.77/32
            - set_real_ip_from:
              - 127.0.0.1/8
            - location /:
              - proxy_pass:
                - http://127.0.0.1:9001
              - proxy_set_header:
                - "X-Real-IP $proxy_protocol_addr"
              - proxy_set_header:
                - "X-Forwarded-For $proxy_protocol_addr"
              - rewrite: "^/status$ /mongo_info last"
