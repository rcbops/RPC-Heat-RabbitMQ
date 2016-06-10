base:

  'roles:rabbitmq':
    - match: grain
    - rabbitmq.rabbitmq

  'roles:rabbitmq-haproxy':
    - match: grain
    - rabbitmq.haproxy
