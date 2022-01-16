---
title: "LaTeX スタートアップ：TeX Live のインストール"
draft: false
weight: 10
---

# LaTeX スタートアップ：TeX Live のインストール

LaTeX を使えるようにするための最低限のガイドです．

## 環境

- OS: Linux

## インストール

### **TeX Live**

次のコマンドで TeX Live と日本語の言語パッケージをインストールします．

```sh
# Arch
sudo pacman -S texlive-most texlive-langjapanese
```

```sh
# ubuntu
sudo apt install texlive-full
```

### **jlisting**

日本語を含んだソースコードを載せたい場合は追加で jlisting をダウンロードする必要があります．jlisting を <https://osdn.net/projects/mytexpert/downloads/26068/jlisting.sty.bz2/> からダウンロードして解凍します．

```sh
bzip2 -dk jlisting.sty
```

`/usr/local/share/texmf/tex/latex/` に jlisting 用のディレクトリを作成し，jlisting.sty を入れたら mktexlsr を実行して追加したファイルを反映させます．

```sh
sudo mkdir -p /usr/local/share/texmf/tex/latex/jlisting
sudo mv jlisting.sty /usr/local/share/texmf/tex/latex/jlisting/
cd /usr/local/share/texmf/tex/latex/
sudo mktexlsr
```
