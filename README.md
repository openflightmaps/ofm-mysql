# OFM Mysql schema repository

This repository contains the mysql schema for the ofm database.
The OFM database schema uses its own kind of no-sql style storage on top of mysql.

## Services and service instances
See [services](docs/services.md)

## Stored procedures
At the moment stored procedures are used to update the database state and ensure consistence.
This is planned to be replaced with a REST API.

## Compare database with repository
To compare the current state of the DB with the schema checked into this repository use the following command.
It will then output the commands that need to be run on the database to make its schema match:

```
make compare-ofm

BEGIN;

SET FOREIGN_KEY_CHECKS = 0;

ALTER TABLE `S3A2` ADD INDEX `index5` (`ammnt_FirId`);

SET FOREIGN_KEY_CHECKS = 1;

```
