---
title: "Loadable Kernel Module"
draft: false
weight: 999
---

# Loadable Kernel Module

## About

This page describes the implementation of the Loadable Kernel Module on Linux.

LKM is not a kernel core. It is a  module that can be added or removed by insmod or rmmod.

Adding system calls to the Linux kernel requires rebuilding the kernel, but LKM does not.

The following explains how to create an LKM for Linux v5.17.0.

## Examples

The following sample modules are examples of LKM.

- hello.ko: LKM that only outputs logs when executed insmod and rmmod
- mulfile.ko: LKM consisting of multiple files
- getargs.ko: LKM that passes arguments when calling insmod

### hello.ko

Create hello.c for the body of the module and a Makefile to build it.

```text
.
├── hello.c
└── Makefile
```

hello.c is as follows.

The function specified by `module_init([func]);` is executed on insmod, and the function specified by `module_exit([func]);` is executed on rmmod.

```c
#include <linux/module.h>

MODULE_DESCRIPTION("hello module");
MODULE_AUTHOR("Mori");
MODULE_LICENSE("GPL");

static int hello_init(void)
{
        pr_info("hello: init\n");
        return 0;
}

static void hello_exit(void)
{
        pr_info("hello: exit\n");
        return;
}

module_init(hello_init);
module_exit(hello_exit);
```

The Makefile was created as follows.

```makefile
KDIR            := /lib/modules/`uname -r`/build
MODNAME         := hello
obj-m           := $(MODNAME).o

all:
        make -C $(KDIR) M=`pwd` modules

clean:
        make -C $(KDIR) M=`pwd` clean
```

Run `make (all)` to build hello module.

```text
SSHmori@arch hello % make
make -C /lib/modules/`uname -r`/build M=`pwd` modules
make[1]: Entering directory '/usr/src/linux-5.17'
  CC [M]  /home/mori/build/hello/hello.o
  MODPOST /home/mori/build/hello/Module.symvers
  CC [M]  /home/mori/build/hello/hello.mod.o
  LD [M]  /home/mori/build/hello/hello.ko
  BTF [M] /home/mori/build/hello/hello.ko
make[1]: Leaving directory '/usr/src/linux-5.17'
SSHmori@arch hello % tree
.
├── hello.c
├── hello.ko
├── hello.mod
├── hello.mod.c
├── hello.mod.o
├── hello.o
├── Makefile
├── modules.order
└── Module.symvers

0 directories, 9 files
```

Run `make clean` to cleanup directory.

```text
SSHmori@arch hello % make clean
make -C /lib/modules/`uname -r`/build M=`pwd` clean
make[1]: Entering directory '/usr/src/linux-5.17'
  CLEAN   /home/mori/build/hello/Module.symvers
make[1]: Leaving directory '/usr/src/linux-5.17'
```

I installed the module with insmod and checked the logs with dmesg as shown below.

```text
SSHmori@arch hello % sudo insmod hello.ko
[sudo] password for mori:
SSHmori@arch hello % sudo dmesg | grep hello
[ 2000.349162] hello: loading out-of-tree module taints kernel.
[ 2000.349265] hello: module verification failed: signature and/or required key missing - tainting kernel
[ 2000.350086] hello: init
```

The following is the output when running rmmod.

```text
SSHmori@arch hello % sudo rmmod hello
SSHmori@arch hello % sudo dmesg | grep hello
[ 2000.349162] hello: loading out-of-tree module taints kernel.
[ 2000.349265] hello: module verification failed: signature and/or required key missing - tainting kernel
[ 2000.350086] hello: init
[ 2024.857552] hello: exit
```

### mulfile.ko

Sometimes you may want to split a module into multiple files to make it easier to understand.

In this example, the files are divided as follows.

```text
.
├── init.c    <-- init
├── exit.c    <-- exit
├── print.c   <-- printk
└── Makefile
```

All C files is as follows.

- init.c

```c
#include <linux/kernel.h>
#include <linux/module.h>

MODULE_DESCRIPTION("My Module");
MODULE_AUTHOR("Mori");
MODULE_LICENSE("GPL");

void mymodule_sub(void);

static int mymod_init(void)
{
        pr_info("my_module: init\n");
        mymodule_sub();
        return 0;
}

module_init(mymod_init);
```

- exit.c

```c
#include <linux/kernel.h>
#include <linux/module.h>

static void mymod_exit(void)
{
        pr_info("my_module: exit\n");
}

module_exit(mymod_exit);
```

- print.c

```c
#include <linux/kernel.h>
#include <linux/module.h>

void mymodule_sub(void) {
        pr_info("mymodule_sub: called\n");
}
```

I created Makefile like below.

```makefile
KDIR            := /lib/modules/`uname -r`/build
MODNAME         := mymodule

obj-m           := $(MODNAME).o
$(MODNAME)-objs := init.o exit.o print.o

all:
        make -C $(KDIR) M=`pwd` modules

clean:
        make -C $(KDIR) M=`pwd` clean
```

After running insmod and rmmod, I looked at the log and found that the it was successful.

```text
SSHmori@arch build % sudo dmesg | grep -e my_mod -e mymod
[ 6832.006826] my_module: init
[ 6832.006831] mymodule_sub: called
[ 6869.413859] my_module: exit
```

### getargs.ko

You can pass parameters to the kernel module at load time.

```sh
sudo insmod mod.ko [param]=[value]
```

Parameters are defined in LKM code using `module_param()` and so on.

- `module_param([name], [type], [perm])`

"type" can be byte, short, ushort, int, uint, long, ulong, charp, bool, or invbool.

perm is set to the permissions in sysfs. For example, `0644` will create a parameter file in /sys/module/getargs/parameters with permission 644. If you specify `0`, no file will be created and user will not be able to access sysfs directly to change values.

```text
$ sudo insmod getargs.ko
$ ll /sys/module/getargs/parameters
total 0
drwxr-xr-x 2 root root    0 Jul 10 13:09 ./
drwxr-xr-x 6 root root    0 Jul 10 13:08 ../
-rw-r--r-- 1 root root 4.0K Jul 10 13:09 intparam
$ cat /sys/module/getargs/parameters/intparam
0
```

Parameters can also be defined by `module_param_named()`, `module_param_string()`, or `module_param_array()` .

- `module_param_named([parm name], [var name], [type], [perm])`
- `module_param_string([param name], [var name], [length], [perm])`
- `module_param_array([name], [type], [arr ptr], [perm])`

I will show you an example of LKM that is output various parameters during initialization.

```c
#include <linux/module.h>

#define BUF_SIZE        8
#define FILE_PATH_MAX   128

MODULE_DESCRIPTION("getargs module");
MODULE_AUTHOR("Mori");
MODULE_LICENSE("GPL");

static int intparam, intparam2;
static char *file, file2[FILE_PATH_MAX];
static int array[BUF_SIZE], nr_arr;

module_param(intparam, int, 0);
module_param(file, charp, 0);
module_param_named(arg, intparam2, int, 0);
module_param_string(filepath, file2, 128, 0);
module_param_array(array, int, &nr_arr, 0);

static int getargs_init(void)
{
        int i;
        pr_info("getargs: init\n");
        pr_info("getargs: => intparam\t= %d\n", intparam);
        pr_info("getargs: => intparam2\t= %d\n", intparam2);
        if (file)
                pr_info("getargs: => file\t= %s\n", file);
        pr_info("getargs: => file2\t= %s\n", file2);

        pr_info("getargs: => array\t= [");
        for (i = 0; i < BUF_SIZE; i++)
                pr_cont(" %d", array[i]);
        pr_cont("]\n");

        return 0;
}

static void getargs_exit(void)
{
        return;
}

module_init(getargs_init);
module_exit(getargs_exit);
```

The module is installed as follows, and we have confirmed that the arguments have been obtained.

```sh
sudo insmod getargs.ko
sudo rmmod getargs
sudo insmod getargs.ko intparam=123 arg=456 file=`pwd`/getargs.c filepath=`pwd`/getargs.ko
sudo rmmod getargs
sudo insmod getargs.ko array=12,23,34,45,56
sudo rmmod getargs
```

```text
[14218.501390] getargs: init
[14218.501392] getargs: => intparam     = 0
[14218.501393] getargs: => intparam2    = 0
[14218.501394] getargs: => file2        =
[14218.501394] getargs: => array        = [ 0 0 0 0 0 0 0 0]
[14457.464244] getargs: init
[14457.464246] getargs: => intparam     = 123
[14457.464247] getargs: => intparam2    = 456
[14457.464248] getargs: => file = /home/mori/build/hello/getargs.c
[14457.464249] getargs: => file2        = /home/mori/build/hello/getargs.ko
[14457.464250] getargs: => array        = [ 0 0 0 0 0 0 0 0]
[14585.508189] getargs: init
[14585.508191] getargs: => intparam     = 0
[14585.508192] getargs: => intparam2    = 0
[14585.508193] getargs: => file2        =
[14585.508194] getargs: => array        = [ 12 23 34 45 56 0 0 0]
```
