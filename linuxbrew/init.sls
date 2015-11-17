{% from "linuxbrew/map.jinja" import linuxbrew_pkgs with context %}

{%- set user = salt['pillar.get']('user', 'root') -%}
{%- set home = "/%s" % user -%}
{%- if user != 'root' -%}
{%- set home = "/home%s" % home -%}
{%- endif -%}

linuxbrew-pkgs:
  pkg.installed:
    - pkgs: {{ linuxbrew_pkgs.pkgs|json }}

{% if grains['os_family']=="RedHat" %}
linuxbrew-group-pkg:
  pkg.group_installed:
    - name: Development Tools
{% endif %}

get-linuxbrew:
  git.latest:
    - name: https://github.com/Homebrew/linuxbrew
    - target: {{ home }}/.linuxbrew
    - user: {{ user }}
    - unless: test -d {{ home }}/.linuxbrew

set-env:
  file.append:
    - name: {{ home }}/.bashrc
    - text: |
        export PATH="$HOME/.linuxbrew/bin:$PATH"
        export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
        export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"
