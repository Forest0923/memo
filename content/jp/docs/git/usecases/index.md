---
title: "Git の使い方（使用例）"
draft: false
weight: 30
---
## git add を取り消す

```sh
git reset
# or
git reset <file>
```

## git commit を取り消す

```sh
# Reset contents 
git reset <tag> --hard

# Reset commit and keep changes
git reset <tag> --soft
```

## 以前のコミット時の状態に戻す

```sh
git checkout <tag>
```
