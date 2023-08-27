---
title: "LFS (Large File Storage)"
draft: false
weight: 50
---
GitHub にアップロードできる最大のファイルサイズはデフォルトでは 100 MB となっています．
その制限を超えるサイズのファイルを Git で管理したい場合には Git LFS を用いる必要があり，ここではその使い方を説明します．

## **インストール**

下記コマンドでインストールします．

{{< tabpane >}}
{{< tab header="Arch" lang="sh" >}}

sudo pacman -S git-lfs

{{< /tab >}}
{{< tab header="Ubuntu" lang="sh" >}}

sudo apt install git-lfs

{{< /tab >}}
{{< /tabpane >}}

インストールできたことを下記のコマンドで確認します．

```sh
git lfs install
```

## **使い方**

hello.txt という 100MB より小さいファイルと large.file という 100MB を超えるファイルがある場合を考えます．

```text
.
├── hello.txt
└── large.file
```

この状態で通常通りに push しようとすると次のようにエラーが出ます．

```sh
git init
git remote add origin git@github.com:user/git-lfs-test.git
git add .
git commit -m "Initial commit"
git push origin master
```

```text
Enumerating objects: 4, done.
Counting objects: 100% (4/4), done.
Delta compression using up to 16 threads
Compressing objects: 100% (3/3), done.
Writing objects: 100% (4/4), 8.31 MiB | 1.76 MiB/s, done.
Total 4 (delta 0), reused 0 (delta 0), pack-reused 0
remote: error: GH001: local files detected. You may want to try Git Large File Storage - https://git-lfs.github.com.
remote: error: Trace: f2804525d75e71f1d42747fe638744b05a78ef347da1de187e2437a43d25eccb
remote: error: See http://git.io/iEPt8g for more information.
remote: error: File large.file is 119.52 MB; this exceeds GitHub's file size limit of 100.00 MB
To github.com:user/git-lfs-test.git
 ! [remote rejected] master -> master (pre-receive hook declined)
error: failed to push some refs to 'github.com:user/git-lfs-test.git'
```

LFS を使うためにまずはサイズの大きいファイルを commit から削除します．

```sh
git rm --cached large.file
git commit --amend -CHEAD
```

サイズの大きいファイルを LFS で追跡します．

```sh
git lfs track large.file
git add .gitattributes && git commit -m "Track large file"
git add large.file && git commit -m "Add large file"
```

これで push すれば large.file も GitHub にアップロードできるようになります．

```sh
git push origin master
```

```text
Uploading LFS objects: 100% (1/1), 125 MB | 0 B/s, done.
Enumerating objects: 9, done.
Counting objects: 100% (9/9), done.
Delta compression using up to 16 threads
Compressing objects: 100% (7/7), done.
Writing objects: 100% (9/9), 900 bytes | 900.00 KiB/s, done.
Total 9 (delta 1), reused 0 (delta 0), pack-reused 0
remote: Resolving deltas: 100% (1/1), done.
To github.com:user/git-lfs-test.git
 * [new branch]      master -> master
```

## **注意点**

GitHub では LFS を用いて管理できるサイズにはアカウント単位で上限が存在します．詳しい内容は [GitHub - About storage and bandwidth usage](https://docs.github.com/en/repositories/working-with-files/managing-large-files/about-storage-and-bandwidth-usage) を見ることをおすすめしますが，現状でどれだけ利用しているかといった情報は <https://github.com/settings/billing> の Git LFS Data から確認できます．
