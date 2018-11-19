#!/usr/bin/env sh
set -e

export curlimage=appropriate/curl
export jqimage=stedolan/jq

echo "---> MySQL"
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

echo "---> Waiting for database connection  ..."
docker run -it \
--link rancher-mysql:mysql \
--rm ${curlimage} \
sh -c 'until nc -z mysql 3306 ; do  sleep 1 ; done'

echo "---> Rancher"
docker run \
--name=rancher-server \
--restart=unless-stopped \
--link rancher-mysql:rancher-mysql \
-p 8080:8080 \
-d rancher/server:v1.6.23 \
--advertise-address awslocal \
--db-host rancher-mysql \
--db-port 3306 \
--db-user rancher \
--db-pass rancher-pwd \
--db-name cattle

echo "--> Waiting for rancher service ..."
RANCHER_API_HOST=$(\
docker run -it \
--link rancher-server:rancher \
--rm ${curlimage} \
sh -c 'until nc -z rancher 8080 ; do  sleep 1 ; done && curl http://rancher:8080/v2-beta/settings/api.host' | \
docker run --rm -i ${jqimage} '.' \
)

echo "${RANCHER_API_HOST}"

rancher_private_ip="$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)"
RANCHER_HOST="$(\
echo "${RANCHER_API_HOST}" | \
docker run --rm -i ${jqimage} '. | {value: .value}' | \
sed "s/null/\"http:\/\/${rancher_private_ip}:8080\"/g" \
)"
echo ${RANCHER_HOST}
echo "--> Updating  host registration URL ..."
curl -X PUT \
-H 'Accept: application/json' \
-H 'Content-Type: application/json' \
-d "${RANCHER_HOST}" \
'http://localhost:8080/v2-beta/settings/api.host'

echo "--> clean up"
docker rmi ${curlimage} ${jqimage}

echo "--> Done"
