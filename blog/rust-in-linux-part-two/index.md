---
title: "Rust in Linux part two"
description: ""
date: 2024-01-28T12:00:00+09:00
tags: []
---

## 目的

以前にうまく行かなかった kernel 内での Rust の使用を再度試してみたい。

- [Rust in Linux](/blog/rust-in-linux/)

最近 rust で LKM を作成する記事を新たにいくつか見かけたので、それらを参考にしたら今回こそはうまく行くのではないかと思っています。

- [自作のカーネルモジュールをRustで作る](https://gihyo.jp/admin/serial/01/ubuntu-recipe/0793)

## やること

前回は VM に Fedra をインストールして試していましたが、今回は実機の Arch Linux を使用します。

デフォルトの linux パッケージでは Rust を使用するためのオプションが有効になっていないので、カーネルをビルドする必要があります。

```sh
grep CONFIG_RUST /usr/src/linux/.config
# No output
```

LKM については先程の記事を参考にして、Kernel 内にある [rust_minimal.rs](https://elixir.bootlin.com/linux/v6.7/source/samples/rust/rust_minimal.rs) をロードできるようにします。

具体的には下記のようになります。

```text
.
├── Makefile
└── src
   ├── rust_minimal.rs
   └── Makefile
```

```Makefile title="Makefile"
KVER ?= $(shell uname -r)
KDIR ?= /usr/lib/modules/$(KVER)/build

RUSTFMT = rustfmt
RUST_FLAGS = CROSS_COMPILE=x86_64-linux-gnu-
RUST_FLAGS += HOSTRUSTC=rustc
RUST_FLAGS += RUSTC=rustc
RUST_FLAGS += BINDGEN=bindgen
RUST_FLAGS += RUSTFMT=$(RUSTFMT)
RUST_FLAGS += RUST_LIB_SRC=$(shell rustc --print sysroot)/lib/rustlib/src/rust/library

default:
	$(MAKE) LLVM=1 $(RUST_FLAGS) -C $(KDIR) M=$$PWD/src

install: default
	kmodsign sha512 \
		/var/lib/shim-signed/mok/MOK.priv \
		/var/lib/shim-signed/mok/MOK.der \
		src/hello.ko
	$(MAKE) -C $(KDIR) M=$$PWD/src modules_install
	depmod -A

fmt:
	find . -type f -name '*.rs' | xargs $(RUSTFMT)

clean:
	$(MAKE) $(RUNST_FLAGS) -C $(KDIR) M=$$PWD/src clean
```

```rust title="src/rust_minimal.rs"
// SPDX-License-Identifier: GPL-2.0

//! Rust minimal sample.

use kernel::prelude::*;

module! {
    type: RustMinimal,
    name: "rust_minimal",
    author: "Rust for Linux Contributors",
    description: "Rust minimal sample",
    license: "GPL",
}

struct RustMinimal {
    numbers: Vec<i32>,
}

impl kernel::Module for RustMinimal {
    fn init(_module: &'static ThisModule) -> Result<Self> {
        pr_info!("Rust minimal sample (init)\n");
        pr_info!("Am I built-in? {}\n", !cfg!(MODULE));

        let mut numbers = Vec::new();
        numbers.try_push(72)?;
        numbers.try_push(108)?;
        numbers.try_push(200)?;

        Ok(RustMinimal { numbers })
    }
}

impl Drop for RustMinimal {
    fn drop(&mut self) {
        pr_info!("My numbers are {:?}\n", self.numbers);
        pr_info!("Rust minimal sample (exit)\n");
    }
}
```

```Makefile title="src/Makefile"
obj-m := rust_minimal.o
```

以下は試行錯誤の記録です。

## 方法１：AUR の linux-rust を使用する (失敗した)

前回はカーネルビルドでそもそも失敗していた記憶があるので、試しに AUR で調べてみると rust が有効になっているらしいカーネル (v6.6) を発見。(前回参考にした記事を書いていた人がメンテナになっていた)

- [linux-rust](https://aur.archlinux.org/packages/linux-rust/)
  - mirror: https://github.com/rnestler/archpkg-linux-rust

試しにインストールしてみる。

`paru -S linux-rust` でインストールできますが、make がシングルスレッドになっていたり、ドキュメントをビルドするようになっていたりするので、少し調整してからビルドします。

### Build

PKGBUILD を取得:

```sh
git clone git@github.com:rnestler/archpkg-linux-rust.git
```

PKGBUILD を編集:

```diff
diff --git a/PKGBUILD b/PKGBUILD
index 7f0db73..b859ccc 100644
--- a/PKGBUILD
+++ b/PKGBUILD
@@ -90,8 +90,8 @@ prepare() {

 build() {
   cd $_srcname
-  make LLVM=1 all
-  make LLVM=1 htmldocs
+  make LLVM=1 all -j5
+  # make LLVM=1 htmldocs
 }

 _package() {
@@ -245,7 +245,7 @@ _package-docs() {
 pkgname=(
   "$pkgbase"
   "$pkgbase-headers"
-  "$pkgbase-docs"
+  # "$pkgbase-docs"
 )
 for _p in "${pkgname[@]}"; do
   eval "package_$_p() {
```

build:

```sh
makepkg -s
```

このままビルドすると headers のパッケージを作成するときの \_package-headers() で target.json がないというエラーが発生。

```sh
_package-headers() {
  ...
  # Rust support
  echo "Installing Rust files..."
  install -Dt "$builddir/rust" -m644 scripts/target.json
  install -Dt "$builddir/rust" -m644 rust/*.rmeta
  install -Dt "$builddir/rust" -m644 rust/*.so
  install -Dt "$builddir" -m644 ../../rust-toolchain
  ...
}
```

実際に pkg/ 以下のビルド時のディレクトリを見てみるとたしかに scripts/target.json がない。

target.json は rust の cross compile の設定に使われるファイルらしく以下のようになっていれば良いらしい。
(https://github.com/archlinux/linux より)

```json
{
    "arch": "x86_64",
    "data-layout": "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128",
    "features": "-3dnow,-3dnowa,-mmx,+soft-float,+retpoline-external-thunk",
    "llvm-target": "x86_64-linux-gnu",
    "target-pointer-width": "64",
    "emit-debug-gdb-scripts": false,
    "frame-pointer": "may-omit",
    "stack-probes": {"kind": "none"}
}
```

再度カーネルビルドすると今度は問題なく終了。

\*.pkg.tar.zst が生成されるので、これをインストールする。

```sh
sudo pacman -U linux-rust-6.6.10.arch1-1-x86_64.pkg.tar.zst linux-rust-headers-6.6.10.arch1-1-x86_64.pkg.tar.zst
```

### Setup bootloader

Systemd-boot の場合、以下のようにエントリーを追加する。
(option は環境によると思うので linux.conf からコピーする)

```sh
sudo nvim /boot/loader/entries/linux-rust.conf
```

```conf title="/boot/loader/entries/linux-rust.conf"
title Arch Linux (linux-rust)
linux   /vmlinuz-linux-rust
initrd  /initramfs-linux-rust.img
options <options>
```

grub の場合は（多分）以下のように設定をアップデートすればOK。

```sh
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

reboot

### LKM のビルド

このカーネルをインストールして LKM を作成してみたが、モジュールのビルドに失敗してしまった。
(エラーログを記録するのを忘れていたけど、ざっくり言うと core crate などの依存関係が解決できないという感じだった)

Makefile では `RUST_LIB_SRC=$(shell rustc --print sysroot)/lib/rustlib/src/rust/library` としていて、実際にこのディレクトリを確認したら core などの crate は存在していた。

RUST_LIB_SRC が正しく設定されていないのだろうと思ったので、原因を調べるために RUST_LIB_SRC がどのように使われているのかを調べてみた。

GitHub から clone した linux kernel で検索すると下記のように `rust/Makefile` で `RUST_LIB_SRC` が使用されていた。

```text
% fd -tf -x grep -Hni --color=always "RUST_LIB_SRC"
./Makefile:584:ifdef RUST_LIB_SRC
./Makefile:585: export RUST_LIB_SRC
./scripts/rust_is_available_test.py:271:        result = self.run_script(self.Expected.FAILURE, { "RUST_LIB_SRC": self.missing })
./scripts/rust_is_available.sh:253:rustc_src=${RUST_LIB_SRC:-"$rustc_sysroot/lib/rustlib/src/rust/library"}
./rust/Makefile:45:RUST_LIB_SRC ?= $(rustc_sysroot)/lib/rustlib/src/rust/library
./rust/Makefile:112:rustdoc-core: $(RUST_LIB_SRC)/core/src/lib.rs FORCE
./rust/Makefile:411:            $(RUST_LIB_SRC) $(KBUILD_EXTMOD) > \
./rust/Makefile:431:$(obj)/core.o: $(RUST_LIB_SRC)/core/src/lib.rs scripts/target.json FORCE
```

しかし、`/usr/lib/modules/$(KVER)/build` の中で `RUST_LIB_SRC` を検索してみると、なぜか `rust/` ディレクトリが見つからなかった。

```text
% fd -tf -x grep -Hni --color=always "RUST_LIB_SRC"
./Makefile:584:ifdef RUST_LIB_SRC
./Makefile:585: export RUST_LIB_SRC
./scripts/rust_is_available_test.py:271:        result = self.run_script(self.Expected.FAILURE, { "RUST_LIB_SRC": self.missing })
./scripts/rust_is_available.sh:253:rustc_src=${RUST_LIB_SRC:-"$rustc_sysroot/lib/rustlib/src/rust/library"}
```

おそらくこれが LKM のビルドに失敗した原因だと思われる。

試しに rust ディレクトリをコピーして再度カーネルビルドをして、LKM をビルドするところまでやってみたがやはり失敗した。

## 方法2: 自分でカーネルをビルドする (失敗ver)

少し面倒ではあるが、自分でカーネルをビルドしてみることにする。

[archlinux/linux](https://github.com/archlinux/linux) からkernel を clone してビルドする。

### Build

まずは menuconfig で CONFIG_RUST を有効にする。
依存関係のあるオプションが色々あるので `/` で検索して適宜確認し、有効にする。

```sh
make LLVM=1 olddefconfig
make LLVM=1 menuconfig
```

コンフィグファイルが作成できたら、ビルドする。

```sh
make LLVM=1 -j5
```

module のインストールと kernel のコピーを行う。

```sh
sudo make LLVM=1 modules_install
sudo cp arch/x86_64/boot/bzImage /boot/vmlinuz-linux-rust-enabled
```

### Setup bootloader

方法１と同様に bootloader の設定を行う。

```sh
sudo nvim /boot/loader/entries/linux-rust-enabled.conf
```

```conf title="/boot/loader/entries/linux-rust-enabled.conf"
title Arch Linux (linux-rust-enabled)
linux   /vmlinuz-linux-rust-enabled
initrd  /initramfs-linux-rust-enabled.img
options <options>
```

initramfs を作成する。

```sh
sudo mkinitcpio -p linux-rust-enabled
```

reboot

...

起動しない。

systemd-boot で linux-rust-enabled を選択したところ画面に以下のログが出てスタックした。

```text
EFI stub: Loaded initrd from LINUX_EFI_INITRD_MEDIA_GUID device path
EFI stub: Measured initrd data into PCR 9
```

一旦、通常のカーネルに戻して調査する。

とりあえず initramfs を作成したときのログをよく見てみると、以下のような警告が出ていた。

```text
% sudo mkinitcpio -p linux-rust-enabled
==> Building image from preset: /etc/mkinitcpio.d/linux-rust-enabled.preset: 'default'
==> Using configuration file: '/etc/mkinitcpio-rust-enabled.conf'
  -> -k /boot/vmlinuz-linux-rust-enabled -c /etc/mkinitcpio-rust-enabled.conf -g /boot/initramfs-linux-rust-enabled.img --microcode /boot/intel-ucode.img
==> Starting build: '6.7.1-arch1'
  -> Running build hook: [base]
  -> Running build hook: [udev]
  -> Running build hook: [autodetect]
  -> Running build hook: [modconf]
  -> Running build hook: [kms]
  -> Running build hook: [keyboard]
  -> Running build hook: [keymap]
  -> Running build hook: [consolefont]
==> WARNING: consolefont: no font found in configuration
  -> Running build hook: [block]
  -> Running build hook: [encrypt]
  -> Running build hook: [filesystems]
  -> Running build hook: [fsck]
==> Generating module dependencies
==> Creating zstd-compressed initcpio image: '/boot/initramfs-linux-rust-enabled.img'
==> WARNING: errors were encountered during the build. The image may not be complete.
==> Building image from preset: /etc/mkinitcpio.d/linux-rust-enabled.preset: 'fallback'
==> Using configuration file: '/etc/mkinitcpio-rust-enabled.conf'
  -> -k /boot/vmlinuz-linux-rust-enabled -c /etc/mkinitcpio-rust-enabled.conf -g /boot/initramfs-linux-rust-enabled-fallback.img -S autodetect --microcode /boot/intel-ucode.img
==> Starting build: '6.7.1-arch1'
  -> Running build hook: [base]
  -> Running build hook: [udev]
  -> Running build hook: [modconf]
  -> Running build hook: [kms]
  -> Running build hook: [keyboard]
  -> Running build hook: [keymap]
  -> Running build hook: [consolefont]
==> WARNING: consolefont: no font found in configuration
  -> Running build hook: [block]
  -> Running build hook: [encrypt]
  -> Running build hook: [filesystems]
  -> Running build hook: [fsck]
==> Generating module dependencies
==> Creating zstd-compressed initcpio image: '/boot/initramfs-linux-rust-enabled-fallback.img'
==> WARNING: errors were encountered during the build. The image may not be complete.
```

通常のカーネルでも `==> WARNING: consolefont: no font found in configuration` などは出ていたが、
`==> WARNING: errors were encountered during the build. The image may not be complete.` などは出ておらず、
`==> Image generation successful` となっていた。

なんとなくモジュールが不足していそうなのと、`RPM 9` などの記述から TPM のモジュールが必要かと思ったので、menuconfig で関連していそうなオプションを探して有効にしてみた。

結果としては同じログが出て起動はしなかった…。

(systemd-boot のログが出ていないかと思って journalctl で後で確認してみたが、それらしきログは見つからなかった。)

## 方法3: 自分でカーネルをビルドする (成功ver)

不足している kernel config がありそうなので、 [linux-rust](https://github.com/rnestler/archpkg-linux-rust) の config を流用してみる。

linux-rust のカーネルは LKM のビルドには失敗したものの、起動まではできたので起動する上で必要な driver などは含まれているはず。

`.config` をコピーして rustc のバージョンなど、いくつかのオプションを修正した状態で再度ビルドする。

ベースとするコードは [archlinux/linux](https://github.com/archlinux/linux) を使用する。

### Build

config を配置した後、再度ビルド。（`LLVM=1` は `make -j5` でだけ付ければいいかも？）

```sh
make LLVM=1 olddefconfig
make LLVM=1 menuconfig
make LLVM=1 -j5
sudo make LLVM=1 modules_install
sudo cp arch/x86_64/boot/bzImage /boot/vmlinuz-linux-rust-enabled
```

config を一通り見ていて思ったが、失敗したときの config では nvme などの driver が有効になっていなかったようなのでそれが問題な気がしている。

明らかにコンパイルしているモジュールが多く、時間がかかっているので期待が持てる。

### Setup bootloader

先程と同様に bootloader の設定を行う。

```sh
sudo nvim /boot/loader/entries/linux-rust-enabled.conf
```

```text title="/boot/loader/entries/linux-rust-enabled.conf"
title Arch Linux (linux-rust-enabled)
linux   /vmlinuz-linux-rust-enabled
initrd  /initramfs-linux-rust-enabled.img
options <options>
```

initramfs を作成する。(無駄な kernel config が有効になっていたせいで fallback のimage サイズが大きすぎて /boot パーティションに入り切らなかったので fallback は作成しないようにした。改良の余地あり)

```text
% sudo mkinitcpio -p linux-rust-enabled
==> Building image from preset: /etc/mkinitcpio.d/linux-rust-enabled.preset: 'default'
==> Using configuration file: '/etc/mkinitcpio-rust-enabled.conf'
  -> -k /boot/vmlinuz-linux-rust-enabled -c /etc/mkinitcpio-rust-enabled.conf -g /boot/initramfs-linux-rust-enabled.img --microcode /boot/intel-ucode.img
==> Starting build: '6.7.1-arch1'
  -> Running build hook: [base]
  -> Running build hook: [udev]
  -> Running build hook: [autodetect]
  -> Running build hook: [modconf]
  -> Running build hook: [kms]
  -> Running build hook: [keyboard]
==> WARNING: Possibly missing firmware for module: 'xhci_pci'
  -> Running build hook: [keymap]
  -> Running build hook: [consolefont]
==> WARNING: consolefont: no font found in configuration
  -> Running build hook: [block]
  -> Running build hook: [encrypt]
  -> Running build hook: [filesystems]
  -> Running build hook: [fsck]
==> Generating module dependencies
==> Creating zstd-compressed initcpio image: '/boot/initramfs-linux-rust-enabled.img'
==> Image generation successful
```

今回はうまく作成できたようで、reboot するとちゃんと起動した。

### LKM の作成

冒頭に書いた通り、[rust_minimal.rs](https://elixir.bootlin.com/linux/v6.7/source/samples/rust/rust_minimal.rs) をロードできるようにする。

make を実行するとエラーもなくビルドできた。

```text
% make
make LLVM=1 CROSS_COMPILE=x86_64-linux-gnu- HOSTRUSTC=rustc RUSTC=rustc BINDGEN=bindgen RUSTFMT=rustfmt RUST_LIB_SRC=/home/mori/.rustup/toolchains/1.73.0-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library -C /usr/lib/modules/6.7.1-arch1/build M=$PWD/src
make[1]: Entering directory '/home/mori/workspace/archlinux-kernel'
  RUSTC [M] /home/mori/workspace/rust-module/module/src/rust_minimal.o
  MODPOST /home/mori/workspace/rust-module/module/src/Module.symvers
  CC [M]  /home/mori/workspace/rust-module/module/src/rust_minimal.mod.o
  LD [M]  /home/mori/workspace/rust-module/module/src/rust_minimal.ko
  BTF [M] /home/mori/workspace/rust-module/module/src/rust_minimal.ko
die__process_class: tag not supported 0x33 (variant_part)!
die__process_class: tag not supported 0x2f (template_type_parameter)!
make[1]: Leaving directory '/home/mori/workspace/archlinux-kernel'
```

モジュールをロード/アンロードしてみる。

```sh
sudo insmod src/rust_minimal.ko
sudo rmmod rust_minimal
```

```text
[  160.098129] rust_minimal: loading out-of-tree module taints kernel.
[  160.098132] rust_minimal: module verification failed: signature and/or required key missing - tainting kernel
[  160.098596] rust_minimal: Rust minimal sample (init)
[  160.098598] rust_minimal: Am I built-in? false
[  180.365691] rust_minimal: My numbers are [72, 108, 200]
[  180.365696] rust_minimal: Rust minimal sample (exit)
```

やっとうまくいった！

## まとめ

あまり時間を取れなかったこともあって前回に試してからかなり期間が空いてしまったが、とりあえずうまく行ってよかった。

振り返ると rust のモジュールを作る上で詰まった点が 3 点ほどあった。

- CONFIG_RUST が有効になったカーネルを使用すること
- Rust 製 LKM の Makefile の書き方
- Rust の toolchain の使い方

今回はなんとかそれらを解決できたので、今後は rust の LKM でもう少し色々と遊んでみたいと思う。

最近の Ubuntu kernel では CONFIG_RUST が有効になっているので、Ubuntu で試してみるのも良いかもしれない。
