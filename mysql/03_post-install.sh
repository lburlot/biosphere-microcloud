#!/bin/sh -xe

# Add docker group and add ourselves and centos in
groupadd docker
usermod -aG docker root
usermod -aG docker centos

# Disable selinux for docker
CONFIG_FILE=/etc/sysconfig/docker
cp -p ${CONFIG_FILE} ${CONFIG_FILE}.orig
cat > ${CONFIG_FILE} << "EOF"
OPTIONS='--log-driver=journald --signature-verification=false'
if [ -z "${DOCKER_CERT_PATH}" ]; then
    DOCKER_CERT_PATH=/etc/docker
fi
EOF
chmod 0644 ${CONFIG_FILE}

# Start Docker :
systemctl start docker

# Pull mysql image
docker pull mysql:5.7

# Run mysql container and expose port (we need to start it before installing the UDF)
CONTAINER_NAME=mysql01
docker run --detach --name=${CONTAINER_NAME} --env="MYSQL_ROOT_PASSWORD=mypassword" -p 80:80 -p 3306:3306 mysql:5.7

##################
# MicroScope UDF #
##################

# Install some packages inside the container
PACKAGES_FOR_UDF="build-essential autoconf automake libtool procps libmysqlclient-dev"
docker exec ${CONTAINER_NAME} sh -c "apt-get update && apt-get -y install ${PACKAGES_FOR_UDF}"

# Download, copy the files and uncompress the sources
curl -o lib_mysqludf_Sequtils-0.4.7.tar.gz https://www.genoscope.cns.fr/agc/ftp/lib_mysqludf_Sequtils-0.4.7.tar.gz
docker cp lib_mysqludf_Sequtils-0.4.7.tar.gz ${CONTAINER_NAME}:/
docker exec ${CONTAINER_NAME} tar -xzf lib_mysqludf_Sequtils-0.4.7.tar.gz

# Compilation & installation (we need the password)
docker exec ${CONTAINER_NAME} sh -c "\
cd lib_mysqludf_Sequtils-0.4.7/src && \
autoreconf -fi &&\
./configure --with-mysqlbin='mysql -u root --password=mypassword' && make && make install
"
# Remove file and folder
docker exec ${CONTAINER_NAME} rm -rf lib_mysqludf_Sequtils-0.4.7.tar.gz lib_mysqludf_Sequtils-0.4.7

# Remove packages
docker exec ${CONTAINER_NAME} sh -c "apt-get update && apt-get -y remove ${PACKAGES_FOR_UDF} && apt-get -y autoremove"

