{% set CONDA_HOME = salt['environ.get']('CONDA_HOME') %}
{% set TETHYS_PERSIST = salt['environ.get']('TETHYS_PERSIST') %}
{% set TETHYS_DB_HOST = salt['environ.get']('TETHYS_DB_HOST') %}
{% set TETHYS_DB_PORT = salt['environ.get']('TETHYS_DB_PORT') %}
{% set TETHYS_DB_SUPERUSER = salt['environ.get']('TETHYS_DB_SUPERUSER') %}
{% set TETHYS_DB_SUPERUSER_PASS = salt['environ.get']('TETHYS_DB_SUPERUSER_PASS') %}
{% set THREDDS_TDS_USERNAME = salt['environ.get']('THREDDS_TDS_USERNAME') %}
{% set THREDDS_TDS_PASSWORD = salt['environ.get']('THREDDS_TDS_PASSWORD') %}
{% set THREDDS_TDS_PROTOCOL = salt['environ.get']('THREDDS_TDS_PROTOCOL') %}
{% set THREDDS_TDS_HOST = salt['environ.get']('THREDDS_TDS_HOST') %}
{% set THREDDS_TDS_PORT = salt['environ.get']('THREDDS_TDS_PORT') %}
{% set THREDDS_SERVICE_NAME = 'tethys_thredds' %}
{% set POSTGIS_SERVICE_NAME = 'tethys_postgis' %}
{% set THREDDS_SERVICE_URL = THREDDS_TDS_USERNAME + ':' + THREDDS_TDS_PASSWORD + '@' + THREDDS_TDS_PROTOCOL +'://' + THREDDS_TDS_HOST + ':' + THREDDS_TDS_PORT %}
{% set POSTGIS_SERVICE_URL = TETHYS_DB_SUPERUSER + ':' + TETHYS_DB_SUPERUSER_PASS + '@' + TETHYS_DB_HOST + ':' + TETHYS_DB_PORT %}

Create_PostGIS_Database_Service:
  cmd.run:
    - name: "tethys services create persistent -n {{ POSTGIS_SERVICE_NAME }} -c {{ POSTGIS_SERVICE_URL }}"
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/tethys_services_complete" ];"

Create_THREDDS_Spatial_Dataset_Service:
  cmd.run:
    - name: "tethys services create spatial -t THREDDS -n {{ THREDDS_SERVICE_NAME }} -c {{ THREDDS_SERVICE_URL }}"
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/tethys_services_complete" ];"

Flag_Tethys_Services_Setup_Complete:
  cmd.run:
    - name: touch {{ TETHYS_PERSIST }}/tethys_services_complete
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/tethys_services_complete" ];"