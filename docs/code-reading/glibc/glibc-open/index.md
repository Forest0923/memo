+++
title = "glibc open"
description = "glibc の open の挙動を調査したときのメモ"
tags = [
  "glibc", "File I/O"
]
draft = false
+++

## Version

- glibc v2.35

## Example Code

```c
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>

int main() {
	int fd = open("/path/to/test.txt", O_RDONLY);
	char str[10];
	read(fd, str, 10);
	printf("%s\n", str);
	return 0;
}
```

## Definition

- File: sysdeps/unix/sysv/linux/open64.c

```c
/* Open FILE with access OFLAG.  If O_CREAT or O_TMPFILE is in OFLAG,
   a third argument is the file protection.  */
int
__libc_open64 (const char *file, int oflag, ...)
{
  int mode = 0;

  if (__OPEN_NEEDS_MODE (oflag))
    {
      va_list arg;
      va_start (arg, oflag);
      mode = va_arg (arg, int);
      va_end (arg);
    }

  return SYSCALL_CANCEL (openat, AT_FDCWD, file, oflag | O_LARGEFILE,
			 mode);
}

strong_alias (__libc_open64, __open64)
libc_hidden_weak (__open64)
weak_alias (__libc_open64, open64)
```

- File: sysdeps/unix/sysdep.h

```c
#if IS_IN (rtld)
/* All cancellation points are compiled out in the dynamic loader.  */
# define NO_SYSCALL_CANCEL_CHECKING 1
#else
# define NO_SYSCALL_CANCEL_CHECKING SINGLE_THREAD_P
#endif

#define SYSCALL_CANCEL(...) \
  ({									     \
    long int sc_ret;							     \
    if (NO_SYSCALL_CANCEL_CHECKING)					     \
      sc_ret = INLINE_SYSCALL_CALL (__VA_ARGS__); 			     \
    else								     \
      {									     \
	int sc_cancel_oldtype = LIBC_CANCEL_ASYNC ();			     \
	sc_ret = INLINE_SYSCALL_CALL (__VA_ARGS__);			     \
        LIBC_CANCEL_RESET (sc_cancel_oldtype);				     \
      }									     \
    sc_ret;								     \
  })
```

## 補足

open 関連のファイルを探すときに io/open* 系のファイルと sysdeps/unix/sysv/linux/open* 系の２つの系統があった．

```text
$ find glibc -name "open*"
./catgets/open_catalog.c
./dirent/opendir-tst1.c
./dirent/opendir.c
./hurd/openport.c
./io/open.c
./io/open64.c
./io/open64_2.c
./io/open_2.c
./io/openat.c
./io/openat64.c
./io/openat64_2.c
./io/openat_2.c
./login/openpty.c
./socket/opensock.c
./sunrpc/openchild.c
./sysdeps/mach/hurd/open.c
./sysdeps/mach/hurd/open64.c
./sysdeps/mach/hurd/open_nocancel.c
./sysdeps/mach/hurd/openat.c
./sysdeps/mach/hurd/openat64.c
./sysdeps/mach/hurd/openat_nocancel.c
./sysdeps/mach/hurd/opendir.c
./sysdeps/posix/open64.c
./sysdeps/unix/sysv/linux/open.c
./sysdeps/unix/sysv/linux/open64.c
./sysdeps/unix/sysv/linux/open64_nocancel.c
./sysdeps/unix/sysv/linux/open_by_handle_at.c
./sysdeps/unix/sysv/linux/open_nocancel.c
./sysdeps/unix/sysv/linux/openat.c
./sysdeps/unix/sysv/linux/openat64.c
./sysdeps/unix/sysv/linux/openat64_nocancel.c
./sysdeps/unix/sysv/linux/openat_nocancel.c
./sysdeps/unix/sysv/linux/opendir.c
```

io/open64.c を見ると __libc_open64 の定義は以下のようになっておりちょっと様子が違う．return も -1 となっておりこっちは呼ばれてなさそう...？

OS ごとにシステムコールが異なることを考えると，sysdeps/ （system dependent?）以下のものが実際には呼ばれていそうなのでおそらくそっちが正しい．

```c
/* Open FILE with access OFLAG.  If O_CREAT or O_TMPFILE is in OFLAG,
   a third argument is the file protection.  */
int
__libc_open64 (const char *file, int oflag)
{
  int mode;

  if (file == NULL)
    {
      __set_errno (EINVAL);
      return -1;
    }

  if (__OPEN_NEEDS_MODE (oflag))
    {
      va_list arg;
      va_start (arg, oflag);
      mode = va_arg (arg, int);
      va_end (arg);
    }

  __set_errno (ENOSYS);
  return -1;
}
strong_alias (__libc_open64, __open64)
libc_hidden_def (__open64)
weak_alias (__libc_open64, open64)
```
