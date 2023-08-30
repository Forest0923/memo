---
title: "サブモジュール"
draft: false
weight: 40
---
サブモジュールはレポジトリ内に Git 管理している別のリポジトリをサブディレクトリとして含めることができる機能です．ライブラリや自分が開発している他のプロジェクトの内容を使いたい場合にメインのプロジェクトとは別で管理しながらプロジェクト内に組み込むことができます．

## **サブモジュールの追加**

サブモジュールを追加するには次のコマンドを使用します．

```sh
git submodule add
```

サブモジュールとして追加したリポジトリの情報は .gitmodules に記述されます．

## **サブモジュールを含んだリポジトリのクローン**

サブモジュールを含んだリポジトリを通常のリポジトリと同様に clone すると，サブモジュールのディレクトリは空の状態になります．サブモジュールも一緒にクローンしたい場合は次のように `--recursive` オプションを使います．

```sh
git clone --recursive git@github.com:user/repo.git
```

すでに `git clone` していてサブモジュールの中身をクローンしたい場合は次のコマンドを実行します．

```sh
git submodule init
git submodule update
```

## **サブモジュールのアップデート**

サブモジュールのアップデートを適用する1つ目の方法はサブモジュールのディレクトリに移動して fetch，merge する方法です．

```sh
cd submod
git fetch
git merge
```

2つ目は次のように update を使用する方法です．

```sh
git submodule update --remote
```

Local のサブモジュールを更新した場合はサブモジュールのディレクトリに移動してコミット，プッシュします．

## **サブモジュールの削除**

サブモジュールを削除したい場合はまず deinit を実行します．

```sh
git submodule deinit submoddir
```

次に下記のコマンドで git からサブディレクトリを取り除きます．

```sh
git rm --cached submoddir
```

最後にコミットして変更を反映させます．

```sh
git commit
```
