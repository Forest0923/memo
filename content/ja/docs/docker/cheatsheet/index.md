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
docker pull <image>
```

### イメージ作成

```sh
docker commit <container> new_image:tag
docker commit <container> new_image
```

### イメージ削除

```sh
docker image rm <image>
```

or

```sh
docker rmi <image>
```

### イメージのタグ付け

```sh
docker tag <image> new_image:tag
docker tag <image> new_image
```

### イメージの情報表示

```sh
docker image inspect
```

### イメージのビルド

```sh
docker image build -t <image_name> .
```

or

```sh
docker image -t <image_name> .
```

## コンテナ

### コンテナ実行

```sh
docker container run <image>
```

or

```sh
docker run <image>
```

- シェルを実行

```sh
docker container run -it <image> /bin/bash
```

- ENTRYPOINT を上書きしてシェルを実行（本来の予定通りに動かなくなるので注意）

```sh
docker container run --entrypoint /bin/bash -it <image>
```

### ポートフォワーディング

```sh
docker run -p <host-port>:<container-port> <image>
```

### ファイルシステムマウント

```sh
docker run -v /path/to/local:/path/to/container <image>
```

or

```sh
docker run --mount type=bind,source=/path/to/local,target=/path/to/container <image>
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
docker container logs <container>
```

or

```sh
docker logs <container>
```

### コンテナの情報表示

```sh
docker container inspect <container>
```

### コンテナの名前変更

```sh
docker container rename <old_name> <new_name>
```

### 実行中のコンテナのシェルに入る

```sh
docker container exec -it <container> /bin/bash
```

or

```sh
docker exec -it <container> /bin/bash
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
docker container run -d --restart=always <container>
```

- `docker container stop` などで停止したコンテナは実行したくないとき

```sh
docker container run -d --restart=unless-stopped <container>
```

- すでに実行しているコンテナに設定を追加したいとき

```sh
docker update --restart=[always,unless-stopped] <container>
```
