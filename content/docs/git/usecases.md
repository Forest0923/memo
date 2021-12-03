---
title: "Usecases of Git"
description: ""
lead: ""
date: 2021-11-29T12:48:32+09:00
lastmod: 2021-11-29T12:48:32+09:00
draft: false
images: []
menu: 
  docs:
    parent: "git"
weight: 30
toc: true
---

## Cancel `git add`

```sh
git reset
# or
git reset <file>
```

## Cancel `git commit`

```sh
# Reset contents 
git reset <tag> --hard

# Reset commit and keep changes
git reset <tag> --soft
```

## View previous commit

```sh
git checkout <tag>
```
