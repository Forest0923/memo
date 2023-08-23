---
title: "Loadable Kernel Module"
draft: false
weight: 999
---
## About

このページでは Linux 上での Loadable Kernel Module の実装について説明します．

そもそも LKM はカーネルのコアではなく，insmod や rmmod によってあとから追加・削除できるモジュールを指します．

Linux カーネルにシステムコールを追加する場合などはカーネルのビルドをやり直す必要がありますが，LKM ではそれが不要なので実験や簡単な確認などを行う場合には効率よく作業ができます．

以下では LKM の作り方について Linux v5.17.0 を対象に説明していきます．

## Examples

下記のサンプルモジュールの実装例を紹介していきます．

- hello.ko: insmod, rmmod 時にログを出力するだけの LKM
- mulfile.ko: 複数のファイルに分割された LKM
- getargs.ko: insmod 時に引数を渡す LKM

### hello.ko

モジュールの中身を記述する hello.c とビルドするための Makefile を作成します．

```text
.
├── hello.c
└── Makefile
```

hello.c は下記のような内容です．

`module_init([func]);` で指定した関数が insmod 時に実行され，`module_exit([func]);` で指定した関数が rmmod 時に実行されます．

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

Makefile は下記のように作成しました．

```makefile
KDIR            := /lib/modules/`uname -r`/build
MODNAME         := hello
obj-m           := $(MODNAME).o

all:
        make -C $(KDIR) M=`pwd` modules

clean:
        make -C $(KDIR) M=`pwd` clean
```

`make (all)` を実行するとビルドされます．

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

`make clean` で生成されたオブジェクトファイルなどを削除します．

```text
SSHmori@arch hello % make clean
make -C /lib/modules/`uname -r`/build M=`pwd` clean
make[1]: Entering directory '/usr/src/linux-5.17'
  CLEAN   /home/mori/build/hello/Module.symvers
make[1]: Leaving directory '/usr/src/linux-5.17'
```

insmod でモジュールをインストールして，dmesg でログを確認すると下記のようにログを確認できました．

```text
SSHmori@arch hello % sudo insmod hello.ko
[sudo] password for mori:
SSHmori@arch hello % sudo dmesg | grep hello
[ 2000.349162] hello: loading out-of-tree module taints kernel.
[ 2000.349265] hello: module verification failed: signature and/or required key missing - tainting kernel
[ 2000.350086] hello: init
```

rmmod の場合も同様に確認できました．

```text
SSHmori@arch hello % sudo rmmod hello
SSHmori@arch hello % sudo dmesg | grep hello
[ 2000.349162] hello: loading out-of-tree module taints kernel.
[ 2000.349265] hello: module verification failed: signature and/or required key missing - tainting kernel
[ 2000.350086] hello: init
[ 2024.857552] hello: exit
```

### mulfile.ko

モジュールをわかりやすくするために複数のファイルに分割したい場合があると思います．ここでは下記のようにファイルを分割しています．

```text
.
├── init.c    <-- init
├── exit.c    <-- exit
├── print.c   <-- printk
└── Makefile
```

それぞれの C ファイルは次のようになっています．

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

Makefile は次のように作成します．

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

insmod, rmmod を実行したあとにログを確認すると呼び出せていることがわかります．

```text
SSHmori@arch build % sudo dmesg | grep -e my_mod -e mymod
[ 6832.006826] my_module: init
[ 6832.006831] mymodule_sub: called
[ 6869.413859] my_module: exit
```

### getargs.ko

カーネルモジュールに対してロード時に次のようにパラメータを渡すことができます．

```sh
sudo insmod mod.ko [param]=[value]
```

パラメータは LKM のコード内で `module_param()` などを用いて定義します．

- `module_param([name], [type], [perm])`

\[type\] には byte, short, ushort, int, uint, long, ulong, charp, bool, invbool が使用できます．

\[perm\] には sysfs での権限を設定します．例えば `0644` のように指定すると，/sys/module/getargs/parameters の中にパラメータのファイルが作成され，権限が 644 で作成されます．`0` と指定すればファイルは作成されず，直接 sysfs にアクセスして値を変えられなくなります．

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

パラメータの定義には他にも `module_param_named()`，`module_param_string()`，`module_param_array()` などがあります．

- `module_param_named([parm name], [var name], [type], [perm])`
- `module_param_string([param name], [var name], [length], [perm])`
- `module_param_array([name], [type], [arr ptr], [perm])`

例として様々なパラメータを設定して init の際に出力する LKM を下記のように作成しました．

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

次のようにモジュールをインストールして，引数が取得できていることを確認できました．

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
