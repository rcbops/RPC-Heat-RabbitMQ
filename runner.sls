mine.update:
  salt.function:
    - tgt: '*'

deploy:
  salt.state:
    - tgt: 'G@roles:rabbitmq or G@roles:rabbitmq-haproxy'
    - tgt_type: compound
    - highstate: True
    - require:
      - salt: mine.update

hardening:
  salt.state:
    - tgt: '*'
    - sls:
      - rabbitmq.hardening
    - require:
      - salt: deploy
