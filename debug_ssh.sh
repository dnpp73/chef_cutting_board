#!/usr/bin/env bash

set -eu

CONTAINER_NAME='chef_cutting_board'

if ! docker container inspect "${CONTAINER_NAME}" > /dev/null 2>&1 ; then
    echo "[INFO] ${CONTAINER_NAME} container not running."
    exit 1
fi

# -P でホストにランダムで割り当てたポート番号はこれで取れる。
PORT=$(docker container port "${CONTAINER_NAME}" 22 | cut -d ':' -f2)

ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p "${PORT}" ubuntu@localhost
