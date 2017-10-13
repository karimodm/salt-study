/app:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

/app/logs:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

basic_deps:
  pkg.installed:
    - pkgs:
      - python3-dev
      - build-essential
      - wget
      - virtualenv

install_conda:
  cmd.run:
    - name: wget --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/conda.sh && bash /tmp/conda.sh -p /usr/local/conda -b || true
    - require: 
      - basic_deps

# BROKEN TO AVOID REFERENCE
deploy_app:
  cmd.run:
    - name: cd /app && wget --quiet https://s3.eu-central-1.amazonaws.com/XXXXX-exchange-0a5k/srtest95g0/ops_test.tar.gz -O - | tar zxf - --strip-components=1
    - require:
      - basic_deps
      - file: /app

install_app:
  cmd.run:
    - name: /usr/local/conda/bin/conda create --copy -p /app; cd /app && source bin/activate && pip install -r requirements.txt
    - require:
      - deploy_app

/app/wsgi.py:
  file.managed:
    - source: salt://files/wsgi.py

/app/bin/gunicorn:
  file.managed:
    - source: salt://files/gunicorn
    - mode: 0755

configure_app:
  file.managed:
    - name: /app/config/conf.yaml
    - source: salt://templates/app.conf.yml
    - template: jinja

/etc/systemd/system/gunicorn.service:
  file.managed:
    - source: salt://files/gunicorn.service
    - mode: 0644
    - require:
      - configure_app

systemctl_reload_gunicorn:
  cmd.run:
    - name: systemctl daemon-reload
    - require:
      - /etc/systemd/system/gunicorn.service

gunicorn:
  service.running:
    - enable: True

