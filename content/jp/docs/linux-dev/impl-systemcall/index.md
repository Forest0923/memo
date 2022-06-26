---
title: "システムコールの追加"
draft: false
weight: 30
---

# システムコールの追加

システムコールを追加するためのチュートリアルです．

## 環境

- Linux kernel 5.8.13
- CPU: x86_64

## チュートリアル

### システムコールの登録

`arch/x86/entry/syscalls/syscall_64.tbl` に新しいシステムコールのエントリを追加します．使われていないシステムコール番号を使って次のように `hello_syscall` を追加します．

```diff
 437	common	openat2			sys_openat2
 438	common	pidfd_getfd		sys_pidfd_getfd
 439	common	faccessat2		sys_faccessat2
+440	common	hello_syscall	sys_hello_syscall
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
```

### 新しいシステムコールの本体の追加

ここでは新たなシステムコールを `my_syscall/` ディレクトリに追加する前提で話を進めます．システムコールの本体の処理は `my_syscalls/my_syscalls.c` に `SYSCALL_DEFINEk` マクロを使用して次のように記述します．

```c
#include <linux/kernel.h>
#include <linux/syscalls.h>
#include "my_syscall.h"

SYSCALL_DEFINE0(hello_syscall)
{
    printk(KERN_INFO "hello_syscall: Hello world!\n");
    return 0;
}
```

`k` はシステムコールの引数の数に関係します．例えば引数が1つの場合は次のように記述します．

```c
SYSCALL_DEFINE1(hello_syscall, int, arg)
{
    printk(KERN_INFO "hello_syscall: arg = %d\n", arg);
    return 0;
}
```

次に `my_syscalls/my_syscalls.h` にヘッダファイルを追加します．

```c
asmlinkage long sys_hello_syscall(void);
```

`include/linux/syscalls.h` にも同様にプロトタイプ宣言を追加します．

```diff
 asmlinkage long sys_pidfd_send_signal(int pidfd, int sig,
 				       unsigned int flags);
 asmlinkage long sys_pidfd_getfd(int pidfd, int fd, unsigned int flags);
 
+/* my_syscalls/my_syscalls.c */
+asmlinkage long sys_hello_syscall(void);
+
 /*
  * Architecture-specific system calls
  */
```

### Makefile の修正

最初に次の内容の `my_syscalls/Makefile` を追加します．

```Makefile
obj-y:=my_syscalls.o
```

次に `Makefile` を修正し， `my_syscalls/` をカーネルに加えるように設定します．

```Makefile
core-y		+= kernel/ certs/ mm/ fs/ ipc/ security/ crypto/ block/ my_syscalls/
```

### コンパイルとインストール

[Install new kernel](../inst-kernel).

```sh
make -j8 && make modules_install && make install
grub-mkconfig -o /boot/grub/grub.cfg
reboot
```

### テスト

確認用のプログラム：

```c
#include <stdio.h>
#include <sys/syscall.h>

#define HELLO_SYSCALL   440

int main(int argc, char **argv)
{
    syscall(HELLO_SYSCALL);
    return 0;
}
```

ログの確認：

```text
user@host ~ $ dmesg -w
...
[  169.128284] hello_syscall: Hello world!
```
