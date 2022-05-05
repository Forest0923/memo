+++
title = "Linux における KPTI のページテーブル切り替え"
description = ""
date = 2022-04-09T06:32:00+09:00
tags = [
  "Linux", "KPTI", "Meltdown"
]
categories = [
  "Linux Code Reading"
]
menu = "main"
+++

## Introduction

CPU の脆弱性である Meltdown 脆弱性への対策手法として Linux では Kernel Page Table Isolation が行われています．このページでは Linux v5.8.13 上の KPTI によるページテーブルの切り替えがどのように行われるかを実際のコードを追って説明していきます．

<!--
## Background

### Meltdown 脆弱性

Meltdown 脆弱性は CPU の高速化手法である out-of-order 実行に起因する脆弱性である．

[Meltdown](https://meltdownattack.com/meltdown.pdf)
[Spectre](https://spectreattack.com/spectre.pdf)

### KPTI
-->

## Page Table Switching at System Call Entry

### **User to Kernel**

KPTI では kernel 用のページテーブルと user 用のページテーブルを分けているため，CPU モードが切り替わるタイミングでページテーブルを切り替える必要があります．ここではシステムコールを発行したときにページテーブルのルートポインタが格納されている CR3 が切り替えられる処理を見ていきます．

ユーザプロセスがシステムコールを発行すると，arch/x86/entry/entry_64.S にある entry_SYSCALL_64 というエントリーポイントから実行が始まります．システムコールを実行するためにページテーブルの切り替えやレジスタの退避を行ったあとに `call do_syscall_64` を実行することでシステムコール本体が呼ばれます．

このページではページテーブルの切り替えについて見ていくので，`SWITCH_TO_KERNEL_CR3 scratch_reg=%rsp` に注目します．

```asm
SYM_CODE_START(entry_SYSCALL_64)
	UNWIND_HINT_EMPTY

	swapgs
	/* tss.sp2 is scratch space. */
	movq	%rsp, PER_CPU_VAR(cpu_tss_rw + TSS_sp2)
	SWITCH_TO_KERNEL_CR3 scratch_reg=%rsp
	movq	PER_CPU_VAR(cpu_current_top_of_stack), %rsp

	/* Construct struct pt_regs on stack */
	pushq	$__USER_DS				/* pt_regs->ss */
	pushq	PER_CPU_VAR(cpu_tss_rw + TSS_sp2)	/* pt_regs->sp */
	pushq	%r11					/* pt_regs->flags */
	pushq	$__USER_CS				/* pt_regs->cs */
	pushq	%rcx					/* pt_regs->ip */
SYM_INNER_LABEL(entry_SYSCALL_64_after_hwframe, SYM_L_GLOBAL)
	pushq	%rax					/* pt_regs->orig_ax */

	PUSH_AND_CLEAR_REGS rax=$-ENOSYS

	/* IRQs are off. */
	movq	%rax, %rdi
	movq	%rsp, %rsi
	call	do_syscall_64		/* returns with IRQs disabled */
	...
```

SWITCH_TO_KERNEL_CR3 は arch/x86/entry/calling.h で次のように定義されています．

```c
.macro SWITCH_TO_KERNEL_CR3 scratch_reg:req
	ALTERNATIVE "jmp .Lend_\@", "", X86_FEATURE_PTI
	mov	%cr3, \scratch_reg
	ADJUST_KERNEL_CR3 \scratch_reg
	mov	\scratch_reg, %cr3
.Lend_\@:
.endm
```

KPTI が有効な場合は ADJUST_KERNEL_CR3 が実行されます．これも arch/x86/entry/calling.h で定義されており，下記のようになっています．

```c
/*
#define PAGE_SHIFT			12
*/
#define PTI_USER_PGTABLE_BIT		PAGE_SHIFT
#define PTI_USER_PGTABLE_MASK		(1 << PTI_USER_PGTABLE_BIT)

/*
#ifdef CONFIG_PAGE_TABLE_ISOLATION
# define X86_CR3_PTI_PCID_USER_BIT	11
#endif
*/
#define PTI_USER_PCID_BIT		X86_CR3_PTI_PCID_USER_BIT
#define PTI_USER_PCID_MASK		(1 << PTI_USER_PCID_BIT)

#define PTI_USER_PGTABLE_AND_PCID_MASK  (PTI_USER_PCID_MASK | PTI_USER_PGTABLE_MASK)

...

.macro ADJUST_KERNEL_CR3 reg:req
	ALTERNATIVE "", "SET_NOFLUSH_BIT \reg", X86_FEATURE_PCID
	/* Clear PCID and "PAGE_TABLE_ISOLATION bit", point CR3 at kernel pagetables: */
	andq    $(~PTI_USER_PGTABLE_AND_PCID_MASK), \reg
	/* andq    ~(0x1800), \reg */
.endm
```

上記のコードによれば，11 bit 目と 12 bit 目をクリアすることでカーネル用のページテーブルのルートポインタに変換できます．

### **Kernel to User**

システムコールの実行が終了してユーザプロセスに戻る際の切り替えは SWITCH_TO_USER_CR3_STACK で行われます．

```asm
	...
	SWITCH_TO_USER_CR3_STACK scratch_reg=%rdi

	popq	%rdi
	popq	%rsp
	USERGS_SYSRET64
SYM_CODE_END(entry_SYSCALL_64)
```

一見すると長いコードに見えますが，カーネルに切り替えるときと逆の処理を行うだけなので CR3 の 11 bit 目と 12 bit 目を適宜 1 にしているだけです．

```c
.macro SWITCH_TO_USER_CR3_NOSTACK scratch_reg:req scratch_reg2:req
	ALTERNATIVE "jmp .Lend_\@", "", X86_FEATURE_PTI
	mov	%cr3, \scratch_reg

	ALTERNATIVE "jmp .Lwrcr3_\@", "", X86_FEATURE_PCID

	/*
	 * Test if the ASID needs a flush.
	 */
	movq	\scratch_reg, \scratch_reg2
	andq	$(0x7FF), \scratch_reg		/* mask ASID */
	bt	\scratch_reg, THIS_CPU_user_pcid_flush_mask
	jnc	.Lnoflush_\@

	/* Flush needed, clear the bit */
	btr	\scratch_reg, THIS_CPU_user_pcid_flush_mask
	movq	\scratch_reg2, \scratch_reg
	jmp	.Lwrcr3_pcid_\@

.Lnoflush_\@:
	movq	\scratch_reg2, \scratch_reg
	SET_NOFLUSH_BIT \scratch_reg

.Lwrcr3_pcid_\@:
	/* Flip the ASID to the user version */
	orq	$(PTI_USER_PCID_MASK), \scratch_reg

.Lwrcr3_\@:
	/* Flip the PGD to the user version */
	orq     $(PTI_USER_PGTABLE_MASK), \scratch_reg
	mov	\scratch_reg, %cr3
.Lend_\@:
.endm

/*
	SWITCH_TO_USER_CR3_STACK scratch_reg=%rdi
*/
.macro SWITCH_TO_USER_CR3_STACK	scratch_reg:req
	pushq	%rax
	SWITCH_TO_USER_CR3_NOSTACK scratch_reg=\scratch_reg scratch_reg2=%rax
	popq	%rax
.endm
```

## 実験

実際にプロセスの CR3 をユーザプロセス実行中とカーネル実行中に出力したときの実験結果を見てみます．CR3 は QEMU/KVM で KVM 側から kvm_cr3_read() によって取得しました．

実験結果は下記のようになっており，ソースコードで確認したとおりの変換が行われていることがわかりました．

```text
kernel cr3 = 0x273abe003
user cr3   = 0x273abf803
```
