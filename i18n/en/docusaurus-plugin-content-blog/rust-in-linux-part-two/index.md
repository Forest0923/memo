---
title: "Rust in Linux part two"
description: ""
date: 2024-01-28T12:00:00+09:00
tags: []
---

# Purpose

I want to retry using Rust in the linux kernel, which didn't work well before.

- [Rust in Linux](/blog/rust-in-linux/)

Recently, I've come across some new articles about creating LKMs with Rust, so I'm hoping that by following them, it will work well this time.

- [自作のカーネルモジュールをRustで作る](https://gihyo.jp/admin/serial/01/ubuntu-recipe/0793)

# To-Do

Last time, I tried it on a VM with Fedora, but this time I will use Arch Linux on a physical machine.

Since the default linux package doesn't have the options enabled for using Rust, I need to build the kernel.

```sh
grep CONFIG_RUST /usr/src/linux/.config
# No output
```

I will refer to the article and try to install module, [rust_minimal.rs](https://elixir.bootlin.com/linux/v6.7/source/samples/rust/rust_minimal.rs), which is written in the kernel.

Build directory of LKM is as follows:

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

The following is a record of trial and error.

## Method 1: Using AUR's linux-rust (Unsuccessful)

I found a kernel (v6.6) on AUR that seems to have Rust enabled in the kernel build.

- [linux-rust](https://aur.archlinux.org/packages/linux-rust/)
  - mirror: https://github.com/rnestler/archpkg-linux-rust

It is possible to install the package simply by running `paru -S linux-rust`.

However, it had some issues issues such as make not having options for multi-threaded build, and building documentation is included by default, and I don't need it.

So I made some adjustments before building.

### Build

Retrieve PKGBUILD:

```sh
git clone git@github.com:rnestler/archpkg-linux-rust.git
```

Edit PKGBUILD:

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

Build:

```sh
makepkg -s
```

During the build, an error occurred in `_package-headers()` when creating the headers package.

The error said that `target.json` was missing.

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

Indeed, the `scripts/target.json` file was missing in the build directory.

`target.json` seems to be a file used for Rust cross-compile settings and should look like the following (from https://github.com/archlinux/linux):

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

I proceeded with the kernel build again, and this time it completed without issues.

Install the generated `*.pkg.tar.zst`:

```sh
sudo pacman -U linux-rust-6.6.10.arch1-1-x86_64.pkg.tar.zst linux-rust-headers-6.6.10.arch1-1-x86_64.pkg.tar.zst
```

### Setup bootloader

For systemd-boot, add the entry:

```sh
sudo nvim /boot/loader/entries/linux-rust.conf
```

```conf title="/boot/loader/entries/linux-rust.conf"
title Arch Linux (linux-rust)
linux   /vmlinuz-linux-rust
initrd  /initramfs-linux-rust.img
options <options>
```

For GRUB:

```sh
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

Reboot.

### Building LKM

I installed this kernel and attempted to create an LKM.

However, the module build failed (I forgot to record the error log, but in essence, it couldn't resolve dependencies like the core crate).

In the Makefile, `RUST_LIB_SRC` is set as `$(shell rustc --print sysroot)/lib/rustlib/src/rust/library`, and checking this directory, I found the `core` crate and other essential crates were existing.

I suspected that `RUST_LIB_SRC` was not set correctly, so I investigated how it was used.

Searching in the Linux kernel cloned from GitHub, I found that `RUST_LIB_SRC` was used in `rust/Makefile` as follows:

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

However, when searching in `/usr/lib/modules/$(KVER)/build`, I couldn't find `rust/` directory in the first place.

```text
% fd -tf -x grep -Hni --color=always "RUST_LIB_SRC"
./Makefile:584:ifdef RUST_LIB_SRC
./Makefile:585: export RUST_LIB_SRC
./scripts/rust_is_available_test.py:271:        result = self.run_script(self.Expected.FAILURE, { "RUST_LIB_SRC": self.missing })
./scripts/rust_is_available.sh:253:rustc_src=${RUST_LIB_SRC:-"$rustc_sysroot/lib/rustlib/src/rust/library"}
```

This is likely the cause of the failed LKM build.

I tried copying the `rust/` directory and rebuild the kernel, but the issue persisted.

## Method 2: Building the Kernel Yourself (failed)

Although it's a bit cumbersome, let's attempt to build the kernel manually.

Clone the [archlinux/linux](https://github.com/archlinux/linux) repository to build the kernel.

### Build

Firstly, enable CONFIG_RUST in menuconfig.

There are various dependent options, so search with `/` to verify and enable them as needed.

```sh
make LLVM=1 olddefconfig
make LLVM=1 menuconfig
```

Once the configuration file is created, proceed with the build.

```sh
make LLVM=1 -j5
```

Install the modules and copy the kernel.

```sh
sudo make LLVM=1 modules_install
sudo cp arch/x86_64/boot/bzImage /boot/vmlinuz-linux-rust-enabled
```

### Setup Bootloader

Configure the bootloader as in Method 1.

```sh
sudo nvim /boot/loader/entries/linux-rust-enabled.conf
```

```conf title="/boot/loader/entries/linux-rust-enabled.conf"
title Arch Linux (linux-rust-enabled)
linux   /vmlinuz-linux-rust-enabled
initrd  /initramfs-linux-rust-enabled.img
options <options>
```

Create the initramfs.

```sh
sudo mkinitcpio -p linux-rust-enabled
```

Reboot...

It doesn't boot.

When selecting linux-rust-enabled with systemd-boot, the following log appears on the screen, and it hangs.

```text
EFI stub: Loaded initrd from LINUX_EFI_INITRD_MEDIA_GUID device path
EFI stub: Measured initrd data into PCR 9
```

For now, revert to the regular kernel for investigation.

Upon closer inspection of the log generated during initramfs creation, the following warning caught my attention:

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

Although warnings like `==> WARNING: consolefont: no font found in configuration` were present even with the regular kernel, `==> WARNING: errors were encountered during the build. The image may not be complete.` was not present, and `==> Image generation successful` was reported.

It seemed like some modules might be missing, and based on the log like `RPM 9`, I suspected that TPM modules might be necessary.

So, I tried searching for related options in menuconfig and enabling them.

The result was the same log, and the system did not boot correctly.

(I checked journalctl later to see if systemd-boot logs were present, but I couldn't find any relevant logs.)

## Method 3: Building the Kernel Yourself (Successful Version)

As it seems there might be missing kernel configs, let's try utilizing the config from [linux-rust](https://github.com/rnestler/archpkg-linux-rust).

While the linux-rust kernel failed to build modules, it could boot, so it should include the necessary drivers for booting.

Copy the `.config` file and modify a few options, including the Rust version, then proceed with the build using the [archlinux/linux](https://github.com/archlinux/linux) base code.

### Build

After placing the config, build again (`LLVM=1` is only needed with `make -j5` perhaps?).

```sh
make LLVM=1 olddefconfig
make LLVM=1 menuconfig
make LLVM=1 -j5
sudo make LLVM=1 modules_install
sudo cp arch/x86_64/boot/bzImage /boot/vmlinuz-linux-rust-enabled
```

While reviewing the config, I realized that nvme driver is not enabled in the configuration file that it used when failed.
So, I suspect that caused the boot failure.

### Setup Bootloader

Configure the bootloader as before.

```sh
sudo nvim /boot/loader/entries/linux-rust-enabled.conf
```

```text title="/boot/loader/entries/linux-rust-enabled.conf"
title Arch Linux (linux-rust-enabled)
linux   /vmlinuz-linux-rust-enabled
initrd  /initramfs-linux-rust-enabled.img
options <options>
```

Create the initramfs (I omitted creating the fallback image this time because unnecessary kernel config was enabled, and the fallback image size was too large to fit in the /boot partition. There is room for improvement).

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

This time, it seems to have been created successfully, and after a reboot, it booted correctly.

### Creating LKM

As mentioned earlier, I try to build [rust_minimal.rs](https://elixir.bootlin.com/linux/v6.7/source/samples/rust/rust_minimal.rs) as a module.

When I run `make` in the module directory, it succeeds this time.

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

Load and unload the module.

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

Finally, it worked!

## Summary

Looking back, there were three main challenges I encountered while creating the Rust module:

- Using a kernel with the CONFIG_RUST option enabled.
- Writing the Makefile for the Rust-based Loadable Kernel Module (LKM).
- Understanding the usage of Rust's toolchain.

Fortunately, I was able to overcome these hurdles this time.

Moving forward, I am eager to explore and experiment with various aspects of Rust LKMs.

It might be interesting to try this on Ubuntu, considering that recent Ubuntu kernels already have the CONFIG_RUST option enabled.
