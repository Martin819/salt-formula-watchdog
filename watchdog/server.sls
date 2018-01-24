{%- from "watchdog/map.jinja" import server with context %}
{%- if server.enabled %}

watchdog_packages:
  pkg.installed:
    - name: watchdog

{%- if server.kernel_module is defined %}
/etc/default/watchdog:
  file.replace:
    - name: /etc/default/watchdog
    - pattern: ^watchdog_module=.*
    - repl: watchdog_module="{{ server.kernel_module }}"
    - require:
      - pkg: watchdog_packages

{%- if server.kernel.parameters %}
/etc/modprobe.d/kernel_module.conf:
  file.managed:
    - name: /etc/modprobe.d/{{ server.kernel_module }}.conf
    - template: jinja
    - source: salt://watchdog/files/kernel_module.conf
    - require:
      - pkg: watchdog_packages
    - require_in: watchdog_service
{%- endif %}
{%- endif %}

/etc/watchdog.conf:
  file.managed:
    - name: /etc/watchdog.conf
    - template: jinja
    - source: salt://watchdog/files/watchdog.conf
    - require:
      - pkg: watchdog_packages

watchdog_service:
  service.running:
    - enable: true
    - name: watchdog
    - watch:
      - file: /etc/watchdog.conf
      - file: /etc/default/watchdog

{%- endif %}
