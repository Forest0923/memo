---
title: "Implementing Original Systemcalls"
draft: false
weight: 30
---
This is a tutorial of implementing new systemcalls.

## System Setup

- Linux kernel 5.8.13
- CPU: x86_64

## Step-by-step instructions

### Register New Systemcall

Add a new entry in the `arch/x86/entry/syscalls/syscall_64.tbl`. You can use empty systemcall number and register `hello_syscall` as follows.

```diff
 437	common	openat2			sys_openat2
 438	common	pidfd_getfd		sys_pidfd_getfd
 439	common	faccessat2		sys_faccessat2
+440	common	hello_syscall	sys_hello_syscall
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
```

## Implementing Body of New Systemcall

In this article, I wrote a new systemcall in the `my_syscall/` directory. The body of `hello_syscall` is written in the `my_syscalls/my_syscalls.c` using `SYSCALL_DEFINEk` macro as follows. `k` indicates thw number of arguments.

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

If the systemcall has some arguments, it could be written as follows.

```c
SYSCALL_DEFINE1(hello_syscall, int, arg)
{
    printk(KERN_INFO "hello_syscall: arg = %d\n", arg);
    return 0;
}
```

Then create header files (`my_syscalls/my_syscalls.h`) and modify `include/linux/syscalls.h`.

```c
asmlinkage long sys_hello_syscall(void);
```

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

### Modifying Makefile

First, create `my_syscalls/Makefile` like this.

```Makefile
obj-y:=my_syscalls.o
```

Second, modify `Makefile` to add `my_syscalls/` directory to kernel.

```Makefile
core-y		+= kernel/ certs/ mm/ fs/ ipc/ security/ crypto/ block/ my_syscalls/
```

### Compile and Install

[Install new kernel](../inst-kernel).

```sh
make -j8 && make modules_install && make install
grub-mkconfig -o /boot/grub/grub.cfg
reboot
```

### Test

Test program:

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

Result:

```text
user@host ~ $ dmesg -w
...
[  169.128284] hello_syscall: Hello world!
```
