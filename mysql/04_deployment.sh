#!/bin/sh -xe

######################
# Start mysql docker #
######################

# Run mysql container and expose port
# We generate the password with the same command than the docker container
CONTAINER_NAME=mysql01
export MYSQL_ROOT_PASSWORD="$(pwgen -1 32)"
docker run --detach --name=${CONTAINER_NAME} --env="MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}" -p 3306:3306 mysql:5.7
# MySQL must be start before installing the UDF so we wait a bit
sleep 10

# Export password
ss-set mysqlRootPassword ${MYSQL_ROOT_PASSWORD}


##################
# MicroScope UDF #
##################

# Version to use
MIC_UDF_VERSION=0.4.7
MIC_UDF_PACKAGES="build-essential procps libmysqlclient-dev"

# Install some packages inside the container
docker exec ${CONTAINER_NAME} sh -c "apt-get update && apt-get -y install ${MIC_UDF_PACKAGES}"

# Download, copy the files and uncompress the sources
curl -o lib_mysqludf_sequtils-${MIC_UDF_VERSION}.tar.gz https://www.genoscope.cns.fr/agc/ftp/lib_mysqludf_sequtils-${MIC_UDF_VERSION}.tar.gz
docker cp lib_mysqludf_sequtils-${MIC_UDF_VERSION}.tar.gz ${CONTAINER_NAME}:/
docker exec ${CONTAINER_NAME} tar -xzf lib_mysqludf_sequtils-${MIC_UDF_VERSION}.tar.gz

# Compilation & installation (we need the password)
docker exec ${CONTAINER_NAME} sh -c "\
cd lib_mysqludf_sequtils-${MIC_UDF_VERSION}/ && \
./configure && MYSQL_USER=root MYSQL_PASSWORD=${MYSQL_ROOT_PASSWORD} make install
"
# Remove file and folder
docker exec ${CONTAINER_NAME} rm -rf lib_mysqludf_sequtils-${MIC_UDF_VERSION}.tar.gz lib_mysqludf_sequtils-${MIC_UDF_VERSION}

# Remove packages
docker exec ${CONTAINER_NAME} sh -c "apt-get update && apt-get -y remove ${MIC_UDF_PACKAGES} && apt-get -y autoremove"

####################
# Backend is ready #
####################

ss-set mysqlBackendReady "true"
ss-display "MySQL backend ready"

