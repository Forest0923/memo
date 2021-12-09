---
title: "LFS (Large File Storage)"
description: ""
lead: ""
date: 2021-11-29T12:48:05+09:00
lastmod: 2021-11-29T12:48:05+09:00
draft: false
images: []
menu: 
  docs:
    parent: "git"
weight: 50
toc: true
---

## About

The maximum file size that can be uploaded to github is 100MB.
Git Large File Storage enables to upload large file that is larger than 100MB.

## System

- Arch Linux

## Install & Setup

- install:

```
yay -S git-lfs
```

- Global configuration changes:

```
git lfs install
```

## Use case

- Current directory has two files (hello.txt is small enough and large.file is larger than 100MB:

```
user@host local % ls
hello.txt large.file
```

- git init:

```
user@host local % git init
user@host local(master) % git remote add origin git@github.com:user/git-lfs-test.git
```

- Push normally:

```
user@host local(master) % git add .
user@host local(master) % git commit -m "Initial commit"
user@host local(master) % git push origin master
```

- Error log:

```
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

- Remove the large file from commit:

```
user@host local(master) % git rm --cached large.file
rm 'large.file'
user@host local(master) % git commit --amend -CHEAD
[master f154828] Initial commit
 Date: Sat Nov 7 23:38:46 2020 +0900
 1 file changed, 1 insertion(+)
 create mode 100644 hello.txt
```

- Track the large file with Git LFS:

```
user@host local(master) % git lfs track large.file
Tracking "large.file"
user@host local(master) % git add .gitattributes && git commit -m "Track large file"
[master 03348c7] Track local large file
 1 file changed, 1 insertion(+)
 create mode 100644 .gitattributes
user@host local(master) % git add large.file && git commit -m "Add large file"
[master c1b9408] Add local file
 1 file changed, 3 insertions(+)
 create mode 100644 large.file
```

- Push:

```
user@host local(master) % git push origin master
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
