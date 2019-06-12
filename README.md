# Chef Cutting board


Chef のレシピの挙動確認するのに毎回なんらかのインスタンスを立ち上げるの時間と金の無駄じゃね？ってなってカッとなって作ったやつ。


## どうやって使うの。

Just type `./run.sh`

then type `./debug_ssh.sh`


## お片付けは？

Just type `./stop.sh`


## ssh パスワードは？

使い捨て前提なので Dockerfile にベタで書いてある。

- root -> `password`
- ubuntu -> `ubuntu`


## `authorized_keys` をマウントしてるよ

お手元の Docker 実行環境の `"${HOME}/.ssh/authorized_keys"` があったらコンテナ内の root と ubuntu 部分に読み込み専用でマウントしてるから公開鍵認証で入れるよ。

地味にシンボリックリンクかどうかのチェックまでしてて、そうだったら `readlink` までしてるからちゃんと使えると思うよ。


## Ubuntu 16.04 だけなの？

しらんけど `FROM` 書き換えればたぶん他の Ubuntu でも動くんじゃない？
