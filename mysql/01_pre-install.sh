#!/bin/sh -xe

# To ease deployment, disable selinux.
# This should be changed in the future.
setenforce 0

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

