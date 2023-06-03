---
title: "Cheatsheet"
draft: false
weight: 50
---

## イメージ

### Docker hub の検索

```sh
docker search <query>
```

### イメージダウンロード

```sh
docker pull IMAGE
```

### イメージ作成

```sh
docker commit CONTAINER new_image:tag
docker commit CONTAINER new_image
```

### イメージ削除

```sh
docker image rm IMAGE
```

or

```sh
docker rmi IMAGE
```

### イメージのタグ付け

```sh
docker tag IMAGE new_image:tag
docker tag IMAGE new_image
```

### イメージの情報表示

```sh
docker image inspect
```

### イメージのビルド

```sh
docker image build -t IMAGE_NAME .
```

or

```sh
docker image -t IMAGE_NAME .
```

## コンテナ

### コンテナ実行

```sh
docker container run IMAGE
```

or

```sh
docker run IMAGE
```

- シェルを実行

```sh
docker container run -it IMAGE /bin/bash
```

- ENTRYPOINT を上書きしてシェルを実行（本来の予定通りに動かなくなるので注意）

```sh
docker container run --entrypoint /bin/bash -it IMAGE
```

### ポートフォワーディング

```sh
docker run -p <host-port>:<container-port> <image>
```

### ファイルシステムマウント

```sh
docker run -v /path/to/local:/path/to/container IMAGE
```

or

```sh
docker run --mount type=bind,source=/path/to/local,target=/path/to/container IMAGE
```

### 実行中のコンテナ

```sh
docker container ls -a
```

or

```sh
docker ps -a
```

### コンテナの stdout, stderr の表示

```sh
docker container logs CONTAINER
```

or

```sh
docker logs CONTAINER
```

### コンテナの情報表示

```sh
docker container inspect CONTAINER
```

### コンテナの名前変更

```sh
docker container rename OLD_NAME NEW_NAME
```

### 実行中のコンテナのシェルに入る

```sh
docker container exec -it CONTAINER /bin/bash
```

or

```sh
docker exec -it CONTAINER /bin/bash
```

### コンテナの停止

- SIGTERM

```sh
docker container stop
```

- SIGKILL

```sh
docker container kill
```

or

```sh
docker kill
```

### OS 起動時にコンテナを自動起動

- 必ず起動したいとき

```sh
docker container run -d --restart=always CONTAINER
```

- `docker container stop` などで停止したコンテナは実行したくないとき

```sh
docker container run -d --restart=unless-stopped CONTAINER
```

- すでに実行しているコンテナに設定を追加したいとき

```sh
docker update --restart=[always,unless-stopped] CONTAINER
```
