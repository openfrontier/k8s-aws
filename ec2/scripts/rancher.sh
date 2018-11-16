#!/usr/bin/env sh
set -e
docker volume create rancher-mysql-data

docker run \
--name rancher-mysql \
--restart=unless-stopped \
-e MYSQL_RANDOM_ROOT_PASSWORD=yes \
-e MYSQL_USER=rancher \
-e MYSQL_PASSWORD=rancher-pwd \
-e MYSQL_DATABASE=cattle \
-v rancher-mysql-data:/var/lib/mysql \
-d mysql:5.7 \
--character-set-server=utf8 \
--collation-server=utf8_general_ci

sleep 20

docker run \
--name=rancher-server \
--restart=unless-stopped \
--link rancher-mysql:rancher-mysql \
-p 8080:8080 \
-d rancher/server:v1.6.23 \
--db-host rancher-mysql \
--db-port 3306 \
--db-user rancher \
--db-pass rancher-pwd \
--db-name cattle
