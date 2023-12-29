---
title: "Rust in Linux"
description: "失敗メモ"
date: 2023-05-03T21:18:29+09:00
tags: []
---

## 目的

Linux v6.1 からカーネル内で Rust が使用できるようになったので rust-in-linux を試してみたい！

>当初の目標として
>
>- LKMを作成する
>- system call を追加して rust で書いたハンドラを呼ぶ（カーネルに組み込む）
>
>あたりができると良かったのですが、GW中にはうまく動かせないこと＋今の所はそこまで手軽に使えなさそうということがわかったので後学のために記録しておきます。
>一応、参考になりそうなページについては [references](#references) を参照（カーネルがフォークだったりするので環境やバージョンの違いに注意）。

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

さて、本題の Linux ではどうかというと v6.1 から使えるようになっています。

- [The Initial Rust Infrastructure Has Been Merged Into Linux 6.1](https://www.phoronix.com/news/Rust-Is-Merged-Linux-6.1)

Linux カーネル自体の rewrite については今の所考えられていないようですが、ドライバなどを始めとして少しずつ導入していくつもりのようです。
Linux の脆弱性に関する分析ではメインのカーネルよりもドライバに大量のバグがあるという指摘もよくあるので、そのあたりを改善できると良さそうです。
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

[Documents - rust/quick-start](https://docs.kernel.org/rust/quick-start.html) を参考に必要そうなものをインストールします。
まずは rustup のインストール。

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

bindgen をインストールします。これははCとRustを連携させるために必要なソフトウェアのようです。

```sh
cargo install --locked --version `scripts/min-tool-version.sh bindgen` bindgen
```

その他の quick-start には書かれていないけれど必要なものをインストールします。

```sh
sudo dnf install kernel-devel llvm lld dwarves zstd ncurses-devel
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

LLVMでカーネルビルドをしていきます。

```sh
make LLVM=1 -j7
```

```sh
sudo make modules_install && sudo make install
```

```sh
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
```

> 実行したあとにうまく行ったか分かりづらいときは `echo $?` で確認する

### Reboot して確認

```sh
reboot
```

Grub のメニューでカスタムカーネルを選択したときに `bad shim signature` とか言われた場合は Secure Boot が邪魔をしているので EFI 設定に入って disable にしてください。

```text
$ uname -a
Linux localhost.localdomain 6.3.1 #4 SMP PREEMPT_DYNAMIC Fri May  5 15:55:31 JST 2023 x86_64 GNU/Linux
```

とりあえずLLVMでコンパイルしたカーネルを動かすことができました。

## Rust を使えるようにする

> ここから先は今回うまくできなかった部分ですが一応記録。

`.config` を修正する必要があるので修正します。

```sh
make menuconfig
```

修正箇所1: Rust サポートを有効にする

- General setup
  - Rust support

修正箇所2: ソース内の samples/rust/* にあるサンプルコードをモジュールとして追加する

- Kernel hacking
  - Sample kernel code
    - Rust samples
      - Minimal
      - Printing macros

以下は再度ビルドした結果、失敗している様子です。
`make LLVM=1 rustavailable` を実行した感じでは問題なさそうだったのでツールのインストールやパスの指定とかが問題ではなさそう？

```text
[mmori@localhost linux-6.3.1]$ make LLVM=1 -j6
  DESCEND objtool
  CALL    scripts/checksyscalls.sh
  INSTALL libsubcmd_headers
  BINDGEN rust/bindings/bindings_generated.rs
thread 'main' panicked at '"ftrace_branch_data_union_(anonymous_at__/_/include/linux/compiler_types_h_146_2)" is not a valid Ident', /home/mmori/.cargo/registry/src/github.com-1ecc6299db9ec823/proc-macro2-1.0.56/src/fallback.rs:811:9
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace
make[1]: *** [rust/Makefile:303: rust/bindings/bindings_generated.rs] Error 1
make[1]: *** Deleting file 'rust/bindings/bindings_generated.rs'
make: *** [Makefile:1292: prepare] Error 2
```

```text
[mmori@localhost linux-6.3.1]$ make LLVM=1 -j6 RUST_BACKTRACE=1
  DESCEND objtool
  CALL    scripts/checksyscalls.sh
  INSTALL libsubcmd_headers
  BINDGEN rust/bindings/bindings_generated.rs
thread 'main' panicked at '"ftrace_branch_data_union_(anonymous_at__/_/include/linux/compiler_types_h_146_2)" is not a valid Ident', /home/mmori/.cargo/registry/src/github.com-1ecc6299db9ec823/proc-macro2-1.0.56/src/fallback.rs:811:9
stack backtrace:
   0: rust_begin_unwind
             at /rustc/a8314ef7d0ec7b75c336af2c9857bfaf43002bfc/library/std/src/panicking.rs:584:5
   1: core::panicking::panic_fmt
             at /rustc/a8314ef7d0ec7b75c336af2c9857bfaf43002bfc/library/core/src/panicking.rs:142:14
   2: proc_macro2::fallback::Ident::_new
   3: proc_macro2::Ident::new
   4: bindgen::ir::context::BindgenContext::rust_ident
   5: <bindgen::ir::comp::CompInfo as bindgen::codegen::CodeGenerator>::codegen
   6: <bindgen::ir::ty::Type as bindgen::codegen::CodeGenerator>::codegen
   7: <bindgen::ir::item::Item as bindgen::codegen::CodeGenerator>::codegen
   8: <bindgen::ir::comp::CompInfo as bindgen::codegen::CodeGenerator>::codegen
   9: <bindgen::ir::ty::Type as bindgen::codegen::CodeGenerator>::codegen
  10: <bindgen::ir::item::Item as bindgen::codegen::CodeGenerator>::codegen
  11: <bindgen::ir::module::Module as bindgen::codegen::CodeGenerator>::codegen
  12: <bindgen::ir::item::Item as bindgen::codegen::CodeGenerator>::codegen
  13: bindgen::ir::context::BindgenContext::gen
  14: bindgen::Builder::generate
  15: std::panicking::try
  16: bindgen::main
note: Some details are omitted, run with `RUST_BACKTRACE=full` for a verbose backtrace.
make[1]: *** [rust/Makefile:303: rust/bindings/bindings_generated.rs] Error 1
make[1]: *** Deleting file 'rust/bindings/bindings_generated.rs'
make: *** [Makefile:1292: prepare] Error 2
```

```text
[mmori@localhost linux-6.3.1]$ make LLVM=1 -j6 RUST_BACKTRACE=full
  DESCEND objtool
  CALL    scripts/checksyscalls.sh
  INSTALL libsubcmd_headers
  BINDGEN rust/bindings/bindings_generated.rs
thread 'main' panicked at '"ftrace_branch_data_union_(anonymous_at__/_/include/linux/compiler_types_h_146_2)" is not a valid Ident', /home/mmori/.cargo/registry/src/github.com-1ecc6299db9ec823/proc-macro2-1.0.56/src/fallback.rs:811:9
stack backtrace:
   0:     0x55b400da7ffd - std::backtrace_rs::backtrace::libunwind::trace::hb729d9642bb971eb
                               at /rustc/a8314ef7d0ec7b75c336af2c9857bfaf43002bfc/library/std/src/../../backtrace/src/backtrace/libunwind.rs:93:5
   1:     0x55b400da7ffd - std::backtrace_rs::backtrace::trace_unsynchronized::h373bb774579df5c7
                               at /rustc/a8314ef7d0ec7b75c336af2c9857bfaf43002bfc/library/std/src/../../backtrace/src/backtrace/mod.rs:66:5
   2:     0x55b400da7ffd - std::sys_common::backtrace::_print_fmt::hfbd4e92d240c89bb
                               at /rustc/a8314ef7d0ec7b75c336af2c9857bfaf43002bfc/library/std/src/sys_common/backtrace.rs:66:5
   3:     0x55b400da7ffd - <std::sys_common::backtrace::_print::DisplayBacktrace as core::fmt::Display>::fmt::h8f618991fbf64972
                               at /rustc/a8314ef7d0ec7b75c336af2c9857bfaf43002bfc/library/std/src/sys_common/backtrace.rs:45:22
   4:     0x55b400dcdcfc - core::fmt::write::hc69b5b640d88cce8
                               at /rustc/a8314ef7d0ec7b75c336af2c9857bfaf43002bfc/library/core/src/fmt/mod.rs:1196:17
   5:     0x55b400da47d1 - std::io::Write::write_fmt::h3403cef06a24a303
                               at /rustc/a8314ef7d0ec7b75c336af2c9857bfaf43002bfc/library/std/src/io/mod.rs:1654:15
   6:     0x55b400da97d5 - std::sys_common::backtrace::_print::h368f27cdedea0e52
                               at /rustc/a8314ef7d0ec7b75c336af2c9857bfaf43002bfc/library/std/src/sys_common/backtrace.rs:48:5
   7:     0x55b400da97d5 - std::sys_common::backtrace::print::ha105c9cf5a64cd17
                               at /rustc/a8314ef7d0ec7b75c336af2c9857bfaf43002bfc/library/std/src/sys_common/backtrace.rs:35:9
   8:     0x55b400da97d5 - std::panicking::default_hook::{{closure}}::h48ed2c3707d5e20e
                               at /rustc/a8314ef7d0ec7b75c336af2c9857bfaf43002bfc/library/std/src/panicking.rs:295:22
   9:     0x55b400da9449 - std::panicking::default_hook::h8744fc5cea5e3110
                               at /rustc/a8314ef7d0ec7b75c336af2c9857bfaf43002bfc/library/std/src/panicking.rs:314:9
  10:     0x55b400da9da8 - std::panicking::rust_panic_with_hook::hc82286af2030e925
                               at /rustc/a8314ef7d0ec7b75c336af2c9857bfaf43002bfc/library/std/src/panicking.rs:698:17
  11:     0x55b400da9c57 - std::panicking::begin_panic_handler::{{closure}}::h1c15057c2f09081f
                               at /rustc/a8314ef7d0ec7b75c336af2c9857bfaf43002bfc/library/std/src/panicking.rs:588:13
  12:     0x55b400da84b4 - std::sys_common::backtrace::__rust_end_short_backtrace::h65de906a5330f8da
                               at /rustc/a8314ef7d0ec7b75c336af2c9857bfaf43002bfc/library/std/src/sys_common/backtrace.rs:138:18
  13:     0x55b400da9989 - rust_begin_unwind
                               at /rustc/a8314ef7d0ec7b75c336af2c9857bfaf43002bfc/library/std/src/panicking.rs:584:5
  14:     0x55b400ba06e3 - core::panicking::panic_fmt::h741cfbfc95bc6112
                               at /rustc/a8314ef7d0ec7b75c336af2c9857bfaf43002bfc/library/core/src/panicking.rs:142:14
  15:     0x55b400d82cbb - proc_macro2::fallback::Ident::_new::hd54a7f37b4be5ac2
  16:     0x55b400d84132 - proc_macro2::Ident::new::h5b24a800de987e3d
  17:     0x55b400c87dd2 - bindgen::ir::context::BindgenContext::rust_ident::hfb669cd12fde5045
  18:     0x55b400c97543 - <bindgen::ir::comp::CompInfo as bindgen::codegen::CodeGenerator>::codegen::hdac53e6a48364ded
  19:     0x55b400cb2df3 - <bindgen::ir::ty::Type as bindgen::codegen::CodeGenerator>::codegen::h9ea78383a1519d12
  20:     0x55b400c24993 - <bindgen::ir::item::Item as bindgen::codegen::CodeGenerator>::codegen::h7f1cb457e8b5962b
  21:     0x55b400c9a76e - <bindgen::ir::comp::CompInfo as bindgen::codegen::CodeGenerator>::codegen::hdac53e6a48364ded
  22:     0x55b400cb2df3 - <bindgen::ir::ty::Type as bindgen::codegen::CodeGenerator>::codegen::h9ea78383a1519d12
  23:     0x55b400c24993 - <bindgen::ir::item::Item as bindgen::codegen::CodeGenerator>::codegen::h7f1cb457e8b5962b
  24:     0x55b400c7c063 - <bindgen::ir::module::Module as bindgen::codegen::CodeGenerator>::codegen::hcaa3f952aaaebcd2
  25:     0x55b400c24963 - <bindgen::ir::item::Item as bindgen::codegen::CodeGenerator>::codegen::h7f1cb457e8b5962b
  26:     0x55b400c8b3f3 - bindgen::ir::context::BindgenContext::gen::h8d593441c41f4c9e
  27:     0x55b400c42e7a - bindgen::Builder::generate::hc6be0353ef288055
  28:     0x55b400bbf63f - std::panicking::try::hfac0a9d96478463b
  29:     0x55b400ba9766 - bindgen::main::h66dca222f748f7fb
  30:     0x55b400bc0353 - std::sys_common::backtrace::__rust_begin_short_backtrace::he9f5e905c5b4f99b
  31:     0x55b400bab539 - std::rt::lang_start::{{closure}}::h309e4f396102cd0f
  32:     0x55b400d9f12e - core::ops::function::impls::<impl core::ops::function::FnOnce<A> for &F>::call_once::hf833e7144973d4be
                               at /rustc/a8314ef7d0ec7b75c336af2c9857bfaf43002bfc/library/core/src/ops/function.rs:280:13
  33:     0x55b400d9f12e - std::panicking::try::do_call::h79761d203bfb6b46
                               at /rustc/a8314ef7d0ec7b75c336af2c9857bfaf43002bfc/library/std/src/panicking.rs:492:40
  34:     0x55b400d9f12e - std::panicking::try::h0561cbbe1722251d
                               at /rustc/a8314ef7d0ec7b75c336af2c9857bfaf43002bfc/library/std/src/panicking.rs:456:19
  35:     0x55b400d9f12e - std::panic::catch_unwind::hbca347ddd031b141
                               at /rustc/a8314ef7d0ec7b75c336af2c9857bfaf43002bfc/library/std/src/panic.rs:137:14
  36:     0x55b400d9f12e - std::rt::lang_start_internal::{{closure}}::h0492050ad281ec32
                               at /rustc/a8314ef7d0ec7b75c336af2c9857bfaf43002bfc/library/std/src/rt.rs:128:48
  37:     0x55b400d9f12e - std::panicking::try::do_call::h3ebce69871996bb3
                               at /rustc/a8314ef7d0ec7b75c336af2c9857bfaf43002bfc/library/std/src/panicking.rs:492:40
  38:     0x55b400d9f12e - std::panicking::try::hbed537d20e728475
                               at /rustc/a8314ef7d0ec7b75c336af2c9857bfaf43002bfc/library/std/src/panicking.rs:456:19
  39:     0x55b400d9f12e - std::panic::catch_unwind::h4185e2024c6a5d05
                               at /rustc/a8314ef7d0ec7b75c336af2c9857bfaf43002bfc/library/std/src/panic.rs:137:14
  40:     0x55b400d9f12e - std::rt::lang_start_internal::h1899cfd715ca6829
                               at /rustc/a8314ef7d0ec7b75c336af2c9857bfaf43002bfc/library/std/src/rt.rs:128:20
  41:     0x55b400ba9ad2 - main
  42:     0x7fd85b1afb4a - __libc_start_call_main
  43:     0x7fd85b1afc0b - __libc_start_main@@GLIBC_2.34
  44:     0x55b400ba0985 - _start
  45:                0x0 - <unknown>
make[1]: *** [rust/Makefile:303: rust/bindings/bindings_generated.rs] Error 1
make[1]: *** Deleting file 'rust/bindings/bindings_generated.rs'
make: *** [Makefile:1292: prepare] Error 2
```

## ~~LKM を書いてみる~~

## ~~Systemcall を追加して rust の関数を呼び出す~~

## 最後に

Linux における rust の使用はまだ導入されたばかりとはいえ、もっと気軽に使えると期待していたのでかなり残念な結果でした。
現状でうまくカーネルモジュールなどを作成している英語記事はいくつか見つけましたが、環境の違いなどもあってそのままでは使えなさそう。
Linux のメインラインを使っているのではなく [Rust for Linux/linux](https://github.com/Rust-for-Linux/linux) やそのフォークの [jackos/linux](https://github.com/jackos/linux) を使っているものも多いです。
加えて今回やろうと思っていたLKMについてはCで書いたLKMとは作り方が異なるようで気軽に作りづらそう。
多分まだ変化が大きい部分だと思うので継続的にキャッチアップしていく必要がありそうです。

Rust という言語そのものに関して言うと、個人的には使いたいけど難しい言語ナンバーワンだと思うので、カーネルをいじったりしながら少しずつ使いこなせるようになりたいです。
RedoxOS あたりから触るのも良いかもしれない？

## References

- [Writing Linux Kernel Modules In Rust](https://www.linuxfoundation.org/webinars/writing-linux-kernel-modules-in-rust)
  - Linux foundation の記事。動画もあるので比較的丁寧ではある。カーネルビルドして作ったイメージをQEMUで動かす感じ。
- [Building an out-of-tree Rust Kernel Module](https://blog.rnstlr.ch/building-an-out-of-tree-rust-kernel-module.html)
- [Building an out-of-tree Rust Kernel Module Part Two](https://blog.rnstlr.ch/building-an-out-of-tree-rust-kernel-module-part-two.html)
  - 私と同じく苦労してそうな方のブログ。ビルドは成功したけどモジュールがロードできなかったりしてる。btw i use arch。
- [Rust-for-Linux/rust-out-of-tree-module](https://github.com/Rust-for-Linux/rust-out-of-tree-module)
  - 比較的イメージしていたRustの使い方に近いもの。環境の違いによるものか、うまく行かない。
- [Linux kernel development](https://www.jackos.io/rust-kernel/rust-for-linux.html)
  - Linux foundation のやり方に近い。使用しているカーネルはRust for Linux のやつなのでメジャーバージョンではない。Rustに関して色々と書かれているので他のページをあさると面白そう。
- [Rust Kernel Module: Getting Started](https://wusyong.github.io/posts/rust-kernel-module-00/)
- [Rust Kernel Module: Hello World](https://wusyong.github.io/posts/rust-kernel-module-01/)
  - 上に同じ。
