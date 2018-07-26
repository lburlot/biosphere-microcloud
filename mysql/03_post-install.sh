#!/bin/sh -xe

# Start Docker :
systemctl start docker

# Pull mysql image
docker pull mysql:5.7

# Run mysql container and expose port
docker run --detach --name=mysql01 --env="MYSQL_ROOT_PASSWORD=mypassword" -p 80:80 -p 3306:3306 mysql:5.7

