#!/usr/bin/env bash

set -eu

CONTAINER_NAME='chef_cutting_board'

if ! docker container inspect "${CONTAINER_NAME}" > /dev/null 2>&1 ; then
    echo "[INFO] ${CONTAINER_NAME} container not running."
    exit 1
fi

# -P でホストにランダムで割り当てたポート番号はこれで取れる。
PORT=$(docker container port "${CONTAINER_NAME}" 22 | cut -d ':' -f2)

PASSWORD='ubuntu'

# 毎回 ssh でパスワードを打つのがダルいので expect コマンドでパスワードを自動送信しちゃう
expect -c "
    # タイムアウト値を指定する
    set timeout 30

    # spawnでsshコマンドを実行する
    spawn ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p ${PORT} ubuntu@localhost

    # パスワード入力時に表示される password: の出力を待つ
    expect password:

    # パスワードを送信する
    send \"${PASSWORD}\n\"

    # spawnの出力先を画面にする
    interact
    "
