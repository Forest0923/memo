+++
title = "Rust in Linux"
description = ""
date = 2023-05-03T21:18:29+09:00
tags = [

]
categories = [

]
draft = false
+++

## 目的

Linux v6.1 からカーネル内で Rust が使用できるようになったので rust-in-linux を試してみたい！

## 背景

最近ではソフトウェアを rust で書こうという動きが活発になっています。
Rust はメモリ安全性とパフォーマンスを兼ね備えたプログラミング言語として注目されており、様々なソフトウェアでの採用が進んでいます。

- [The ‘Viral’ Secure Programming Language That’s Taking Over Tech](https://www.wired.com/story/rust-secure-programming-language-memory-safe/)

Dropbox や Discord など様々なソフトウェアで使用されているというのはよく知られていると思います。

- [WHY DISCORD IS SWITCHING FROM GO TO RUST](https://discord.com/blog/why-discord-is-switching-from-go-to-rust)

OS のようなシステムソフトウェアでも Rust を採用しようという流れがあり、Windows ではすでにかなりの書き換えを行っているようです。リリースはまだのようですが。

- [BlueHat IL 2023 - David Weston - Default Security](https://www.youtube.com/watch?v=8T6ClX-y2AE)
- [Microsoft、Windowsのコア部分を「Rust」で書き換えていることを明らかに](https://texal.jp/2023/04/29/microsoft-reveals-that-it-is-rewriting-the-core-of-windows-with-rust/)

Android での採用や影響についても述べられています。

- [Memory Safe Languages in Android 13](https://security.googleblog.com/2022/12/memory-safe-languages-in-android-13.html)
- [Google Begins Allowing Rust Code For Developing Android](https://www.phoronix.com/news/Rust-For-Android-OS-System-Work)

さて、本題の Linux ではどうかというと v6.1 から導入されています。
Linux のリファクタリングについては考えられていないようですが、ドライバなどを始めとして少しずつ導入していくつもりのようです。
私が見ただけでも多くのセキュリティ系の論文でドライバに含まれる大量のバグを問題視したものがあったので、そのあたりを改善できると良さそうです。

- [The Initial Rust Infrastructure Has Been Merged Into Linux 6.1](https://www.phoronix.com/news/Rust-Is-Merged-Linux-6.1)

こうなってくると、そろそろRustに慣れていかないとまずいかな、ということで Linux カーネル内のドキュメントを見ながらとRustを使ってみようと思います。

- [Documents - rust](https://docs.kernel.org/rust/index.html)

## 事前準備

壊れても平気な適当な環境がないので、今回は VM 上で実験します。VM の設定は以下のような感じです。

- CPU: 6 cores, x86_64
- Mem: 8 GB
- Disk: 75 GB
- OS: Fedora 38 server

とりあえず Fedora 環境でカーネルビルドができるようにします。

### Source Code

Linux v6.3.1 上で実験をするのでソースをダウンロードします。
作業用ディレクトリは `$HOME/linux-6.3.1/` です。

```sh
curl -O https://mirrors.edge.kernel.org/pub/linux/kernel/v6.x/linux-6.3.1.tar.xz
tar xf linux-6.3.1.tar.xz
```

### 必要なソフトウェアのインストール

rustup をインストールします。

```sh
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

rustcのバージョンを変更します。

```sh
cd /path/to/kernel-src
rustup override set `scripts/min-tool-version.sh rustc`
rustup component add rust-src
```

clang をインストールします。

```sh
sudo dnf install clang
```

bindgen をインストールします。
bindgen はCとRustを連携させるために必要なソフトウェア。

```sh
cargo install --locked --version `scripts/min-tool-version.sh bindgen` bindgen
```

flex などのビルドに必要なものをインストールします。

```sh
sudo dnf install kernel-devel
sudo dnf install llvm lld
sudo dnf install dwarves
sudo dnf install zstd
```

> dwarves を入れないと
>
> ```text
> BTF: .tmp_vmlinux.btf: pahole (pahole) is not available
> Failed to generate BTF for vmlinux
> ```
>
> みたいになります

### Kernel build

```sh
make LLVM=1 -j7
```

```sh
sudo make modules_install && sudo make install
```

```sh
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
```

### Reboot して確認

```sh
reboot
```

Grub のメニューでカスタムカーネルを選択したときに `bad shim signature` とか言われた場合は Secure Boot が邪魔をしているので disable にしてください。

```text
$ uname -a
Linux localhost.localdomain 6.3.1 #4 SMP PREEMPT_DYNAMIC Fri May  5 15:55:31 JST 2023 x86_64 GNU/Linux
```

とりあえずLLVMでコンパイルしたカーネルを動かすことができました。

## Kernel Module を書いてみる

## 最後に

個人的に Rust は使いたいけど難しい言語ナンバーワンだと思っているのですが、カーネルをいじったりしながら少しずつ使いこなせるようになりたいです。

今の所、参照を持ったデータ構造を作ったときの所有権の扱い方がわからなくて詰んでいるので `Rc` とか `RefCell` あたりを理解できるようになりたいです。
