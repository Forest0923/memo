---
title: "Debugging with gdb"
draft: false
weight: 999
---

# Debugging with gdb

In this page, I will describe how to debug programs with gdb.

## Preparations

Here we will debug the following code (hello.c) with gdb.

```c
#include <stdio.h>

int main() {
	printf("hello\n");
}
```

Compile with the -g option to include debugging information when compiling.

```sh
gcc hello.c -g
```

## Start

Starts gdb with the executable file as an argument.

```sh
gdb a.out
```

```text
% gdb a.out
GNU gdb (GDB) 12.1
Copyright (C) 2022 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
Type "show copying" and "show warranty" for details.
This GDB was configured as "x86_64-pc-linux-gnu".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<https://www.gnu.org/software/gdb/bugs/>.
Find the GDB manual and other documentation resources online at:
    <http://www.gnu.org/software/gdb/documentation/>.

For help, type "help".
Type "apropos word" to search for commands related to "word"...
Reading symbols from a.out...
(gdb)
```

At this time, the program has not yet been started. You can set arguments and environment variables at this point.

## Arguments

If arguments are required, they can be added using `set args` as shown below.

```text
(gdb) set args [arg0] [arg1] ...
```

## Environment Variables (LD_PRELOAD)

Use `set environment` to set environment variables.

```text
(gdb) set envirnment LD_PRELOAD ./hook.so
```

In this example, the following file hook.c is compiled and specified as LD_PRELOAD to hook main().

```c
/*
 * gcc hook.c -o hook.so -fPIC -shared -ldl
 */
#define _GNU_SOURCE
#include <stdio.h>
#include <dlfcn.h>
#include <unistd.h>

static int (*main_orig)(int, char **, char **);

int main_hook(int argc, char **argv, char **envp)
{
	printf("---Before main()---\n");
	int ret = main_orig(argc, argv, envp);
	printf("---After main()----\n");
	return ret;
}

int __libc_start_main(
		int (*main)(int, char **, char **),
		int argc,
		char **argv,
		int (*init)(int, char **, char **),
		void (*fini)(void),
		void (*rtld_fini)(void),
		void *stack_end)
{
	main_orig = main;
	typeof(&__libc_start_main) orig = dlsym(RTLD_NEXT, "__libc_start_main");
	return orig(main_hook, argc, argv, init, fini, rtld_fini, stack_end);
}
```

## Exec

Use `run` or `start` to start the program. `run` will run to the point where the breakpoint is set.

```text
(gdb) run
```

```text
(gdb) run
Starting program: /home/mori/exp/a.out
---Before main()---
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/usr/lib/libthread_db.so.1".
---Before main()---
hello
---After main()----
[Inferior 1 (process 18048) exited normally]
```

If start is executed, it will stop at the first step of main().

```text
(gdb) start
```

```text
(gdb) start
Temporary breakpoint 1 at 0x55555555513d: file hello.c, line 4.
Starting program: /home/mori/exp/a.out
---Before main()---
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/usr/lib/libthread_db.so.1".
---Before main()---

Temporary breakpoint 1, main () at hello.c:4
4               printf("hello\n");
```

## Break Points

Breakpoints are set with `break`. The number of lines of the program, function name, or address can be specified as a breakpoint.

```text
(gdb) b 5
(gdb) syscall
(gdb) 0x0000555555555144
```

The set breakpoints can be checked as follows.

```text
(gdb) info breakpoints
Num     Type           Disp Enb Address            What
2       breakpoint     keep y   0x00007ffff7e942f0 <syscall>
```

To delete a breakpoint, use the number of the breakpoint listed in `info b`.

```text
(gdb) delete 2
```

## Memory Mappings

Memory mapping can be output as follows.

```text
(gdb) info proc mappings
process 18156
Mapped address spaces:

          Start Addr           End Addr       Size     Offset  Perms  objfile
      0x555555554000     0x555555555000     0x1000        0x0  r--p   /home/mori/exp/a.out
      0x555555555000     0x555555556000     0x1000     0x1000  r-xp   /home/mori/exp/a.out
      0x555555556000     0x555555557000     0x1000     0x2000  r--p   /home/mori/exp/a.out
      0x555555557000     0x555555558000     0x1000     0x2000  r--p   /home/mori/exp/a.out
      0x555555558000     0x555555559000     0x1000     0x3000  rw-p   /home/mori/exp/a.out
      0x555555559000     0x55555557a000    0x21000        0x0  rw-p   [heap]
      0x7ffff7d86000     0x7ffff7d89000     0x3000        0x0  rw-p
      0x7ffff7d89000     0x7ffff7db1000    0x28000        0x0  r--p   /usr/lib/libc.so.6
      0x7ffff7db1000     0x7ffff7f29000   0x178000    0x28000  r-xp   /usr/lib/libc.so.6
      0x7ffff7f29000     0x7ffff7f81000    0x58000   0x1a0000  r--p   /usr/lib/libc.so.6
      0x7ffff7f81000     0x7ffff7f82000     0x1000   0x1f8000  ---p   /usr/lib/libc.so.6
      0x7ffff7f82000     0x7ffff7f86000     0x4000   0x1f8000  r--p   /usr/lib/libc.so.6
      0x7ffff7f86000     0x7ffff7f88000     0x2000   0x1fc000  rw-p   /usr/lib/libc.so.6
      0x7ffff7f88000     0x7ffff7f95000     0xd000        0x0  rw-p
      0x7ffff7fb9000     0x7ffff7fba000     0x1000        0x0  r--p   /home/mori/exp/hook.so
      0x7ffff7fba000     0x7ffff7fbb000     0x1000     0x1000  r-xp   /home/mori/exp/hook.so
      0x7ffff7fbb000     0x7ffff7fbc000     0x1000     0x2000  r--p   /home/mori/exp/hook.so
      0x7ffff7fbc000     0x7ffff7fbd000     0x1000     0x2000  r--p   /home/mori/exp/hook.so
      0x7ffff7fbd000     0x7ffff7fbe000     0x1000     0x3000  rw-p   /home/mori/exp/hook.so
      0x7ffff7fbe000     0x7ffff7fc0000     0x2000        0x0  rw-p
      0x7ffff7fc0000     0x7ffff7fc4000     0x4000        0x0  r--p   [vvar]
      0x7ffff7fc4000     0x7ffff7fc6000     0x2000        0x0  r-xp   [vdso]
      0x7ffff7fc6000     0x7ffff7fc8000     0x2000        0x0  r--p   /usr/lib/ld-linux-x86-64.so.2
      0x7ffff7fc8000     0x7ffff7fef000    0x27000     0x2000  r-xp   /usr/lib/ld-linux-x86-64.so.2
      0x7ffff7fef000     0x7ffff7ffa000     0xb000    0x29000  r--p   /usr/lib/ld-linux-x86-64.so.2
      0x7ffff7ffb000     0x7ffff7ffd000     0x2000    0x34000  r--p   /usr/lib/ld-linux-x86-64.so.2
      0x7ffff7ffd000     0x7ffff7fff000     0x2000    0x36000  rw-p   /usr/lib/ld-linux-x86-64.so.2
      0x7ffffffde000     0x7ffffffff000    0x21000        0x0  rw-p   [stack]
  0xffffffffff600000 0xffffffffff601000     0x1000        0x0  --xp   [vsyscall]
```

## Disassemble

Use disas to display the current execution position at the assembly language level. `=>` is the current position.

```text
(gdb) disassemble
Dump of assembler code for function main:
   0x0000555555555139 <+0>:     push   %rbp
   0x000055555555513a <+1>:     mov    %rsp,%rbp
=> 0x000055555555513d <+4>:     lea    0xec0(%rip),%rax        # 0x555555556004
   0x0000555555555144 <+11>:    mov    %rax,%rdi
   0x0000555555555147 <+14>:    call   0x555555555030 <puts@plt>
   0x000055555555514c <+19>:    mov    $0x0,%eax
   0x0000555555555151 <+24>:    pop    %rbp
   0x0000555555555152 <+25>:    ret
End of assembler dump.
```

`layout asm` also shows the current execution position and the surrounding assembly code.

```text
┌────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│    0x555555555139 <main>           push   %rbp                                                                                                                                 │
│    0x55555555513a <main+1>         mov    %rsp,%rbp                                                                                                                            │
│  > 0x55555555513d <main+4>         lea    0xec0(%rip),%rax        # 0x555555556004                                                                                             │
│    0x555555555144 <main+11>        mov    %rax,%rdi                                                                                                                            │
│    0x555555555147 <main+14>        call   0x555555555030 <puts@plt>                                                                                                            │
│    0x55555555514c <main+19>        mov    $0x0,%eax                                                                                                                            │
│    0x555555555151 <main+24>        pop    %rbp                                                                                                                                 │
│    0x555555555152 <main+25>        ret                                                                                                                                         │
│    0x555555555153                  add    %dh,%bl                                                                                                                              │
│    0x555555555155 <_fini+1>        nop    %edx                                                                                                                                 │
│    0x555555555158 <_fini+4>        sub    $0x8,%rsp                                                                                                                            │
│    0x55555555515c <_fini+8>        add    $0x8,%rsp                                                                                                                            │
│    0x555555555160 <_fini+12>       ret                                                                                                                                         │
│    0x555555555161                  add    %al,(%rax)                                                                                                                           │
│    0x555555555163                  add    %al,(%rax)                                                                                                                           │
│    0x555555555165                  add    %al,(%rax)                                                                                                                           │
│    0x555555555167                  add    %al,(%rax)                                                                                                                           │
│    0x555555555169                  add    %al,(%rax)                                                                                                                           │
│    0x55555555516b                  add    %al,(%rax)                                                                                                                           │
│    0x55555555516d                  add    %al,(%rax)                                                                                                                           │
│    0x55555555516f                  add    %al,(%rax)                                                                                                                           │
│    0x555555555171                  add    %al,(%rax)                                                                                                                           │
│    0x555555555173                  add    %al,(%rax)                                                                                                                           │
│    0x555555555175                  add    %al,(%rax)                                                                                                                           │
│    0x555555555177                  add    %al,(%rax)                                                                                                                           │
│    0x555555555179                  add    %al,(%rax)                                                                                                                           │
└────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
multi-thre Thread 0x7ffff7d867 In: main                                                                                                                  L4    PC: 0x55555555513d
(gdb) layout asm
```

`layout src` to check the location at the source code level as well.

```text
┌─hello.c────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│        1  #include <stdio.h>                                                                                                                                                   │
│        2                                                                                                                                                                       │
│        3  int main() {                                                                                                                                                         │
│  >     4          printf("hello\n");                                                                                                                                           │
│        5  }                                                                                                                                                                    │
│        6                                                                                                                                                                       │
│        7                                                                                                                                                                       │
│        8                                                                                                                                                                       │
│        9                                                                                                                                                                       │
│       10                                                                                                                                                                       │
│       11                                                                                                                                                                       │
│       12                                                                                                                                                                       │
│       13                                                                                                                                                                       │
│       14                                                                                                                                                                       │
│       15                                                                                                                                                                       │
│       16                                                                                                                                                                       │
│       17                                                                                                                                                                       │
│       18                                                                                                                                                                       │
│       19                                                                                                                                                                       │
│       20                                                                                                                                                                       │
│       21                                                                                                                                                                       │
│       22                                                                                                                                                                       │
│       23                                                                                                                                                                       │
│       24                                                                                                                                                                       │
│       25                                                                                                                                                                       │
│       26                                                                                                                                                                       │
└────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
multi-thre Thread 0x7ffff7d867 In: main                                                                                                                  L4    PC: 0x55555555513d
(gdb) layout src
```

To exit the TUI screen, type `Ctrl+x a`.

## Step

There are several types of program step execution, which can be summarized as follows

| Commands | Descriptions                                                               |
| -------- | -------------------------------------------------------------------------- |
| next     | Step execution at the function level (don't enter the function)            |
| step     | Step execution at the function level (do enter the function)               |
| ni       | Step execution at the instruction level of assembly (don't go beyond call) |
| si       | Step execution at the instruction level of assembly (do go beyond call)    |

## Memory Dump

Use `x` to see the contents of memory. Specify `size`, start `address` and output `format`.

```text
(gdb) x/[size][format] [address]
```

The following example dumps a memory address containing "hello" in string format.

```text
(gdb) start
Temporary breakpoint 3 at 0x55555555513d: file hello.c, line 4.
Starting program: /home/mori/exp/a.out
---Before main()---
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/usr/lib/libthread_db.so.1".
---Before main()---

Temporary breakpoint 3, main () at hello.c:4
4               printf("hello\n");
(gdb) disas
Dump of assembler code for function main:
   0x0000555555555139 <+0>:     push   %rbp
   0x000055555555513a <+1>:     mov    %rsp,%rbp
=> 0x000055555555513d <+4>:     lea    0xec0(%rip),%rax        # 0x555555556004
   0x0000555555555144 <+11>:    mov    %rax,%rdi
   0x0000555555555147 <+14>:    call   0x555555555030 <puts@plt>
   0x000055555555514c <+19>:    mov    $0x0,%eax
   0x0000555555555151 <+24>:    pop    %rbp
   0x0000555555555152 <+25>:    ret
End of assembler dump.
(gdb) x/s 0x555555556004
0x555555556004: "hello"
(gdb) x/ 0x555555556004
0x555555556004: "hello"
```

## Symbol Table

GDB stores symbol information such as function names in a structure called `symtab`.

In normal cases, you do not need to do this, but if you want to delete a symbol table or add a symbol from an executable file, you can use the command `symbol-file`.

To delete a symbol, execute the following command with no arguments.

```text
(gdb) symbol-file
Discard symbol table from `/path/to/exec/file'? (y or n) y
No symbol file now.
```

To read a symbol from another executable, specify the file path.

```text
(gdb) symbol-file a.out
Reading symbols from a.out...
Reading symbols from /usr/lib/libc.so.6...
(No debugging symbols found in /usr/lib/libc.so.6)
Reading symbols from /lib64/ld-linux-x86-64.so.2...
(No debugging symbols found in /lib64/ld-linux-x86-64.so.2)
```

If an offset is required, specify the offset size as an option.

```text
(gdb) symbol-file -o 0x555555554000 a.out
Reading symbols from a.out...
Reading symbols from /usr/lib/libc.so.6...
(No debugging symbols found in /usr/lib/libc.so.6)
Reading symbols from /lib64/ld-linux-x86-64.so.2...
(No debugging symbols found in /lib64/ld-linux-x86-64.so.2)
```
