+++
title = "entry_SYSCALL_64"
description = "Linux のシステムコールエントリでの処理を調べたときのメモ"
tags = [
  "Linux", "System Call"
]
draft = false
+++

## Version

- Linux v5.8.13

## Definition

`entry_SYSCALL_64` はシステムコールが発行されたときに user-kernel の切り替えが行われるエントリポイントに該当する関数である．

以下はコメントを追加した entry_SYSCALL_64(arch/x86/entry/entry_64.S) のソースコード．

```asm
SYM_CODE_START(entry_SYSCALL_64)
	/*
	 * I still  don't understand it well enough.
	 * It might be only for debugging.
	 *
	 * See also
	 * - Comment of `arch/x86/include/asm/unwind_hints.h`
	 * - Kernel documents (ORC unwinder)
	 */
	UNWIND_HINT_EMPTY

	/*
	 * Swap user GS and kernel GS.
	 *
	 * ```
	 * #define MSR_FS_BASE		0xc0000100
	 * #define MSR_GS_BASE		0xc0000101
	 * #define MSR_KERNEL_GS_BASE	0xc0000102
	 * ```
	 */
	swapgs

	/*
	 * Save user stack pointer to TSS.
	 * sp2 means stack pointer for ring-2 but it doesn't used on Linux.
	 */
	movq	%rsp, PER_CPU_VAR(cpu_tss_rw + TSS_sp2)

	/*
	 * Switch page table.(user->kernel)
	 * See also:
	 * - blog/linux-kpti
	 */
	SWITCH_TO_KERNEL_CR3 scratch_reg=%rsp

	/*
	 * cpu_current_top_of_stack equals to TSS_sp1.
	 * Store kernel stack pointer to rsp.
	 */
	movq	PER_CPU_VAR(cpu_current_top_of_stack), %rsp

	/*
	 * Construct struct pt_regs on stack.
	 * This is one of the arguments of do_syscall_64().
	 */
	pushq	$__USER_DS				/* pt_regs->ss */
	pushq	PER_CPU_VAR(cpu_tss_rw + TSS_sp2)	/* pt_regs->sp (saved at the beginning) */
	pushq	%r11					/* pt_regs->flags */
	pushq	$__USER_CS				/* pt_regs->cs */
	pushq	%rcx					/* pt_regs->ip */
SYM_INNER_LABEL(entry_SYSCALL_64_after_hwframe, SYM_L_GLOBAL)
	pushq	%rax					/* pt_regs->orig_ax */

	/*
	 * Push the other registers in the kernel stack.
	 */
	PUSH_AND_CLEAR_REGS rax=$-ENOSYS

	/* IRQs are off. */
	movq	%rax, %rdi	/* System call nr. (the first argument) */
	movq	%rsp, %rsi	/* pointer of struct pt_regs. (the second argument) */
	call	do_syscall_64		/* returns with IRQs disabled */

	/* ================================= */
	/* ======= DEBUG PHASE START ======= */
	/* ================================= */

	/*
	 * Try to use SYSRET instead of IRET if we're returning to
	 * a completely clean 64-bit userspace context.  If we're not,
	 * go to the slow exit path.
	 */
	movq	RCX(%rsp), %rcx
	movq	RIP(%rsp), %r11

	cmpq	%rcx, %r11	/* SYSRET requires RCX == RIP */
	jne	swapgs_restore_regs_and_return_to_usermode

	/*
	 * On Intel CPUs, SYSRET with non-canonical RCX/RIP will #GP
	 * in kernel space.  This essentially lets the user take over
	 * the kernel, since userspace controls RSP.
	 *
	 * If width of "canonical tail" ever becomes variable, this will need
	 * to be updated to remain correct on both old and new CPUs.
	 *
	 * Change top bits to match most significant bit (47th or 56th bit
	 * depending on paging mode) in the address.
	 */
#ifdef CONFIG_X86_5LEVEL
	/* 5-level page table */
	ALTERNATIVE "shl $(64 - 48), %rcx; sar $(64 - 48), %rcx", \
		"shl $(64 - 57), %rcx; sar $(64 - 57), %rcx", X86_FEATURE_LA57
#else
	/* 4-level page table */
	shl	$(64 - (__VIRTUAL_MASK_SHIFT+1)), %rcx
	sar	$(64 - (__VIRTUAL_MASK_SHIFT+1)), %rcx
#endif

	/* If this changed %rcx, it was not canonical */
	cmpq	%rcx, %r11
	jne	swapgs_restore_regs_and_return_to_usermode

	cmpq	$__USER_CS, CS(%rsp)		/* CS must match SYSRET */
	jne	swapgs_restore_regs_and_return_to_usermode

	movq	R11(%rsp), %r11
	cmpq	%r11, EFLAGS(%rsp)		/* R11 == RFLAGS */
	jne	swapgs_restore_regs_and_return_to_usermode

	/*
	 * SYSCALL clears RF when it saves RFLAGS in R11 and SYSRET cannot
	 * restore RF properly. If the slowpath sets it for whatever reason, we
	 * need to restore it correctly.
	 *
	 * SYSRET can restore TF, but unlike IRET, restoring TF results in a
	 * trap from userspace immediately after SYSRET.  This would cause an
	 * infinite loop whenever #DB happens with register state that satisfies
	 * the opportunistic SYSRET conditions.  For example, single-stepping
	 * this user code:
	 *
	 *           movq	$stuck_here, %rcx
	 *           pushfq
	 *           popq %r11
	 *   stuck_here:
	 *
	 * would never get past 'stuck_here'.
	 */
	testq	$(X86_EFLAGS_RF|X86_EFLAGS_TF), %r11
	jnz	swapgs_restore_regs_and_return_to_usermode

	/* nothing to check for RSP */

	cmpq	$__USER_DS, SS(%rsp)		/* SS must match SYSRET */
	jne	swapgs_restore_regs_and_return_to_usermode

	/* ================================= */
	/* ======== DEBUG PHASE END ======== */
	/* ================================= */

	/*
	 * We win! This label is here just for ease of understanding
	 * perf profiles. Nothing jumps here.
	 */
syscall_return_via_sysret:
	/*
	 * rcx and r11 are already restored (see code above)
	 * Pop registers and restore user context.
	 */
	POP_REGS pop_rdi=0 skip_r11rcx=1

	/*
	 * Now all regs are restored except RSP and RDI.
	 * Save old stack pointer and switch to trampoline stack.
	 */
	movq	%rsp, %rdi

	/*
	 * TSS_sp0 is the trampoline stack.
	 */
	movq	PER_CPU_VAR(cpu_tss_rw + TSS_sp0), %rsp
	UNWIND_HINT_EMPTY

	/* Push user RSP to trampoline stack. It is from pt_regs */
	pushq	RSP-RDI(%rdi)
	/* Push user RDI to trampoline stack. It is from pt_regs */
	pushq	(%rdi)

	/*
	 * We are on the trampoline stack.  All regs except RDI are live.
	 * We can do future final exit work right here.
	 */
	STACKLEAK_ERASE_NOCLOBBER

	/*
	 * Switch page table.(kernel->user)
	 * See also:
	 * - blog/linux-kpti
	 */
	SWITCH_TO_USER_CR3_STACK scratch_reg=%rdi

	/* Restore rdi and rsp, and return to user */
	popq	%rdi
	popq	%rsp
	USERGS_SYSRET64
SYM_CODE_END(entry_SYSCALL_64)
```
