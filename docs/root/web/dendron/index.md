---
title: "Dendron"
draft: false
weight: 999
---

## Requirements

- VSCode or VSCodium
  - dendron extension を使用して書いていくのでどちらかが必要
  - git 管理はしたいけどテキストファイルをバックアップ的に保存しておくだけでいい、かつ、ローカルでの確認もエディタ上のプレビューだけでいい場合はここから下は不要
- yarn, pnpm or npm
  - VSCode 内のプレビューのみでいいのであればなくても問題ない
  - html にエクスポートしてブラウザで確認したり、GitHub Pages でホストする場合に手元で確認したりする場合は必要
  - yarn で最初からプロジェクトを作成する場合は下記を実行する

```sh
yarn init
yarn add @dendronhq/dendron-cli@latest
yarn dendron publish init
```

## How to build?

### dendron cli

```sh
yarn dendron publish dev
```

### html をエクスポート

`docs` に publish する：

```sh
yarn dendron publish export --target github
```

publish したページをローカルで確認する：

```sh
cd docs
python3 -m http.server --bind 127.0.0.1
```
