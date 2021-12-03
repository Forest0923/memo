---
title: "Implementing Original Systemcall"
description: ""
lead: ""
date: 2021-11-29T12:35:41+09:00
lastmod: 2021-11-29T12:35:41+09:00
draft: false
images: []
menu: 
  docs:
    parent: "linux-dev"
weight: 30
toc: true
---

## System

- Linux kernel 5.8.x

## diff

```diff
diff --git a/Makefile b/Makefile
index a3b3cc4d7ee2..0e202ce51444 100644
--- a/Makefile
+++ b/Makefile
@@ -1070,7 +1070,7 @@ export MODORDER := $(extmod-prefix)modules.order
 export MODULES_NSDEPS := $(extmod-prefix)modules.nsdeps
 
 ifeq ($(KBUILD_EXTMOD),)
-core-y		+= kernel/ certs/ mm/ fs/ ipc/ security/ crypto/ block/
+core-y		+= kernel/ certs/ mm/ fs/ ipc/ security/ crypto/ block/ my_syscall/
 
 vmlinux-dirs	:= $(patsubst %/,%,$(filter %/, \
 		     $(core-y) $(core-m) $(drivers-y) $(drivers-m) \
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index 78847b32e137..2d2121edef82 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -360,6 +360,7 @@
 437	common	openat2			sys_openat2
 438	common	pidfd_getfd		sys_pidfd_getfd
 439	common	faccessat2		sys_faccessat2
+440 common  hello_syscall   sys_hello_syscall
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index b951a87da987..20366a8d5b32 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -1006,6 +1006,9 @@ asmlinkage long sys_pidfd_send_signal(int pidfd, int sig,
 				       unsigned int flags);
 asmlinkage long sys_pidfd_getfd(int pidfd, int fd, unsigned int flags);
 
+/* my_syscall/my_syscall.c */
+asmlinkage long sys_hello_syscall(void);
+
 /*
  * Architecture-specific system calls
  */
diff --git a/my_syscall/Makefile b/my_syscall/Makefile
new file mode 100644
index 000000000000..f8170cd4d5e7
--- /dev/null
+++ b/my_syscall/Makefile
@@ -0,0 +1 @@
+obj-y:=my_syscall.o
diff --git a/my_syscall/my_syscall.c b/my_syscall/my_syscall.c
new file mode 100644
index 000000000000..5af73922f412
--- /dev/null
+++ b/my_syscall/my_syscall.c
@@ -0,0 +1,9 @@
+#include <linux/kernel.h>
+#include <linux/syscalls.h>
+#include "my_syscall.h"
+
+SYSCALL_DEFINE0(hello_syscall)
+{
+    printk("hello_syscall: Hello world!\n");
+    return 0;
+}
diff --git a/my_syscall/my_syscall.h b/my_syscall/my_syscall.h
new file mode 100644
index 000000000000..1ead3f6f4d94
--- /dev/null
+++ b/my_syscall/my_syscall.h
@@ -0,0 +1 @@
+asmlinkage long sys_hello_syscall(void);
```

## Test

- Test program:

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

- Result:

```text
user@host ~ $ dmesg -w
...
[  169.128284] hello_syscall: Hello world!
```
