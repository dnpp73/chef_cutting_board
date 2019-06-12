#!/usr/bin/env bash

set -eu

CONTAINER_NAME='chef_cutting_board'

if ! docker container inspect "${CONTAINER_NAME}" > /dev/null 2>&1 ; then
    echo "[INFO] ${CONTAINER_NAME} container not running."
    exit
fi

docker container stop "${CONTAINER_NAME}"
docker container rm "${CONTAINER_NAME}"

echo "[INFO] ${CONTAINER_NAME} container stopped."
