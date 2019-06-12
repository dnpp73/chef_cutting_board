#!/usr/bin/env bash

set -eu

IMAGE='sshd_server'

C_DIR=$(cd $(dirname "$0"); pwd)

docker image build "${C_DIR}" -t "${IMAGE}":latest
