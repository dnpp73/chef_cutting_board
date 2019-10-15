#!/usr/bin/env bash

set -Ceu

C_DIR=$(cd "$(dirname "$0")" || exit 1; pwd)
exec "${C_DIR}/stop.sh"
