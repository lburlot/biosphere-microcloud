# Installation of MicroScope MySQL Backend

## Introduction

This component is the MySQL server for MicroScope.

The installation of the MySQL server is based is based on official docker images for MySQL.
See [1] and [2] for some documentation.

## Technical notes

We generate the root password for MySQL with the same command use in the Docker.
This is easier to reuse it in the code.

The MySQL client (`mysql`) is not installed on the server but is installed inside docker.

To install the UDF, we need to wait that the server is started.
We implement a solution close to the ones described in [2] (section "No connections until MySQL init completes").
Note that [3] suggests using `mysqladmin` instead of `mysql`.

## TODO

Important:
* We need a lot of storage

Security:
* Create a non-root user for MySQL (agc)

TODO:
* If we use external storage for MySQL, we can't choose the root password [2] (see section "Usage against an existing database")

# References

* [1] [MySQL documentation - Section 2.5.7 Deploying MySQL on Linux with Docker](https://dev.mysql.com/doc/refman/5.7/en/linux-installation-docker.html)
* [2] [MySQL Official Docker Image](https://hub.docker.com/_/mysql/)
* [3] [MySQL documentation - Section 2.10.3 Testing the Server](https://dev.mysql.com/doc/refman/5.7/en/testing-server.html)

