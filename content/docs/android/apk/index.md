---
title: "Reverse Engineering (APK)"
draft: false
weight: 20
---

# Reverse Engineering (APK)

<!---
/data/app/*
/storage/emulated/0/Download
--->

## System

- Linux v5.8

## Tools

- apktool
  - `yay -S android-apktool`
- dex2jar
  - `yay -S dex2jar`
- jd-cmd
  - `yay -S jd-cmd`
  - <https://github.com/kwart/jd-cli>

## Commands

- Decompress:

```sh
apktool d -s -o decompiled base.apk
```

- Convert `.dex` files to `.jar`:

```sh
cd decompiled
dex2jar classes.dex
dex2jar classes2.dex
...
```

- Decompile:

```sh
jd-cmd classes-dex2jar.jar -od src
jd-cmd classes2-dex2jar.jar -od src
...
```

or

```sh
java -jar jd-cli.jar classes-dex2jar.jar -od src
java -jar jd-cli.jar classes2-dex2jar.jar -od src
...
```
