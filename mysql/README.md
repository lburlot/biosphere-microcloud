# Installation of MicroScope MySQL Backend

## Introduction

This component is the MySQL server for microScope.

The installation procedure is based on official docker images for MySQL.
See [here](https://dev.mysql.com/doc/refman/5.7/en/linux-installation-docker.html) for some documentation.

## Technical notes

## TODO

Important:
* Installation of UDF; AFAIK the development headers and gcc are not installed
* We need a lot of storage

Security:
* Use a random password for MySQL
* Use a non-root user for MySQL

Misc:
* Start docker container in `04_deployment.sh`

