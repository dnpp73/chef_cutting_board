#!/usr/bin/env bash

set -Ceu

IMAGE='sshd_server'

C_DIR=$(cd "$(dirname "$0")" || exit 1; pwd)

function build() {
    # buildx で multi platform な docker image を生成するには事前に docker buildx create --use などしておかないといけないし結構めんどくさい
    # docker buildx build --platform linux/amd64,linux/arm64 "${C_DIR}" --file "${C_DIR}/Dockerfile.${1}" --tag "${IMAGE}":"${1}"
    docker image build "${C_DIR}" --file "${C_DIR}/Dockerfile.${1}" --tag "${IMAGE}":"${1}"
}

build 14.04
build 16.04
build 18.04
