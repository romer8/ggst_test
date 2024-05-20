FROM tethysplatform/tethys-core:dev

###############
# ENVIRONMENT #
###############
ENV THREDDS_TDS_USERNAME="admin" \
    THREDDS_TDS_PASSWORD="CHANGEME!" \
    THREDDS_TDS_PROTOCOL="http" \
    THREDDS_TDS_HOST="localhost" \
    THREDDS_TDS_PORT="8080" \
    CONDA_PYTHON_PATH="/opt/conda/envs/tethys/bin/python" \
    EARTHDATA_PASS="byuGRACE1" \
    EARTHDATA_USERNAME="byugrace" \
    GLOBAL_OUTPUT_DIRECTORY="/var/lib/tethys_persist/grace_dir" \
    GRACE_THREDDS_CATALOG="http://localhost:8080/thredds/catalog/ggst/catalog.xml" \
    GRACE_THREDDS_DIRECTORY="/var/lib/tethys_persist/thredds_data/ggst"


#############
# ADD FILES #
#############
COPY ggst ${TETHYS_HOME}/apps/ggst
COPY requirements/*.txt .

###########
# INSTALL #
###########
ARG MAMBA_DOCKERFILE_ACTIVATE=1

# GGST app
RUN micromamba install --yes -c conda-forge --file requirements.txt  && \
    pip install --no-cache-dir --quiet -r piprequirements.txt && \
    cd ${TETHYS_HOME}/apps/ggst && tethys install -N -w

##################
# ADD SALT FILES #
##################
COPY salt/ /srv/salt/


EXPOSE 80

CMD bash run.sh