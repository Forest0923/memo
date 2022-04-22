+++
title = "Linux Segfault"
description = ""
date = 2022-04-22T07:56:26+09:00
tags = [
  "Linux"
]
categories = [
  "Linux Code Reading"
]
menu = "main"
draft = true
+++

## Segfault

プロセスリカバリの実験中にエラーが発生し `segfault at 0 ip [useraddr] sp [useraddr] error 6` のようなログが得られたのでどこでエラーが起きているか確認したときのメモ．
エラーログは arch/x86/mm/fault.c の show_signal_msg() で出力されていた．

```c
/*
 * Print out info about fatal segfaults, if the show_unhandled_signals
 * sysctl is set:
 */
static inline void
show_signal_msg(struct pt_regs *regs, unsigned long error_code,
		unsigned long address, struct task_struct *tsk)
{
	const char *loglvl = task_pid_nr(tsk) > 1 ? KERN_INFO : KERN_EMERG;

	if (!unhandled_signal(tsk, SIGSEGV))
		return;

	if (!printk_ratelimit())
		return;

	printk("%s%s[%d]: segfault at %lx ip %px sp %px error %lx",
		loglvl, tsk->comm, task_pid_nr(tsk), address,
		(void *)regs->ip, (void *)regs->sp, error_code);

	print_vma_addr(KERN_CONT " in ", regs->ip);

	printk(KERN_CONT "\n");

	show_opcodes(regs, loglvl);
}
```

show_signal_msg() がどこで呼び出されているかたどっていくと bad_area_nosemaphore() か __bad_area() のどちらかで呼ばれていることがわかった．
それぞれの呼び出しは下記のようになっていた．

```text
--> bad_area_nosemaphore()

--> __bad_area_nosemaphore()

--> show_signal_msg()
```

```text
asm_exc_page_fault()

--> handle_page_fault()

--> do_user_addr_fault()

--> bad_area()
//--> bad_area_access_error()

--> __bad_area()

--> __bad_area_nosemaphore()

--> show_signal_msg()
```
