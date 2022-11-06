+++
title = "[Solved] paru, AUR helper didn't work due to openssl version error (November 7, 2022)"
description = ""
date = 2022-11-07T08:21:51+09:00
tags = [

]
categories = [

]
draft = false
+++

## Issue

I couldn't upgrade application via paru this morning. I got the error message as follows.

```text
$ paru -Syu
paru: error while loading shared libraries: libssl.so.1.1: cannot open shared object file: No such file or directory
```

The problem was that the version of openssl had been updated from 1.1 to 3 and the version of the library that paru was using was gone.

## Solution

I installed openssl v1.1 via pacman. Fortunately pacman was available this time.

```sh
sudo pacman -S openssl-1.1
```
