---
title: "Docker Compose"
draft: false
weight: 110
---

## Template

```yml
# Docker compose のバージョン
version: '3'
services:
  # 1つ目のコンテナ
  db:
    image: mysql:latest
    volumes:
      - db_data:/var/lib/mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: rootpasswd
      MYSQL_DATABASE: sampledb
      MYSQL_USER: application
      MYSQL_PASSWORD: applicationpw

  # 2つ目のコンテナ
  web:
    image: nginx:latest
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
    ports:
      - "8080:80"
    # 依存関係を示す
    # db コンテナに依存するので db を起動したあとに web が起動される
    depends_on:
      - db

# volume の作成
volumes:
    # volume の設定を記述する。{} のときはデフォルト設定
    # local に保存したり aws に保存したりできるらしい
    # マウント先のファイルシステムを指定したり、ラベルをつけたりもできる
    db_data:
        driver: local
    driver_opts:
      o: bind
      device: /path/to/data
```
