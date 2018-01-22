{%- from "watchdog/map.jinja" import server with context %}
{%- if server.enabled %}

watchdog_packages:
  pkg.installed:
    - name: watchdog

/etc/watchdog.conf:
  file.managed:
    - name: /etc/watchdog.conf
    - template: jinja
    - source: salt://watchdog/files/watchdog.conf
    - require:
      - watchdog_packages

watchdog_service:
  service.running:
    - enable: true
    - name: watchdog
    - watch:
      - file: /etc/watchdog.conf

{%- endif %}
