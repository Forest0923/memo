---
title: "Usecases of Git"
draft: false
weight: 30
---

# Usecases of Git

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
