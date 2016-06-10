rabbitmq:
  # version: "3.5.3-1"
  plugin:
    rabbitmq_management:
      - enabled
  policy:
    rabbitmq_policy:
      - name: HA
      - pattern: '.*'
      - definition: '{"ha-mode": "all"}'
  vhost:
    virtual_host:
      - owner: rabbit_user
      - conf: .*
      - write: .*
      - read: .*
  user:
    rabbit:
      - password: changeme
      - force: True
      - tags: monitoring, user
      - perms:
        - '/':
          - '.*'
          - '.*'
          - '.*'
      - runas: root

  cookie: DIKGMNZLSOBOPJGMXDQB
  inet_dist_listen_min: 60000
  inet_dist_listen_max: 60010

mine_functions:
  internal_ips:
    mine_function: network.ipaddrs
    interface: eth2
  external_ips:
    mine_function: network.ipaddrs
    interface: eth0
  id:
    - mine_function: grains.get
    - id
  host:
    - mine_function: grains.get
    - host

user-ports:
  ssh:
    chain: INPUT
    proto: tcp
    dport: 22
  salt-master:
    chain: INPUT
    proto: tcp
    dport: 4505
  salt-minion:
    chain: INPUT
    proto: tcp
    dport: 4506
  epmd:
    chain: INPUT
    proto: tcp
    dport: 4369
  erlang_distribution:
    chain: INPUT
    proto: tcp
    dport: 25672
  aqmp:
    chain: INPUT
    proto: tcp
    dport: 5672
  aqmp_tls:
    chain: INPUT
    proto: tcp
    dport: 5671
  management_plugin:
    chain: INPUT
    proto: tcp
    dport: 15672
  stomp:
    chain: INPUT
    proto: tcp
    dport: 61613
  stomp_other:
    chain: INPUT
    proto: tcp
    dport: 61614
  mqtt:
    chain: INPUT
    proto: tcp
    dport: 1883
  mqtt_other:
    chain: INPUT
    proto: tcp
    dport: 8883
  inet_dist_listen:
    chain: INPUT
    proto: tcp
    dport: 60000:60010
  http:
    chain: INPUT
    proto: tcp
    dport: 80
