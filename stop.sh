#!/usr/bin/env bash

set -eu

CONTAINER_NAME='chef_cutting_board'

if ! docker container inspect "${CONTAINER_NAME}" > /dev/null 2>&1 ; then
    echo "[INFO] '${CONTAINER_NAME}' container not running."
    exit
fi

docker container stop "${CONTAINER_NAME}" > /dev/null
docker container rm "${CONTAINER_NAME}" > /dev/null

echo "[INFO] '${CONTAINER_NAME}' container stopped."
