ppa-sauce:
  pkgrepo.managed:
    - ppa: devel-k/log-courier
    - require_in:
      - pkg: log-courier


log-courier-pkg:
  pkg.installed:
    - name: log-courier

log-courier-service:
  service.running:
    - name: log-courier
    - enable: True
    - reload: True
    - watch:
      - file: /etc/log-courier/log-courier.conf
    - require:
      - file: /etc/log-courier/log-courier.conf
      - file: /etc/log-courier/selfsigned.crt
      - cmd: add-runlevel



/etc/log-courier/selfsigned.crt:
  file.managed:
    - source: salt://log-courier/selfsigned.crt
    - user: root
    - require:
      - pkg: log-courier


/etc/log-courier/log-courier.conf:
  file.managed:
    - source: salt://log-courier/log-courier.conf
    - user: root
    - require:
      - pkg: log-courier
      - file: /etc/log-courier/selfsigned.crt

add-runlevel:
  cmd.run:
    - name: update-rc.d log-courier defaults
    - creates: /etc/rc2.d/S20log-courier
    - require:
      - pkg: log-courier
