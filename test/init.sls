python-pip:
  pkg.installed

pika:
  pip.installed:
    - require:
      - pkg: python-pip

/root/send.py:
  file.managed:
    - source: salt://rabbitmq/test/files/send.py

/root/sendhaproxy.py:
  file.managed:
    - source: salt://rabbitmq/test/files/sendhaproxy.py
    - template: jinja

/root/recieve.py:
  file.managed:
    - source: salt://rabbitmq/test/files/recieve.py

/root/recievehaproxy.py:
  file.managed:
    - source: salt://rabbitmq/test/files/recievehaproxy.py
    - template: jinja
