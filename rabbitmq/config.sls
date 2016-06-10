{%- set cookie = salt['pillar.get']('rabbitmq:cookie', 'CHANGEMEEEEEEEEEEEEE') -%}
{%- set cookie_file = '/var/lib/rabbitmq/.erlang.cookie' %}
/etc/rabbitmq/rabbitmq.config:
  file.managed:
    - source: salt://rabbitmq/rabbitmq/files/rabbitmq.jinja2
    - template: jinja
    - watch_in:
      - service: rabbitmq-server

# Need to stop rabbit before changing the cookie.
kill-rabbitmq:
  service.dead:
    - name: rabbitmq-server
    - unless:
      - grep -Fxq "{{ cookie }}" {{ cookie_file }}
    - require:
      - pkg: rabbitmq-server

{{ cookie_file }}:
  file.managed:
    - source: salt://rabbitmq/rabbitmq/files/.erlang.cookie.jinja2
    - mode: 600
    - template: jinja
    - unless:
      - grep -Fxq "{{ cookie }}" {{ cookie_file }}
    - watch_in:
      - service: rabbitmq-server
    - require:
      - service: kill-rabbitmq
      - pkg: rabbitmq-server

{% for name, plugin in salt["pillar.get"]("rabbitmq:plugin", {}).items() %}
{{ name }}:
  rabbitmq_plugin:
    {% for value in plugin %}
    - {{ value }}
    {% endfor %}
    - runas: root
    - require:
      - pkg: rabbitmq-server
      - file: rabbitmq_binary_tool_plugins
    - watch_in:
      - service: rabbitmq-server
{% endfor %}

{% for name, policy in salt["pillar.get"]("rabbitmq:policy", {}).items() %}
{{ name }}:
  rabbitmq_policy.present:
    {% for value in policy %}
    - {{ value }}
    {% endfor %}
    - require:
      - service: rabbitmq-server
{% endfor %}

# need to create users and then vhosts

{% for name, user in salt["pillar.get"]("rabbitmq:user", {}).items() %}
rabbitmq_user_{{ name }}:
  rabbitmq_user.present:
    - name: {{ name }}
    {% for value in user %}
    - {{ value }}
    {% endfor %}
    - require:
      - service: rabbitmq-server
{% endfor %}

{% for name, policy in salt["pillar.get"]("rabbitmq:vhost", {}).items() %}
rabbitmq_vhost_{{ name }}:
  rabbitmq_vhost.present:
    - name: {{ name }}
    {% for value in policy %}
    - {{ value }}
    {% endfor %}
    - require:
      - service: rabbitmq-server
{% endfor %}
