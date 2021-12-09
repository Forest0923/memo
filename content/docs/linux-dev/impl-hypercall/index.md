---
title: "Implementing Original Hypercalls"
draft: false
weight: 40
---

# Implementing Original Hypercalls

## System

- Linux kernel 5.8.x

## Host

```diff
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ba7e98a3a..9f41689b4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7696,6 +7696,30 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 		kvm_sched_yield(vcpu->kvm, a0);
 		ret = 0;
 		break;
+	case KVM_HC_HELLO_HYPERCALL0:
+		trace_printk("Hello world!\n");
+		break;
+	case KVM_HC_HELLO_HYPERCALL1:
+		trace_printk("a0 = %d\n", a0);
+		break;
 	default:
 		ret = -KVM_ENOSYS;
 		break;
diff --git a/include/uapi/linux/kvm_para.h b/include/uapi/linux/kvm_para.h
index 8b8660984..bceb8d1be 100644
--- a/include/uapi/linux/kvm_para.h
+++ b/include/uapi/linux/kvm_para.h
@@ -29,6 +29,7 @@
 #define KVM_HC_CLOCK_PAIRING		9
 #define KVM_HC_SEND_IPI		10
 #define KVM_HC_SCHED_YIELD		11
+#define KVM_HC_HELLO_HYPERCALL0	12
+#define KVM_HC_HELLO_HYPERCALL1	13
 
 /*
  * hypercalls use architecture specific
```

## Guest

```diff
diff --git a/Makefile b/Makefile
index 58283e912b4e..2f6191b70d84 100644
--- a/Makefile
+++ b/Makefile
@@ -1066,7 +1066,7 @@ export MODORDER := $(extmod-prefix)modules.order
 export MODULES_NSDEPS := $(extmod-prefix)modules.nsdeps

 ifeq ($(KBUILD_EXTMOD),)
-core-y         += kernel/ certs/ mm/ fs/ ipc/ security/ crypto/ block/
+core-y         += kernel/ certs/ mm/ fs/ ipc/ security/ crypto/ block/ my_syscalls/

 vmlinux-dirs   := $(patsubst %/,%,$(filter %/, \
                     $(core-y) $(core-m) $(drivers-y) $(drivers-m) \
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index 78847b32e137..e8ce133372d2 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -360,6 +360,8 @@
 437    common  openat2                 sys_openat2
 438    common  pidfd_getfd             sys_pidfd_getfd
 439    common  faccessat2              sys_faccessat2
+440    common  hello_hypercall0        sys_hello_hypercall0
+441    common  hello_hypercall1        sys_hello_hypercall1

 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index b951a87da987..65f480aed5ac 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -1424,4 +1424,8 @@ long compat_ksys_semtimedop(int semid, struct sembuf __user *tsems,
                            unsigned int nsops,
                            const struct old_timespec32 __user *timeout);

+/* my_syscalls/my_syscalls.c */
+asmlinkage long sys_hello_hypercall0(void);
+asmlinkage long sys_hello_hypercall1(int arg1);
+
 #endif
diff --git a/include/uapi/linux/kvm_para.h b/include/uapi/linux/kvm_para.h
index 8b86609849b9..614cc87f38ec 100644
--- a/include/uapi/linux/kvm_para.h
+++ b/include/uapi/linux/kvm_para.h
@@ -29,6 +29,8 @@
 #define KVM_HC_CLOCK_PAIRING           9
 #define KVM_HC_SEND_IPI                10
 #define KVM_HC_SCHED_YIELD             11
+#define KVM_HC_HELLO_HYPERCALL0        12
+#define KVM_HC_HELLO_HYPERCALL1        13

 /*
  * hypercalls use architecture specific
diff --git a/my_syscalls/Makefile b/my_syscalls/Makefile
new file mode 100644
index 000000000000..e7e211791186
--- /dev/null
+++ b/my_syscalls/Makefile
@@ -0,0 +1 @@
+obj-y:=my_syscalls.o
diff --git a/my_syscalls/my_syscalls.c b/my_syscalls/my_syscalls.c
new file mode 100644
index 000000000000..0989c604cbd4
--- /dev/null
+++ b/my_syscalls/my_syscalls.c
@@ -0,0 +1,15 @@
+#include <linux/kernel.h>
+#include <linux/syscalls.h>
+#include <uapi/linux/kvm_para.h>
+#include "my_syscalls.h"
+
+SYSCALL_DEFINE0(hello_hypercall0)
+{
+    kvm_hypercall0(KVM_HC_HELLO_HYPERCALL0);
+    return 0;
+}
+
+SYSCALL_DEFINE1(hello_hypercall1, int, arg1)
+{
+    kvm_hypercall1(KVM_HC_HELLO_HYPERCALL1, arg1);
+    return 0;
+}
diff --git a/my_syscalls/my_syscalls.h b/my_syscalls/my_syscalls.h
new file mode 100644
index 000000000000..04bf6fbd4efb
--- /dev/null
+++ b/my_syscalls/my_syscalls.h
@@ -0,0 +1,2 @@
+asmlinkage long hello_hypercall0(void);
+asmlinkage long hello_hypercall1(int arg1);
```

## Test

- Test code (on guest):

```c
#include <stdio.h>
#include <sys/syscall.h>

#define HELLO_HYPERCALL0    440
#define HELLO_HYPERCALL1    441

int main(int argc, char **argv)
{
    syscall(440);
    syscall(441, 123);
    return 0;
}
```

- Log (on host):

```text
user@host ~ % sudo cat /sys/kernel/tracing/trace
# tracer: nop
#
# entries-in-buffer/entries-written: 2/2   #P:6
#
#                              _-----=> irqs-off
#                             / _----=> need-resched
#                            | / _---=> hardirq/softirq
#                            || / _--=> preempt-depth
#                            ||| /     delay
#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |
       CPU 1/KVM-1748  [000] ....   457.868063: kvm_emulate_hypercall: Hello world!
       CPU 1/KVM-1748  [000] ....   457.868066: kvm_emulate_hypercall: a0 = 123
```
