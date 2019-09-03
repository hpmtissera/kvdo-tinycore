#!/usr/bin/env bash

echo -e "This script will build RedHat KVDO for Tiny Core:10.0-x86_64 (Kernel: 4.19.10-tinycore64)\n"

KVDO_VERSION=$1

if [ "${KVDO_VERSION}" = "" ]; then
   echo -n "Enter the KVDO version number to build [default: 6.2.1.134]: "
   read KVDO_VERSION
fi

if [ "${KVDO_VERSION}" = "" ]; then
   KVDO_VERSION="6.2.1.134"
fi

docker build -t kvdo-build .
docker run --volume "$(pwd):/opt/build" --cidfile=containerid  -u root kvdo-build sh -c "/opt/build/build-kvdo.sh ${KVDO_VERSION}"

CONTAINER_ID=$(cat containerid)
docker cp ${CONTAINER_ID}:/kvdo-4.19.10-tinycore64.tcz ./
docker rm -f ${CONTAINER_ID}
rm containerid
