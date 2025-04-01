---
title: 「Binary Hacks Rebooted」を読んだメモ
date: 2025-04-01
---

## MEMO

### shebang

- interpreter 以外のプログラムを指定することもできるらしい

```text
% cat test.sh
───────┬──────────────────────────────────────────
       │ File: test.sh
───────┼──────────────────────────────────────────
   1   │ #!/bin/ls -al
   2   │ echo "Hello World"
───────┴──────────────────────────────────────────

% ./test.sh
-rwxr-xr-x 1 mmori mmori 33 Mar 25 18:35 ./test.sh
```

- 引数は複数渡そうとしても無理っぽい

```text
% cat test.sh
───────┬──────────────────────────────────
       │ File: test.sh
───────┼──────────────────────────────────
   1   │ #!/bin/ls --all -l
   2   │ echo "Hello World"
───────┴──────────────────────────────────

% ./test.sh
/bin/ls: unrecognized option '--all -l'
Try '/bin/ls --help' for more information.
```

- Impl: https://elixir.bootlin.com/linux/v6.13.7/source/fs/binfmt_script.c#L34-L138

- interpreter を見つけたあとにオプションとして一つ引数を取る

```c
	/* Is there an optional argument? */
	i_arg = NULL;
	i_sep = next_terminator(i_name, i_end);
	if (i_sep && (*i_sep != '\0'))
		i_arg = next_non_spacetab(i_sep, i_end);
```

- よく `#!/bin/env python3` とかがあるけどこれのおかげで動いている

- 色々飛ばして最後は open_exec で実行

```c
	/*
	 * OK, now restart the process with the interpreter's dentry.
	 */
	file = open_exec(i_name);
	if (IS_ERR(file))
		return PTR_ERR(file);
```

### binfmt_misc

```sh
# binfmt
sudo pacman -S qemu-user-static-binfmt binfmt-wasm
# Compilers
sudo pacman -S aarch64-linux-gnu-gcc aarch64-linux-gnu-glibc
```

```
% ls /proc/sys/fs/binfmt_misc/
DOSWin           qemu-alpha  qemu-hexagon      qemu-m68k          qemu-mips      qemu-mipsel     qemu-or1k   qemu-ppc64le  qemu-s390x  qemu-sparc        qemu-xtensa    status
qemu-aarch64     qemu-arm    qemu-hppa         qemu-microblaze    qemu-mips64    qemu-mipsn32    qemu-ppc    qemu-riscv32  qemu-sh4    qemu-sparc32plus  qemu-xtensaeb  wasip1
qemu-aarch64_be  qemu-armeb  qemu-loongarch64  qemu-microblazeel  qemu-mips64el  qemu-mipsn32el  qemu-ppc64  qemu-riscv64  qemu-sh4eb  qemu-sparc64      register       wasip2

% cat /proc/sys/fs/binfmt_misc/qemu-aarch64
───────┬───────────────────────────────────────────────
       │ File: /proc/sys/fs/binfmt_misc/qemu-aarch64
───────┼───────────────────────────────────────────────
   1   │ enabled
   2   │ interpreter /usr/bin/qemu-aarch64-static
   3   │ flags: PF
   4   │ offset 0
   5   │ magic 7f454c460201010000000000000000000200b700
   6   │ mask ffffffffffffff00fffffffffffffffffeffffff
───────┴───────────────────────────────────────────────

% aarch64-linux-gnu-gcc hello.c -static -o hello-aarch64

% xxd -l 0x20 hello-aarch64
00000000: 7f45 4c46 0201 0103 0000 0000 0000 0000  .ELF............
00000010: 0200 b700 0100 0000 c006 4000 0000 0000  ..........@.....
```

- EI_OSABI が違うけど動く…
- ELF header
  - https://refspecs.linuxfoundation.org/elf/gabi4+/ch4.eheader.html
  - https://gist.github.com/x0nu11byt3/bcb35c3de461e5fb66173071a2379779

```text
% cat /proc/sys/fs/binfmt_misc/wasip1
───────┬─────────────────────────────────────────────
       │ File: /proc/sys/fs/binfmt_misc/wasip1
───────┼─────────────────────────────────────────────
   1   │ enabled
   2   │ interpreter /usr/bin/binfmt-wasmtime-wrapper
   3   │ flags:
   4   │ offset 0
   5   │ magic 0061736d01000000
───────┴─────────────────────────────────────────────

% cat /proc/sys/fs/binfmt_misc/wasip2
───────┬─────────────────────────────────────────────
       │ File: /proc/sys/fs/binfmt_misc/wasip2
───────┼─────────────────────────────────────────────
   1   │ enabled
   2   │ interpreter /usr/bin/binfmt-wasmtime-wrapper
   3   │ flags:
   4   │ offset 0
   5   │ magic 0061736d0d000100
───────┴─────────────────────────────────────────────

% rustc --target wasm32-wasip1 main.rs -o hello-wasm

% rustc --target wasm32-wasip2 main.rs -o hello-wasmp2

% xxd -l 0x20 hello-wasm
00000000: 0061 736d 0100 0000 016c 0f60 0000 6001  .asm.....l.`..`.
00000010: 7f00 6002 7f7f 017f 6001 7f01 7f60 037f  ..`.....`....`..

% xxd -l 0x20 hello-wasmp2
00000000: 0061 736d 0d00 0100 0724 0142 0401 6f02  .asm.....$.B..o.
00000010: 7373 0170 0001 4000 0001 0400 0f67 6574  ss.p..@......get
```

- cargo で aarch64 用のバイナリを作るときには .cargo/config.toml でも設定できる

```text
% cat .cargo/config.toml
───────┬─────────────────────────────────────────────────
       │ File: .cargo/config.toml
───────┼─────────────────────────────────────────────────
   1   │ [target.aarch64-unknown-linux-gnu]
   2   │ linker = "aarch64-linux-gnu-gcc"
   3   │ rustflags = ["-C", "target-feature=+crt-static"]
───────┴─────────────────────────────────────────────────
```

### CRIU

- /proc/sys/kernel/ns_last_pid は CRIU の開発者が追加したらしい
- criu-ns を使うと PID の namespace を分けて重複を避けることができる

### Unikernel

- Unikraft: https://github.com/unikraft/unikraft
- CLI tool: https://github.com/unikraft/kraftkit
- Tutorials: https://unikraft.org/docs/cli

```sh
# ディストリビューションごとの package manager を使ってくれる
curl -sSfL https://get.kraftkit.sh | sh
cd workspace

# Create Kraftfile
cat << EOF | tee Kraftfile
spec: v0.6

name: template

unikraft: stable

targets:
- qemu/x86_64
EOF

# Config
kraft menu

# Create Makefile
cat << EOF | tee Makefile
$(eval $(call addlib,apphelloworld))

APPHELLOWORLD_SRCS-y += $(APPHELLOWORLD_BASE)/main.c
EOF

# main.c
cat << EOF | tee main.c
#include <stdio.h>
#include <unistd.h>

int main(void) {
	printf("Hello, Kernel World!\n");
	for (;;) {}
	printf("Can't reach here\n");

	return 0;
}
EOF

# Build
kraft build

# Run
kraft run
```

```text
% kraft build
[+] updating index... done!                                                                                                                                             [6.3s]
[?] project already configured, are you sure you want to rerun the configure step: [Y/n]
[+] configuring template (qemu/x86_64) ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••• 100% [1.3s]
[+] building template (qemu/x86_64)    ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••• 100% [3.7s]

[●] Build completed successfully!
 │
 └─ kernel: .unikraft/build/template_qemu-x86_64 (242 kB)

Learn how to package your unikernel with: kraft pkg --help
kraft build  4.37s user 2.42s system 49% cpu 13.588 total

% kraft run
 i  using arch=x86_64 plat=qemu
o.   .o       _ _               __ _
Oo   Oo  ___ (_) | __ __  __ _ ' _) :_
oO   oO ' _ `| | |/ /  _)' _` | |_|  _)
oOo oOO| | | | |   (| | | (_) |  _) :_
 OoOoO ._, ._:_:_,\_._,  .__,_:_, \___)
                          Helene 0.18.0
Hello, Kernel World!

```

```text
% ps ax | grep qemu
2896210 ?        Sl     0:14 qemu-system-x86_64 -cpu host,+x2apic,-pmu -daemonize -device pvpanic -display none -enable-kvm -kernel $WORKDIR/.unikraft/build/template_qemu-x86_64 -machine pc,accel=kvm -m size=64M -monitor unix:$HOME/.local/share/kraftkit/runtime/0d3aa028c089/mon.sock,server,nowait -name 0d3aa028c089 -nographic -no-reboot -S -parallel none -pidfile $HOME/.local/share/kraftkit/runtime/0d3aa028c089/machine.pid -qmp unix:$HOME/.local/share/kraftkit/runtime/0d3aa028c089/ctrl.sock,server,nowait -qmp unix:$HOME/.local/share/kraftkit/runtime/0d3aa028c089/evnt.sock,server,nowait -rtc base=utc -serial file:$HOME/.local/share/kraftkit/runtime/0d3aa028c089/vm.log -smp cpus=1,threads=1,sockets=1 -vga none
```

sleep 関数を呼ぼうとしたら build でこけた。今回はテストなので一旦無視する

```text
% kraft build
[+] updating index... done!                                                                                                                                             [6.3s]
[?] project already configured, are you sure you want to rerun the configure step: [Y/n]
[+] configuring template (qemu/x86_64) ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••• 100% [1.2s]
<!> building template (qemu/x86_64)    ••                                                                                                                            2% [4.1s]
 W  make: hostname: No such file or directory
 i    LN      Makefile
 W  make[1]: hostname: No such file or directory
 W  which: no time in ($HOME/.cargo/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/var/lib/flatpak/exports/bin:/usr/lib/jvm/default/bin:/usr/bin/site_perl:/usr/bin/vendor
 i    CP      config
 i    GEN     libuklibid: libraries.in.new
 W  make: hostname: No such file or directory
 W  make[1]: hostname: No such file or directory
 W  which: no time in ($HOME/.cargo/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/var/lib/flatpak/exports/bin:/usr/lib/jvm/default/bin:/usr/bin/site_perl:/usr/bin/vendor
 W  make: hostname: No such file or directory
 i    LN      Makefile
 W  make[1]: hostname: No such file or directory
 W  which: no time in ($HOME/.cargo/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/var/lib/flatpak/exports/bin:/usr/lib/jvm/default/bin:/usr/bin/site_perl:/usr/bin/vendor
 i    CP      config
 i    GEN     libuklibid: libraries.in.new
 i    CP      libuklibid: libraries.in
 W  $WORKDIR/main.c: In function ‘main’:
 W  $WORKDIR/main.c:6:9: error: implicit declaration of function ‘sleep’ [-Wimplicit-function-declaration]
 W      6 |         sleep(10);
 W        |         ^~~~~
 W  make[1]: *** [$WORKDIR/.unikraft/unikraft/support/build/Makefile.build:27: $HOME/workspace/binary_hacks_rebooted/uniker
 i    CC      apphelloworld: main.o
 W  make: *** [Makefile:1175: sub-make] Error 2

 E  could not complete build: build failed: exit status 2
kraft build  4.75s user 2.70s system 36% cpu 20.281 total
```

### bpftrace

https://github.com/bpftrace/bpftrace

```text
% sudo bpftrace tools/bashreadline.bt
Attaching 3 probes...
Tracing bash commands... Hit Ctrl-C to end.
TIME      PID    COMMAND
09:41:34  3091887 ls
09:41:42  3091887 echo hello
09:41:48  3091887 df -h
^C
```

```text
% sudo bpftrace tools/cpuwalk.bt
Attaching 2 probes...
Sampling CPU at 99hz... Hit Ctrl-C to end.
^C

@cpu:
[0, 1)                17 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                    |
[1, 2)                18 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                  |
[2, 3)                22 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@          |
[3, 4)                19 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                |
[4, 5)                 7 |@@@@@@@@@@@@@                                       |
[5, 6)                 5 |@@@@@@@@@                                           |
[6, 7)                18 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                  |
[7, 8)                15 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@                        |
[8, 9)                 1 |@                                                   |
[9, 10)                9 |@@@@@@@@@@@@@@@@@                                   |
[10, 11)              14 |@@@@@@@@@@@@@@@@@@@@@@@@@@                          |
[11, 12)              20 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@              |
[12, 13)              12 |@@@@@@@@@@@@@@@@@@@@@@@                             |
[13, 14)              17 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                    |
[14, 15)              15 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@                        |
[15, 16)              27 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|
```

- https://github.com/aya-rs/aya
- https://github.com/libbpf/libbpf-rs

### Meltdown/Spectre

https://github.com/kianenigma/meltdown-spectre/blob/master/meltdown-spectre/main-meltdown.c

### 数値表現

https://gigazine.net/news/20250217-android-calclator-app/