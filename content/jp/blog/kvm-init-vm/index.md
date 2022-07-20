+++
title = "KVM での VM 作成"
description = ""
date = 2022-04-10T16:11:21+09:00
tags = [
  "Linux", "QEMU/KVM"
]
categories = [
  "Linux Code Reading"
]
draft = true
+++

## About

この wiki では，QEMU/KVM において VM を作成して実際に動作していく際の流れを実際のコードをたどりながら説明する．説明する内容は次の3点：

- [About](#about)
- [環境](#環境)
- [VM・vCPU の作成](#vmvcpu-の作成)
- [VM の実行](#vm-の実行)
- [VM Entry/Exit](#vm-entryexit)

## 環境

- Linux v5.8.13
- QEMU v6.2.0
- x86

## VM・vCPU の作成

ここではそもそもどうやって KVM のモジュールにアクセスして VM を作成するかを見ていく．

KVM は /dev/kvm というデバイスファイル（スペシャルファイル）を提供している．VM 作成などの操作をするためには /dev/kvm に対して ioctl() を実行する．
ioctl() はデバイスを制御したりデータをやり取りするために使用されるシステムコールであり，open したファイルディスクリプタ，リクエスト内容を示すコード，引数ベクタへのポインタの3つを渡す必要がある．
例えば KVM で VM を作成するには下記のように /dev/kvm をオープンして ioctl() を実行する．

```c
int kvmfd = open("/dev/kvm", O_RDWR);
int vmfd = ioctl(kvmfd, KVM_CREATE_VM, 0);
```

QEMU/KVM では，QEMU のコード内で上記のような VM 作成のためのコードが実行される．実際のコードは下記のようなもので kvm_init() から呼び出される一連の関数の中で ioctl が呼ばれる．
ioctl() のハンドラは KVM 内にあり，kvm 構造体などが作成される．詳細は [kvm 構造体の作成](KVMのデータ構造#kvm-構造体の作成) を参照する．

```c
// accel/kvm/kvm-all.c
static int kvm_init(MachineState *ms)
{
	...
	s->fd = qemu_open_old("/dev/kvm", O_RDWR);	// /dev/kvm を open する
	if (s->fd == -1) {
		fprintf(stderr, "Could not access KVM kernel module: %m\n");
		ret = -errno;
		goto err;
	}
	...
	do {
		ret = kvm_ioctl(s, KVM_CREATE_VM, type);	// ioctl を発行して VM を作成する
	} while (ret == -EINTR);

	if (ret < 0) {
		fprintf(stderr, "ioctl(KVM_CREATE_VM) failed: %d %s\n", -ret,
				strerror(-ret));
	...
}
```

```c
// util/osdep.c
int qemu_open_old(const char *name, int flags, ...)
{
	...
	ret = qemu_open_internal(name, flags, mode, NULL);

#ifdef O_DIRECT
	if (ret == -1 && errno == EINVAL && (flags & O_DIRECT)) {
		error_report("file system may not support O_DIRECT");
		errno = EINVAL; /* in case it was clobbered */
	}
#endif /* O_DIRECT */

	return ret;
}
```

```c
// util/osdep.c
static int
qemu_open_internal(const char *name, int flags, mode_t mode, Error **errp)
{
	...
	ret = qemu_open_cloexec(name, flags, mode);

	if (ret == -1) {
		...
	}

	return ret;
}
```

```c
// util/osdep.c
static int qemu_open_cloexec(const char *name, int flags, mode_t mode)
{
	int ret;
#ifdef O_CLOEXEC
	ret = open(name, flags | O_CLOEXEC, mode);
#else
	ret = open(name, flags, mode);
	if (ret >= 0) {
		qemu_set_cloexec(ret);
	}
#endif
	return ret;
}
```

```c
// accel/kvm/kvm-all.c
int kvm_ioctl(KVMState *s, int type, ...)
{
	int ret;
	void *arg;
	va_list ap;

	va_start(ap, type);
	arg = va_arg(ap, void *);
	va_end(ap);

	trace_kvm_ioctl(type, arg);
	ret = ioctl(s->fd, type, arg);
	if (ret == -1) {
		ret = -errno;
	}
	return ret;
}
```

VM のための virtual CPU（vCPU） を作成する場合は，下記のように VM のファイルディスクリプタを引数として ioctl() を実行する．

```c
//int kvmfd = open("/dev/kvm", O_RDWR);
//int vmfd = ioctl(kvmfd, KVM_CREATE_VM, 0);
int vcpufd = ioctl(vmfd, KVM_CREATE_VCPU, 0);
```

QEMU では kvm_init_vcpu() によって vCPU を作成するための ioctl() が実行される．
この ioctl() に対するハンドラも VM 作成時と同様に KVM 内に書かれており，詳細は [kvm_vcpu 構造体の作成](KVMのデータ構造#kvm_vcpu-構造体の作成) を参照する．

```c
// accel/kvm/kvm-accel-ops.c
static void *kvm_vcpu_thread_fn(void *arg)
{
	...
	r = kvm_init_vcpu(cpu, &error_fatal);	// vcpu を作成する
	...
	do {
		if (cpu_can_run(cpu)) {
			r = kvm_cpu_exec(cpu);	// KVM_RUN
			...
		}
		...
	} while (!cpu->unplug || cpu_can_run(cpu));

	kvm_destroy_vcpu(cpu);
	...
	return NULL;
}
```

```c
// accel/kvm/kvm-all.c
int kvm_init_vcpu(CPUState *cpu, Error **errp)
{
	...
	ret = kvm_get_vcpu(s, kvm_arch_vcpu_id(cpu));
	if (ret < 0) {
		error_setg_errno(errp, -ret, "kvm_init_vcpu: kvm_get_vcpu failed (%lu)",
						kvm_arch_vcpu_id(cpu));
		goto err;
	}
	...
	ret = kvm_arch_init_vcpu(cpu);
	if (ret < 0) {
		error_setg_errno(errp, -ret,
						"kvm_init_vcpu: kvm_arch_init_vcpu failed (%lu)",
						kvm_arch_vcpu_id(cpu));
	}
err:
	return ret;
}
```

```c
// accel/kvm/kvm-all.c
static int kvm_get_vcpu(KVMState *s, unsigned long vcpu_id)
{
	...
	return kvm_vm_ioctl(s, KVM_CREATE_VCPU, (void *)vcpu_id);
}
```

```c
// accel/kvm/kvm-all.c
int kvm_vm_ioctl(KVMState *s, int type, ...)
{
	...
	ret = ioctl(s->vmfd, type, arg);	// ioctl() を発行
	if (ret == -1) {
		ret = -errno;
	}
	return ret;
}
```

## VM の実行

VM を実行するには vcpu のファイルディスクリプタを引数として下記のように ioctl を発行する．

```c
//int kvmfd = open("/dev/kvm", O_RDWR);
//int vmfd = ioctl(kvmfd, KVM_CREATE_VM, 0);
//int vcpufd = ioctl(vmfd, KVM_CREATE_VCPU, 0);
int ret = ioctl(vcpufd, KVM_RUN, 0);
```

QEMU では vCPU のスレッドを作成するときに kvm_init_vcpu() で vCPU が作成され，その後の kvm_cpu_exec() で KVM_RUN の ioctl が実行される．
実際のコードを抜粋したものを以下に示す．

```c
// accel/kvm/kvm-accel-ops.c
static void *kvm_vcpu_thread_fn(void *arg)
{
	...
	r = kvm_init_vcpu(cpu, &error_fatal);	// vcpu を作成する
	...
	do {
		if (cpu_can_run(cpu)) {
			r = kvm_cpu_exec(cpu);	// KVM_RUN のリクエストをループして実行し続ける
			...
		}
		...
	} while (!cpu->unplug || cpu_can_run(cpu));

	kvm_destroy_vcpu(cpu);
	...
	return NULL;
}
```

```c
// accel/kvm/kvm-all.c
int kvm_cpu_exec(CPUState *cpu)
{
	...
	do {
		...
		run_ret = kvm_vcpu_ioctl(cpu, KVM_RUN, 0);	// ioctl
		...
		switch (run->exit_reason) {
		case KVM_EXIT_IO:
			...
			break;
		case KVM_EXIT_MMIO:
			...
			break;
		case KVM_EXIT_IRQ_WINDOW_OPEN:
			...
			break;
		case KVM_EXIT_SHUTDOWN:
			...
			break;
		case KVM_EXIT_UNKNOWN:
			...
			break;
		case KVM_EXIT_INTERNAL_ERROR:
			...
			break;
		case KVM_EXIT_DIRTY_RING_FULL:
			...
			break;
		case KVM_EXIT_SYSTEM_EVENT:
			...
			break;
		default:
			...
			break;
		}
	} while (ret == 0);
	...
}
```

```c
// accel/kvm/kvm-all.c
int kvm_vcpu_ioctl(CPUState *cpu, int type, ...)
{
	int ret;
	...
	ret = ioctl(cpu->kvm_fd, type, arg);	// ioctl() を実行
	if (ret == -1) {
		ret = -errno;
	}
	return ret;
}
```

## VM Entry/Exit

QEMU から ioctl() で KVM_RUN のリクエストを受け付けると VM が実行され，VM 内で処理できない部分は適宜 VM exit して KVM でハンドリングを行う．
KVM での処理が終了したら VM entry して VM の実行を継続する．以下ではこの VM entry/exit が実際にどのコード上で行われるかを追っていく．

KVM_RUN の ioctl は kvm_vcpu_ioctl() でハンドリングされ，kvm_arch_vcpu_ioctl_run() が呼び出される．

```c
// virt/kvm/kvm_main.c
static long kvm_vcpu_ioctl(struct file *filp,
			   unsigned int ioctl, unsigned long arg)
{
	...
	switch (ioctl) {
	case KVM_RUN: {
		...
		r = kvm_arch_vcpu_ioctl_run(vcpu);
		...
		break;
	}
	...
	}
	...
	return r;
}
```

kvm_arch_vcpu_ioctl_run() で vcpu_run() が呼び出されると，vcpu が停止されるまで vcpu_enter_guest() が無限ループで呼び出される．

```c
// arch/x86/kvm/x86.c
int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
{
	...
	if (kvm_run->immediate_exit)
		r = -EINTR;
	else
		r = vcpu_run(vcpu);
	...
	return r;
}
```

```c
// arch/x86/kvm/x86.c
static int vcpu_run(struct kvm_vcpu *vcpu)
{
	int r;
	struct kvm *kvm = vcpu->kvm;
	...
	for (;;) {
		if (kvm_vcpu_running(vcpu)) {
			r = vcpu_enter_guest(vcpu);
		} else {
			r = vcpu_block(kvm, vcpu);
		}
		...
	}
	...
	return r;
}
```

vcpu_enter_guest() 内では，kvm_x86_ops 構造体の run() というメンバに登録された関数ポインタから vmx_vcpu_run() が呼び出される．

```c
// arch/x86/kvm/x86.c
static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
{
	int r;
	...
	fastpath_t exit_fastpath;
	...
	exit_fastpath = kvm_x86_ops.run(vcpu);	// ここで VM entry/exit がおこる
	...
	r = kvm_x86_ops.handle_exit(vcpu, exit_fastpath);	// VM exit したときのハンドリングを行う
	return r;
	...
}
```

vmx_vcpu_run() は __vmx_vcpu_run() を呼び出すが，この関数の実体は arch/x86/kvm/vmx/vmenter.S 内のアセンブリコードとなっている．

```c
// arch/x86/kvm/vmx/vmx.c
static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
{
	...
	struct vcpu_vmx *vmx = to_vmx(vcpu);
	...
	vmx->fail = __vmx_vcpu_run(vmx, (unsigned long *)&vcpu->arch.regs,
				   vmx->loaded_vmcs->launched);
	...
}
```

```asm
/* arch/x86/kvm/vmx/vmenter.S */
/**
 * vmx_vmenter - VM-Enter the current loaded VMCS
 *
 * %RFLAGS.ZF:	!VMCS.LAUNCHED, i.e. controls VMLAUNCH vs. VMRESUME
 *
 * Returns:
 *	%RFLAGS.CF is set on VM-Fail Invalid
 *	%RFLAGS.ZF is set on VM-Fail Valid
 *	%RFLAGS.{CF,ZF} are cleared on VM-Success, i.e. VM-Exit
 *
 * Note that VMRESUME/VMLAUNCH fall-through and return directly if
 * they VM-Fail, whereas a successful VM-Enter + VM-Exit will jump
 * to vmx_vmexit.
 */
SYM_FUNC_START(vmx_vmenter)
	/* EFLAGS.ZF is set if VMCS.LAUNCHED == 0 */
	je 2f

	/* VM を再開するための命令 */
1:	vmresume
	ret

	/* VM 起動時の命令 */
2:	vmlaunch
	ret

3:	cmpb $0, kvm_rebooting
	je 4f
	ret
4:	ud2

	_ASM_EXTABLE(1b, 3b)
	_ASM_EXTABLE(2b, 3b)

SYM_FUNC_END(vmx_vmenter)

...

/**
 * __vmx_vcpu_run - Run a vCPU via a transition to VMX guest mode
 * @vmx:	struct vcpu_vmx * (forwarded to vmx_update_host_rsp)
 * @regs:	unsigned long * (to guest registers)
 * @launched:	%true if the VMCS has been launched
 *
 * Returns:
 *	0 on VM-Exit, 1 on VM-Fail
 */
SYM_FUNC_START(__vmx_vcpu_run)
	...
	/* Load guest registers.  Don't clobber flags. */
	mov VCPU_RCX(%_ASM_AX), %_ASM_CX
	mov VCPU_RDX(%_ASM_AX), %_ASM_DX
	mov VCPU_RBX(%_ASM_AX), %_ASM_BX
	mov VCPU_RBP(%_ASM_AX), %_ASM_BP
	mov VCPU_RSI(%_ASM_AX), %_ASM_SI
	mov VCPU_RDI(%_ASM_AX), %_ASM_DI
#ifdef CONFIG_X86_64
	mov VCPU_R8 (%_ASM_AX),  %r8
	mov VCPU_R9 (%_ASM_AX),  %r9
	mov VCPU_R10(%_ASM_AX), %r10
	mov VCPU_R11(%_ASM_AX), %r11
	mov VCPU_R12(%_ASM_AX), %r12
	mov VCPU_R13(%_ASM_AX), %r13
	mov VCPU_R14(%_ASM_AX), %r14
	mov VCPU_R15(%_ASM_AX), %r15
#endif
	/* Load guest RAX.  This kills the @regs pointer! */
	mov VCPU_RAX(%_ASM_AX), %_ASM_AX

	/* Enter guest mode */
	call vmx_vmenter

	/* Jump on VM-Fail. */
	jbe 2f
	...
SYM_FUNC_END(__vmx_vcpu_run)
```

VM exit のハンドリングは vmx_handle_exit() から kvm_vmx_exit_handlers[] に登録されたハンドラを呼び出すことで行われる．
各ハンドラは [arch/x86/kvm/vmx/vmx.c](https://elixir.bootlin.com/linux/v5.8.13/source/arch/x86/kvm/vmx/vmx.c#L5669) で登録されているので詳しく中身を見たい場合はここからたどれば良い．

```c
// arch/x86/kvm/vmx/vmx.c
static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
{
	struct vcpu_vmx *vmx = to_vmx(vcpu);
	u32 exit_reason = vmx->exit_reason;
	...
	return kvm_vmx_exit_handlers[exit_reason](vcpu);
	...
}
```
