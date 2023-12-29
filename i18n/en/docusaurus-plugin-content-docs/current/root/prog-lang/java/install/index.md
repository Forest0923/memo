---
title: "Setting up Java Environment"
draft: false
weight: 10
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

## System

- JDK v11 Temurin
- IntelliJ Community Edition

## Installation

<Tabs groupId="OS" queryString>
  <TabItem value="arch" label="Arch">

    ```sh
paru -S jdk11-temurin intellij-idea-community-edition
    ```

  </TabItem>
</Tabs>

## Java Version Management

How to switch between multiple installed versions of Java.

To check the available versions and the default environment, run:

```sh
archlinux-java status
```

Example output:

```text
Copy code
Available Java environments:
  java-11-temurin
  java-17-openjdk
  java-18-openjdk (default)
  java-8-openjdk/jre
```

To set the default to java-11-temurin, use `set`:

```sh
sudo archlinux-java set java-11-temurin
```

Verify the default with java -version:

```text
$ java -version
openjdk version "11.0.16.1" 2022-08-12
OpenJDK Runtime Environment Temurin-11.0.16.1+1 (build 11.0.16.1+1)
OpenJDK 64-Bit Server VM Temurin-11.0.16.1+1 (build 11.0.16.1+1, mixed mode)
```
