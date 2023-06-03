---
title: "Dockerfile"
draft: false
weight: 100
---

## Template

```Dockerfile
# ベースとなるイメージの指定。基本的には一番最初に呼ばれる
FROM ubuntu:latest

# メタデータを追加する。{key, value}のセットで指定し、keyは任意で追加可能
# key は任意だが、`org.opencontainers.image.authors` などの標準化されたキーもある
LABEL org.opencontainers.image.authors="name <foo@example.com>"
LABEL org.opencontainers.image.url="example.com"
LABEL org.opencontainers.image.version="1.0"
LABEL description="My test image" maintainer="foo@example.com"

# 環境変数の設定
ENV test_var="hello world" test_var1=unused

# ビルド時に使われる環境変数。
# ARG は FROM の前に使ってベースイメージのバージョンを指定するときにも使える
ARG version=3.0

# イメージをビルドする際に実行するコマンド。
# つまりここでは`tmux` をインストール済みのイメージが作れる
RUN apt update && apt upgrade -y && apt install -y tmux=$version

# RUN, COPY, ADD, ENTRYPOINT, CMD が実行されるワーキングディレクトリ
WORKDIR /workspace

# コンテナがリッスンするポートの情報を明示的に記述する
# 実際に開放されるとかではない
EXPOSE 8080

# ホストからイメージのファイルシステムへファイルをコピーする
COPY hello.py .

# ホストからイメージのファイルシステムへファイルをコピーする
# COPY と違って URL を指定してダウンロードしたファイルを追加することが可能
# また、tar ファイルは自動的に展開される
# ネット接続や自動展開の影響が予測できないので、COPY で実現できることは COPY で行う
ADD test.tar.gz .

# コンテナが起動されたときに実行されるコマンド
# `docker run` に明示的に引数がある場合はそちらに上書きされる
# Dockerfile 内で一度しか使えず、複数ある場合はあとの定義が有効になる
CMD ["echo", "cmd called"]

# コンテナが起動されたときに実行されるコマンド
# `docker run` に明示的に引数がある場合、コマンドの引数となる
# `docker run` に引数がなく、CMD が使われている場合、
#               CMD の内容が ENTRYPOINT のコマンドの引数になる
# ex) 引数なし => `python hello.py echo cmd called` が実行される
ENTRYPOINT ["python", "hello.py"]
```

volume

## Multi stage build

マルチステージビルドを使うと一つの Dockerfile 内で複数のイメージから一つの実行用イメージを作成することができます。
ビルド時の副作用を実行用のコンテナに含めたくない場合などに使われるようです。

Dockerfile 内で FROM が新たに実行されるとそこから新たなビルドステージが始まります。

```Dockerfile
# First build stage
# このビルドステージでのみ有効な環境変数
ARG version=latest
# AS で名前を指定
FROM ubuntu:$version AS ubuntu
RUN echo "Building on Ubuntu version: $version"

# Second build stage
FROM debian
# --from で他のイメージからファイルをコピーできる
COPY --from=ubuntu /etc/os-release /ubuntu_version
```
