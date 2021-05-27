#!/usr/bin/env bash

set -Ceu

IMAGE='sshd_server'

C_DIR=$(cd "$(dirname "$0")" || exit 1; pwd)

docker image build "${C_DIR}" --file "${C_DIR}/Dockerfile.14.04" --tag "${IMAGE}":14.04
docker image build "${C_DIR}" --file "${C_DIR}/Dockerfile.16.04" --tag "${IMAGE}":16.04
docker image build "${C_DIR}" --file "${C_DIR}/Dockerfile.18.04" --tag "${IMAGE}":18.04
