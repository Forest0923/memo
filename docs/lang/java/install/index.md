---
title: "Java 環境構築"
draft: false
weight: 10
---

## System

- JDK v11 temurin
- IntelliJ Community Edition

## Install

{{< tabpane >}}
{{< tab header="Arch" lang="sh" >}}

paru -S jdk11-temurin intellij-idea-community-edition

{{< /tab >}}
{{< /tabpane >}}

## Java のバージョン管理

複数のバージョンの Java がインストールされている場合のバージョンの切り替え方法．

現在利用可能なバージョンとデフォルトで使用される環境は下記のように確認できる．

```sh
archlinux-java status
```

実行結果の例↓

```text
Available Java environments:
  java-11-temurin
  java-17-openjdk
  java-18-openjdk (default)
  java-8-openjdk/jre
```

デフォルトを `java-11-temurin` にするには `set` を用いる．

```sh
sudo archlinux-java set java-11-temurin
```

```text
$ java -version
openjdk version "11.0.16.1" 2022-08-12
OpenJDK Runtime Environment Temurin-11.0.16.1+1 (build 11.0.16.1+1)
OpenJDK 64-Bit Server VM Temurin-11.0.16.1+1 (build 11.0.16.1+1, mixed mode)
```
