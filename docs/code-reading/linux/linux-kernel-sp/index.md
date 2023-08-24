---
title: "Kernel Stack Pointers"
description: ""
tags: [
  "Linux"
]
---

## Version

- Linux v5.8.13

## About

Linux において kernel stack pointer がどのように管理されて user sp と切り替えられているのか調べたときのメモ．

主に kernel sp が保存されているであろう TSS についてのコードレベルの説明，まだ理解できていない部分が多い．

## TSS: Task State Segment

TSS はその名の通りタスクの情報を保存するためのデータ構造．特性上，タスクごとに固有のものを持っているはず．

- [OS Dev - Task State Segment](https://wiki.osdev.org/Task_State_Segment)
- [Kernel Documents - Kernel Stacks](https://www.kernel.org/doc/html/latest/x86/kernel-stacks.html)

## Data Structures in Linux Kernel

### `struct tss_struct`

TSS のデータは arch/x86/include/asm/processor.h で定義された `tss_struct` 構造体に格納される．

```c
struct tss_struct {
	/*
	 * The fixed hardware portion.  This must not cross a page boundary
	 * at risk of violating the SDM's advice and potentially triggering
	 * errata.
	 */
	struct x86_hw_tss;

	struct x86_io_bitmap	io_bitmap;
} __aligned(PAGE_SIZE);
```

### `struct x86_hw_tss` in 32-bit

32-bit 環境と 64-bit 環境で内容が異なる．

32-bit 環境では下記のように汎用レジスタなどの情報も含まれているらしい．

```c
/* This is the TSS defined by the hardware. */
struct x86_hw_tss {
	unsigned short		back_link, __blh;
	unsigned long		sp0;
	unsigned short		ss0, __ss0h;
	unsigned long		sp1;

	/*
	 * We don't use ring 1, so ss1 is a convenient scratch space in
	 * the same cacheline as sp0.  We use ss1 to cache the value in
	 * MSR_IA32_SYSENTER_CS.  When we context switch
	 * MSR_IA32_SYSENTER_CS, we first check if the new value being
	 * written matches ss1, and, if it's not, then we wrmsr the new
	 * value and update ss1.
	 *
	 * The only reason we context switch MSR_IA32_SYSENTER_CS is
	 * that we set it to zero in vm86 tasks to avoid corrupting the
	 * stack if we were to go through the sysenter path from vm86
	 * mode.
	 */
	unsigned short		ss1;	/* MSR_IA32_SYSENTER_CS */

	unsigned short		__ss1h;
	unsigned long		sp2;
	unsigned short		ss2, __ss2h;
	unsigned long		__cr3;
	unsigned long		ip;
	unsigned long		flags;
	unsigned long		ax;
	unsigned long		cx;
	unsigned long		dx;
	unsigned long		bx;
	unsigned long		sp;
	unsigned long		bp;
	unsigned long		si;
	unsigned long		di;
	unsigned short		es, __esh;
	unsigned short		cs, __csh;
	unsigned short		ss, __ssh;
	unsigned short		ds, __dsh;
	unsigned short		fs, __fsh;
	unsigned short		gs, __gsh;
	unsigned short		ldt, __ldth;
	unsigned short		trace;
	unsigned short		io_bitmap_base;

} __attribute__((packed));
```

### `struct x86_hw_tss` in 64-bit

64-bit 環境では下記のように TSS の内容がシンプルになっている．以下はそれぞれのメンバに関するメモ．

- `sp0`: Ring-0 用の stack pointer. Linux において ring-0 は kernel が動作しているのでこれが kernel stack pointer?
- `sp1`: Ring-1 用の stack pointer. Linux では ring-1 が使われないので，cpu_current_top_of_stack が保存されるらしい．User space で動作中は user sp, kernel space で動作中は kernel sp のトップが格納されるということ? HW で勝手に特権やタスクのスイッチ時にアップデートされるのかもしれない．
- `sp2`: Ring-2 用の stack pointer. rin-2 も Linux では使われていない．"scrach space" として使われるらしい．`entry_SYSCALL_64` では user sp を退避するために一時的に使用されている．
- `ist`: abbr. Interrupt Stack Table. 割り込みが入ったときに使われるスタックのポインタ? 上限は 7 個らしいがそれより多い割り込みが同時に来ることはないのか...?

```c
struct x86_hw_tss {
	u32			reserved1;
	u64			sp0;

	/*
	 * We store cpu_current_top_of_stack in sp1 so it's always accessible.
	 * Linux does not use ring 1, so sp1 is not otherwise needed.
	 */
	u64			sp1;

	/*
	 * Since Linux does not use ring 2, the 'sp2' slot is unused by
	 * hardware.  entry_SYSCALL_64 uses it as scratch space to stash
	 * the user RSP value.
	 */
	u64			sp2;

	u64			reserved2;
	u64			ist[7];
	u32			reserved3;
	u32			reserved4;
	u16			reserved5;
	u16			io_bitmap_base;

} __attribute__((packed));
```

### `struct x86_io_bitmap`

Stack 関連に注目したいので `x86_io_bitmap` は構造体の中身のみ示す．

定義は arch/x86/include/asm/processor.h にある．

```c
/*
 * All IO bitmap related data stored in the TSS:
 */
struct x86_io_bitmap {
	/* The sequence number of the last active bitmap. */
	u64			prev_sequence;

	/*
	 * Store the dirty size of the last io bitmap offender. The next
	 * one will have to do the cleanup as the switch out to a non io
	 * bitmap user will just set x86_tss.io_bitmap_base to a value
	 * outside of the TSS limit. So for sane tasks there is no need to
	 * actually touch the io_bitmap at all.
	 */
	unsigned int		prev_max;

	/*
	 * The extra 1 is there because the CPU will access an
	 * additional byte beyond the end of the IO permission
	 * bitmap. The extra byte must be all 1 bits, and must
	 * be within the limit.
	 */
	unsigned long		bitmap[IO_BITMAP_LONGS + 1];

	/*
	 * Special I/O bitmap to emulate IOPL(3). All bytes zero,
	 * except the additional byte at the end.
	 */
	unsigned long		mapall[IO_BITMAP_LONGS + 1];
};
```

## Use Case

`cpu_tss_rw` という `struct tss_struct` 型の変数が定義されている．

```c
/*
 * per-CPU TSS segments. Threads are completely 'soft' on Linux,
 * no more per-task TSS's. The TSS size is kept cacheline-aligned
 * so they are allowed to end up in the .data..cacheline_aligned
 * section. Since TSS's are completely CPU-local, we want them
 * on exact cacheline boundaries, to eliminate cacheline ping-pong.
 */
__visible DEFINE_PER_CPU_PAGE_ALIGNED(struct tss_struct, cpu_tss_rw) = {
	.x86_tss = {
		/*
		 * .sp0 is only used when entering ring 0 from a lower
		 * privilege level.  Since the init task never runs anything
		 * but ring 0 code, there is no need for a valid value here.
		 * Poison it.
		 */
		.sp0 = (1UL << (BITS_PER_LONG-1)) + 1,

		/*
		 * .sp1 is cpu_current_top_of_stack.  The init task never
		 * runs user code, but cpu_current_top_of_stack should still
		 * be well defined before the first context switch.
		 */
		.sp1 = TOP_OF_INIT_STACK,

#ifdef CONFIG_X86_32
		.ss0 = __KERNEL_DS,
		.ss1 = __KERNEL_CS,
#endif
		.io_bitmap_base	= IO_BITMAP_OFFSET_INVALID,
	 },
};
EXPORT_PER_CPU_SYMBOL(cpu_tss_rw);
```

`struct tss_struct` 内の sp0 などへのオフセットを示すマクロが定義されているため，それを用いてアクセスできる．

```c
cpu_tss_rw + TSS_sp0
```

マクロは下記のコードで動的に作成されるらしい．(arch/x86/kernel/asm-offsets.c)

```c
static void __used common(void)
{
	...
	/* Offset for fields in tss_struct */
	OFFSET(TSS_sp0, tss_struct, x86_tss.sp0);
	OFFSET(TSS_sp1, tss_struct, x86_tss.sp1);
	OFFSET(TSS_sp2, tss_struct, x86_tss.sp2);
}
```

カーネルをビルドすると include/generated/asm-offsets.h が作成され，その中で定義されていることがわかる．

```c
...
#define TSS_sp0 4 /* offsetof(struct tss_struct, x86_tss.sp0) */
#define TSS_sp1 12 /* offsetof(struct tss_struct, x86_tss.sp1) */
#define TSS_sp2 20 /* offsetof(struct tss_struct, x86_tss.sp2) */
```
