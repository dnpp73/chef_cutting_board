#!/usr/bin/env bash

set -eu

IMAGE='sshd_server'
CONTAINER_NAME='chef_cutting_board'

if docker container inspect "${CONTAINER_NAME}" > /dev/null 2>&1 ; then
    echo "[INFO] ${CONTAINER_NAME} container already running."
    exit
fi

if ! docker image inspect "${IMAGE}" > /dev/null 2>&1 ; then
    echo "[INFO] ${IMAGE} image not found. exec \`./build.sh\`"
    C_DIR=$(cd $(dirname "$0"); pwd)
    ${C_DIR}/build.sh
fi

# -P で EXPOSE 指定したコンテナの露出ポートをホスト側に公開出来る。割り当てはランダム。
# -d でデタッチモード指定した場合、 --rm の指定は併用できないよ。
docker container run -d -P --name "${CONTAINER_NAME}" "${IMAGE}":latest

echo "[INFO] ${CONTAINER_NAME} container now running."
