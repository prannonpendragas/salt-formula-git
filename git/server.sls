{%- from "git/map.jinja" import server with context %}

{%- if server.enabled %}

git_packages:
  pkg.installed:
  - names: {{ server.pkgs }}

{{ server.directory }}:
  file.directory:
    - user: {{ server.user }}
    - group: {{ server.group }}
    - dir_mode: 755
    - file_mode: 644

{%- for repo|unique in server.get('repos',{}) %}

{%- if repo.url is defined %}

git_server_{{ repo.name }}:
  git.latest:
    - name: {{ repo.url }}
    - target: {{ server.directory }}/{{ repo.name }}
    - require:
        - file: {{ server.directory }}

{%- else %}

git_server_{{ repo.name }}:
  git.present:
    - name: {{ server.directory }}/{{ repo.name }}
    - force: True
    - require:
        - file: {{ server.directory }}

{%- endif %}

{%- endfor %}
{%- endif %}
