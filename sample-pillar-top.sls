base:
  'roles:rabbitmq':
    - match: grain
    - rabbitmq

  'roles:rabbitmq-haproxy':
    - match: grain
    - rabbitmq
