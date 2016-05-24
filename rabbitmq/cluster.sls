# Make other nodes in cluster resolvable by hostname
{%- set hosts = salt['mine.get']('roles:rabbitmq', 'host', 'grain') -%}
{%- set ips = salt['mine.get']('roles:rabbitmq', 'internal_ips', 'grain') -%}
{% for id, host in hosts.items() %}
host-{{ host }}:
  host.present:
    - ip: {{ ips[id]|first }}
    - names:
      - {{ host }}
{% endfor %}

# Identify the node to join to.
{% set hosts = hosts.values() %}
{% do hosts.sort() %}
{% set master_host = hosts[0] %}
{% if salt['grains.get']('host') != master_host %}
join_to_cluster:
  rabbitmq_cluster.join:
    - host: {{ master_host }}
    - require:
      - host: host-{{ master_host }}
{% endif %}

{%- set haproxy_host = salt['mine.get']('roles:rabbitmq-haproxy', 'host', 'grain').values() -%}
{%- set haproxy_ip = salt['mine.get']('roles:rabbitmq-haproxy', 'internal_ips', 'grain').values() -%}
host-{{ haproxy_host|first }}:
  host.present:
    - ip: {{ haproxy_ip|first|first }}
    - names:
      - {{ haproxy_host|first }}

