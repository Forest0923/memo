---
title: "LFS (Large File Storage)"
draft: false
weight: 50
---
The maximum file size that can be uploaded to github is 100MB.
Git Large File Storage enables to upload large file that is larger than 100MB.

## **Install**

Install git-lfs with following commands.

{{< tabpane "install" >}}
{{< tab "Arch" >}}

```sh
sudo pacman -S git-lfs
```

{{< /tab >}}
{{< tab "Ubuntu" >}}

```sh
sudo apt install git-lfs
```

{{< /tab >}}
{{< /tabpane >}}

Use the following command to confirm that the installation is complete.

```sh
git lfs install
```

## How to Use

Assume that you have a file smaller than 100MB named hello.txt and a file larger than 100MB named large.file.

```text
.
├── hello.txt
└── large.file
```

If you try to push as usual in this state, you will get the following error message.

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

To use LFS, first delete large files from commit.

```sh
git rm --cached large.file
git commit --amend -CHEAD
```

Track large files with LFS.

```sh
git lfs track large.file
git add .gitattributes && git commit -m "Track large file"
git add large.file && git commit -m "Add large file"
```

Then, you can upload the large.file to GitHub by pushing it.

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

## **Note**

GitHub has a per-account limit on the size of a file that can be managed using LFS. For more information, see [GitHub - About storage and bandwidth usage](https://docs.github.com/en/repositories/working-with-files/managing-large-files/about-storage-and-bandwidth-usage). You can check how much you're currently using from Git LFS Data at <https://github.com/settings/billing>.
