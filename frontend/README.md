# Installation of MicroScope web frontend

## Introduction

The frontend is based on Apache2, PHP7.1 and phpMyAdmin.

The installation is two-fold:
* first we need to setup some basics: Apache2, PHP7.1 and phpMyAdmin
* after we setup MicroScope.

For the first part, we adapted the procedure described [here](https://www.howtoforge.com/tutorial/centos-lamp-server-apache-mysql-php/) (based on remi repository).
The epel repository is already installed on parent.
We also need to install Tcl/TK for password generation.

MicroScope installation is not done yet.

## Technical notes

### Installation of phpMyAdmin (02_post-install.sh)

We must set the IP adress of the MySQL server in the configuration file.
The trick is to do it in PHP with an HERE document:
* the basic syntax is multi-line HERE doc with redirection
* `require_once` is used to load the configuration; we can then modify it in PHP
* `var_export` creates a string representing the variable
* we output a PHP file (with standard open tags) redirected in the new file

Care must be taken to not mix PHP and bash strings and variables.

## TODO

Important:
* MicroScope installation

Security:
* Use parameter for mysql password
* Use a non-root mysql user

Things to consider:
* Better generation of certificates
* Installation with SELinux

