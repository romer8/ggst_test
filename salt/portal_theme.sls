{% set CONDA_HOME = salt['environ.get']('CONDA_HOME') %}
{% set TETHYS_PERSIST = salt['environ.get']('TETHYS_PERSIST') %}
{% set STATIC_ROOT = salt['environ.get']('STATIC_ROOT') %}


Apply_Custom_Theme:
  cmd.run:
    - name: >
        tethys site
        --site-title "Groundwater Portal"
        --brand-text "Groundwater Portal"
        --apps-library-title "Tools"
        --primary-color "#01200F"
        --secondary-color "#358600"
        --background-color "#ffffff"
        --copyright "Copyright © 2024"
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/custom_theme_setup_complete" ];"

Flag_Custom_Theme_Setup_Complete:
  cmd.run:
    - name: touch {{ TETHYS_PERSIST }}/custom_theme_setup_complete
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/custom_theme_setup_complete" ];"