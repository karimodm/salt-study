{%- set mongo_adminuser = salt['pillar.get']('secrets:mongo_user') %}
{%- set mongo_adminpass = salt['pillar.get']('secrets:mongo_pass') %}
{%- set mongo_user = salt['pillar.get']('secrets:mongo_user') %}
{%- set mongo_pass = salt['pillar.get']('secrets:mongo_pass') %}

salt://scripts/mongoauth.sh:
  cmd.script:
    - template: jinja
