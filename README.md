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


## もっと便利に使いたいんだけど…

しらんけど `~/.ssh/authorized_keys` とかを read only(ro) で `-v` 使ってマウントとかすればいいんじゃないかな。


## Ubuntu 16.04 だけなの？

しらんけど `FROM` 書き換えればたぶん他の Ubuntu でも動くんじゃない？
