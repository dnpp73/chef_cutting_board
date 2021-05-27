#!/usr/bin/env bash

set -Ceu

IMAGE='sshd_server:18.04'
CONTAINER_NAME='chef_cutting_board'

function print_ssh_command() {
    PORT=$(docker container port "${CONTAINER_NAME}" 22 | cut -d ':' -f2)
    echo "[INFO] To SSH into container:"
    echo '```'
    echo "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p ${PORT} ubuntu@localhost"
    echo '```'
}

if docker container inspect "${CONTAINER_NAME}" > /dev/null 2>&1 ; then
    echo "[INFO] '${CONTAINER_NAME}' container already running."
    print_ssh_command
    exit
fi

# docker image build fallback
if ! docker image inspect "${IMAGE}" > /dev/null 2>&1 ; then
    echo "[INFO] '${IMAGE}' docker image not found. running \`./build.sh\` ..."
    C_DIR=$(cd "$(dirname "$0")" || exit 1; pwd)
    "${C_DIR}/build.sh" > /dev/null
    echo "[INFO] \`docker image build\` finished."
fi

# -P で EXPOSE 指定したコンテナの露出ポートをホスト側に公開出来る。割り当てはランダム。
# -d でデタッチモード指定した場合、 --rm の指定は併用できないよ。
# コンテナ内で systemd を動かす時に privileged が本当に必要なのか https://qiita.com/shusugmt/items/92ece6874ba5aeff2b41 あたりに情報があった。
# --cap-add sys_admin --security-opt seccomp:unconfined で行けるらしいが環境依存なのか Docker for Mac 2.0.4.1 の Engine: 19.03.0-beta3 ではダメでした。
AUTHORIZED_KEYS_PATH="${HOME}/.ssh/authorized_keys"
if [ -s "${AUTHORIZED_KEYS_PATH}" ]; then
    if [ -L "${AUTHORIZED_KEYS_PATH}" ]; then
        AUTHORIZED_KEYS_PATH=$(readlink "${AUTHORIZED_KEYS_PATH}")
    fi
    docker container run -d -P --name "${CONTAINER_NAME}" \
    --privileged \
    -v "$AUTHORIZED_KEYS_PATH":/root/.ssh/authorized_keys:ro \
    -v "$AUTHORIZED_KEYS_PATH":/home/ubuntu/.ssh/authorized_keys:ro \
    "${IMAGE}" > /dev/null
else
    docker container run -d -P --name "${CONTAINER_NAME}" \
    --privileged \
    "${IMAGE}" > /dev/null
fi

if ! docker container inspect chef_cutting_board > /dev/null 2>&1 ; then
    echo "[ERROR] failed to run '${CONTAINER_NAME}' container." 1>&2
    exit 1
fi

docker container exec "${CONTAINER_NAME}" service ssh start

echo "[INFO] '${CONTAINER_NAME}' container now running."
print_ssh_command
