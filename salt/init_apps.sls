{% set CONDA_HOME = salt['environ.get']('CONDA_HOME') %}
{% set TETHYS_HOME = salt['environ.get']('TETHYS_HOME') %}
{% set TETHYS_PERSIST = salt['environ.get']('TETHYS_PERSIST') %}
{% set CONDA_PYTHON_PATH = salt['environ.get']('CONDA_PYTHON_PATH', '/opt/conda/envs/tethys/bin/python') %}
{% set EARTHDATA_PASS = salt['environ.get']('EARTHDATA_PASS', 'byuGRACE1') %}
{% set EARTHDATA_USERNAME = salt['environ.get']('EARTHDATA_USERNAME', 'byugrace') %}
{% set GLOBAL_OUTPUT_DIRECTORY = salt['environ.get']('GLOBAL_OUTPUT_DIRECTORY', '/var/lib/tethys_persist/grace_dir') %}
{% set GRACE_THREDDS_CATALOG = salt['environ.get']('GRACE_THREDDS_CATALOG', 'http://localhost:8080/thredds/catalog/testAll/ggst/catalog.html') %}
{% set GRACE_THREDDS_DIRECTORY = salt['environ.get']('GRACE_THREDDS_DIRECTORY', '/var/lib/tethys_persist/thredds_data/ggst') %}
{% set THREDDS_SERVICE_NAME = 'tethys_thredds' %}
{% set POSTGIS_SERVICE_NAME = 'tethys_postgis' %}

Sync_Apps:
  cmd.run:
    - name: >
        tethys db sync
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/init_apps_setup_complete" ];"

Set_Custom_Settings:
  cmd.run:
    - name: >
        tethys app_settings set ggst conda_python_path "{{ CONDA_PYTHON_PATH }}" &&
        tethys app_settings set ggst earthdata_pass "{{ EARTHDATA_PASS }}" &&
        tethys app_settings set ggst earthdata_username "{{ EARTHDATA_USERNAME }}" &&
        tethys app_settings set ggst global_output_directory "{{ GLOBAL_OUTPUT_DIRECTORY }}" &&
        tethys app_settings set ggst grace_thredds_catalog "{{ GRACE_THREDDS_CATALOG }}" &&
        tethys app_settings set ggst grace_thredds_directory "{{ GRACE_THREDDS_DIRECTORY }}" &&
        mkdir "{{GRACE_THREDDS_DIRECTORY}}" &&
        mkdir "{{GLOBAL_OUTPUT_DIRECTORY}}"
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/init_apps_setup_complete" ];"

Sync_App_Persistent_Stores:
  cmd.run:
    - name: >
        tethys syncstores all
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/init_apps_setup_complete" ];"

Flag_Init_Apps_Setup_Complete:
  cmd.run:
    - name: touch {{ TETHYS_PERSIST }}/init_apps_setup_complete
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/init_apps_setup_complete" ];"