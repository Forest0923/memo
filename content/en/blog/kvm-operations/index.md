+++
title = "kvm_x86_ops"
description = "kvm_x86_ops 構造体に登録された関数についてのメモ．"
date = 2022-09-07T12:01:53+09:00
tags = [
  "Linux", "QEMU/KVM"
]
categories = [
  "Linux Code Reading"
]
draft = false
+++

## About

KVM のコードを読んでいると `kvm_x86_ops.func(arg, ...)` のように kvm_x86_ops という変数を介してオブジェクト指向プログラムのように様々な関数を呼び出している部分があることがわかる．

仕組みとしては kvm_x86_ops 構造体に登録された関数ポインタから関数を呼び出しているというだけだが，関係のある関数をすべてまとめることができるのでコードが読みやすくなっている印象がある．

この構造体の中にはカーネル開発をする上で役に立ちそうなものが多く含まれているので，このページでは各メンバ（関数）について適宜メモをしていく．

## `struct kvm_x86_ops`

- arch/x86/include/asm/kvm_host.h

```c
struct kvm_x86_ops {
	int (*hardware_enable)(void);
	void (*hardware_disable)(void);
	void (*hardware_unsetup)(void);
	bool (*cpu_has_accelerated_tpr)(void);
	bool (*has_emulated_msr)(u32 index);
	void (*cpuid_update)(struct kvm_vcpu *vcpu);

	unsigned int vm_size;
	int (*vm_init)(struct kvm *kvm);
	void (*vm_destroy)(struct kvm *kvm);

	/* Create, but do not attach this VCPU */
	int (*vcpu_create)(struct kvm_vcpu *vcpu);
	void (*vcpu_free)(struct kvm_vcpu *vcpu);
	void (*vcpu_reset)(struct kvm_vcpu *vcpu, bool init_event);

	void (*prepare_guest_switch)(struct kvm_vcpu *vcpu);
	void (*vcpu_load)(struct kvm_vcpu *vcpu, int cpu);
	void (*vcpu_put)(struct kvm_vcpu *vcpu);

	void (*update_bp_intercept)(struct kvm_vcpu *vcpu);
	int (*get_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr);
	int (*set_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr);
	u64 (*get_segment_base)(struct kvm_vcpu *vcpu, int seg);
	void (*get_segment)(struct kvm_vcpu *vcpu,
			    struct kvm_segment *var, int seg);
	int (*get_cpl)(struct kvm_vcpu *vcpu);
	void (*set_segment)(struct kvm_vcpu *vcpu,
			    struct kvm_segment *var, int seg);
	void (*get_cs_db_l_bits)(struct kvm_vcpu *vcpu, int *db, int *l);
	void (*set_cr0)(struct kvm_vcpu *vcpu, unsigned long cr0);
	int (*set_cr4)(struct kvm_vcpu *vcpu, unsigned long cr4);
	void (*set_efer)(struct kvm_vcpu *vcpu, u64 efer);
	void (*get_idt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
	void (*set_idt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
	void (*get_gdt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
	void (*set_gdt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
	void (*sync_dirty_debug_regs)(struct kvm_vcpu *vcpu);
	void (*set_dr7)(struct kvm_vcpu *vcpu, unsigned long value);
	void (*cache_reg)(struct kvm_vcpu *vcpu, enum kvm_reg reg);
	unsigned long (*get_rflags)(struct kvm_vcpu *vcpu);
	void (*set_rflags)(struct kvm_vcpu *vcpu, unsigned long rflags);

	void (*tlb_flush_all)(struct kvm_vcpu *vcpu);
	void (*tlb_flush_current)(struct kvm_vcpu *vcpu);
	int  (*tlb_remote_flush)(struct kvm *kvm);
	int  (*tlb_remote_flush_with_range)(struct kvm *kvm,
			struct kvm_tlb_range *range);

	/*
	 * Flush any TLB entries associated with the given GVA.
	 * Does not need to flush GPA->HPA mappings.
	 * Can potentially get non-canonical addresses through INVLPGs, which
	 * the implementation may choose to ignore if appropriate.
	 */
	void (*tlb_flush_gva)(struct kvm_vcpu *vcpu, gva_t addr);

	/*
	 * Flush any TLB entries created by the guest.  Like tlb_flush_gva(),
	 * does not need to flush GPA->HPA mappings.
	 */
	void (*tlb_flush_guest)(struct kvm_vcpu *vcpu);

	enum exit_fastpath_completion (*run)(struct kvm_vcpu *vcpu);
	int (*handle_exit)(struct kvm_vcpu *vcpu,
		enum exit_fastpath_completion exit_fastpath);
	int (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
	void (*update_emulated_instruction)(struct kvm_vcpu *vcpu);
	void (*set_interrupt_shadow)(struct kvm_vcpu *vcpu, int mask);
	u32 (*get_interrupt_shadow)(struct kvm_vcpu *vcpu);
	void (*patch_hypercall)(struct kvm_vcpu *vcpu,
				unsigned char *hypercall_addr);
	void (*set_irq)(struct kvm_vcpu *vcpu);
	void (*set_nmi)(struct kvm_vcpu *vcpu);
	void (*queue_exception)(struct kvm_vcpu *vcpu);
	void (*cancel_injection)(struct kvm_vcpu *vcpu);
	int (*interrupt_allowed)(struct kvm_vcpu *vcpu, bool for_injection);
	int (*nmi_allowed)(struct kvm_vcpu *vcpu, bool for_injection);
	bool (*get_nmi_mask)(struct kvm_vcpu *vcpu);
	void (*set_nmi_mask)(struct kvm_vcpu *vcpu, bool masked);
	void (*enable_nmi_window)(struct kvm_vcpu *vcpu);
	void (*enable_irq_window)(struct kvm_vcpu *vcpu);
	void (*update_cr8_intercept)(struct kvm_vcpu *vcpu, int tpr, int irr);
	bool (*check_apicv_inhibit_reasons)(ulong bit);
	void (*pre_update_apicv_exec_ctrl)(struct kvm *kvm, bool activate);
	void (*refresh_apicv_exec_ctrl)(struct kvm_vcpu *vcpu);
	void (*hwapic_irr_update)(struct kvm_vcpu *vcpu, int max_irr);
	void (*hwapic_isr_update)(struct kvm_vcpu *vcpu, int isr);
	bool (*guest_apic_has_interrupt)(struct kvm_vcpu *vcpu);
	void (*load_eoi_exitmap)(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap);
	void (*set_virtual_apic_mode)(struct kvm_vcpu *vcpu);
	void (*set_apic_access_page_addr)(struct kvm_vcpu *vcpu);
	int (*deliver_posted_interrupt)(struct kvm_vcpu *vcpu, int vector);
	int (*sync_pir_to_irr)(struct kvm_vcpu *vcpu);
	int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
	int (*set_identity_map_addr)(struct kvm *kvm, u64 ident_addr);
	int (*get_tdp_level)(struct kvm_vcpu *vcpu);
	u64 (*get_mt_mask)(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);

	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, unsigned long cr3);

	bool (*has_wbinvd_exit)(void);

	/* Returns actual tsc_offset set in active VMCS */
	u64 (*write_l1_tsc_offset)(struct kvm_vcpu *vcpu, u64 offset);

	void (*get_exit_info)(struct kvm_vcpu *vcpu, u64 *info1, u64 *info2);

	int (*check_intercept)(struct kvm_vcpu *vcpu,
			       struct x86_instruction_info *info,
			       enum x86_intercept_stage stage,
			       struct x86_exception *exception);
	void (*handle_exit_irqoff)(struct kvm_vcpu *vcpu);

	void (*request_immediate_exit)(struct kvm_vcpu *vcpu);

	void (*sched_in)(struct kvm_vcpu *kvm, int cpu);

	/*
	 * Arch-specific dirty logging hooks. These hooks are only supposed to
	 * be valid if the specific arch has hardware-accelerated dirty logging
	 * mechanism. Currently only for PML on VMX.
	 *
	 *  - slot_enable_log_dirty:
	 *	called when enabling log dirty mode for the slot.
	 *  - slot_disable_log_dirty:
	 *	called when disabling log dirty mode for the slot.
	 *	also called when slot is created with log dirty disabled.
	 *  - flush_log_dirty:
	 *	called before reporting dirty_bitmap to userspace.
	 *  - enable_log_dirty_pt_masked:
	 *	called when reenabling log dirty for the GFNs in the mask after
	 *	corresponding bits are cleared in slot->dirty_bitmap.
	 */
	void (*slot_enable_log_dirty)(struct kvm *kvm,
				      struct kvm_memory_slot *slot);
	void (*slot_disable_log_dirty)(struct kvm *kvm,
				       struct kvm_memory_slot *slot);
	void (*flush_log_dirty)(struct kvm *kvm);
	void (*enable_log_dirty_pt_masked)(struct kvm *kvm,
					   struct kvm_memory_slot *slot,
					   gfn_t offset, unsigned long mask);
	int (*write_log_dirty)(struct kvm_vcpu *vcpu, gpa_t l2_gpa);

	/* pmu operations of sub-arch */
	const struct kvm_pmu_ops *pmu_ops;
	const struct kvm_x86_nested_ops *nested_ops;

	/*
	 * Architecture specific hooks for vCPU blocking due to
	 * HLT instruction.
	 * Returns for .pre_block():
	 *    - 0 means continue to block the vCPU.
	 *    - 1 means we cannot block the vCPU since some event
	 *        happens during this period, such as, 'ON' bit in
	 *        posted-interrupts descriptor is set.
	 */
	int (*pre_block)(struct kvm_vcpu *vcpu);
	void (*post_block)(struct kvm_vcpu *vcpu);

	void (*vcpu_blocking)(struct kvm_vcpu *vcpu);
	void (*vcpu_unblocking)(struct kvm_vcpu *vcpu);

	int (*update_pi_irte)(struct kvm *kvm, unsigned int host_irq,
			      uint32_t guest_irq, bool set);
	void (*apicv_post_state_restore)(struct kvm_vcpu *vcpu);
	bool (*dy_apicv_has_pending_interrupt)(struct kvm_vcpu *vcpu);

	int (*set_hv_timer)(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
			    bool *expired);
	void (*cancel_hv_timer)(struct kvm_vcpu *vcpu);

	void (*setup_mce)(struct kvm_vcpu *vcpu);

	int (*smi_allowed)(struct kvm_vcpu *vcpu, bool for_injection);
	int (*pre_enter_smm)(struct kvm_vcpu *vcpu, char *smstate);
	int (*pre_leave_smm)(struct kvm_vcpu *vcpu, const char *smstate);
	void (*enable_smi_window)(struct kvm_vcpu *vcpu);

	int (*mem_enc_op)(struct kvm *kvm, void __user *argp);
	int (*mem_enc_reg_region)(struct kvm *kvm, struct kvm_enc_region *argp);
	int (*mem_enc_unreg_region)(struct kvm *kvm, struct kvm_enc_region *argp);

	int (*get_msr_feature)(struct kvm_msr_entry *entry);

	bool (*need_emulation_on_page_fault)(struct kvm_vcpu *vcpu);

	bool (*apic_init_signal_blocked)(struct kvm_vcpu *vcpu);
	int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);

	void (*migrate_timers)(struct kvm_vcpu *vcpu);
};
```

### `get_msr()`

#### Definition

- arch/x86/kvm/vmx/vmx.c

```c
/*
 * Reads an msr value (of 'msr_index') into 'pdata'.
 * Returns 0 on success, non-0 otherwise.
 * Assumes vcpu_load() was already called.
 */
static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
{
	struct vcpu_vmx *vmx = to_vmx(vcpu);
	struct shared_msr_entry *msr;
	u32 index;

	switch (msr_info->index) {
#ifdef CONFIG_X86_64
	case MSR_FS_BASE:
		msr_info->data = vmcs_readl(GUEST_FS_BASE);
		break;
	case MSR_GS_BASE:
		msr_info->data = vmcs_readl(GUEST_GS_BASE);
		break;
	case MSR_KERNEL_GS_BASE:
		msr_info->data = vmx_read_guest_kernel_gs_base(vmx);
		break;
#endif
	case MSR_EFER:
		return kvm_get_msr_common(vcpu, msr_info);
	case MSR_IA32_TSX_CTRL:
		if (!msr_info->host_initiated &&
		    !(vcpu->arch.arch_capabilities & ARCH_CAP_TSX_CTRL_MSR))
			return 1;
		goto find_shared_msr;
	case MSR_IA32_UMWAIT_CONTROL:
		if (!msr_info->host_initiated && !vmx_has_waitpkg(vmx))
			return 1;

		msr_info->data = vmx->msr_ia32_umwait_control;
		break;
	case MSR_IA32_SPEC_CTRL:
		if (!msr_info->host_initiated &&
		    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
			return 1;

		msr_info->data = to_vmx(vcpu)->spec_ctrl;
		break;
	case MSR_IA32_SYSENTER_CS:
		msr_info->data = vmcs_read32(GUEST_SYSENTER_CS);
		break;
	case MSR_IA32_SYSENTER_EIP:
		msr_info->data = vmcs_readl(GUEST_SYSENTER_EIP);
		break;
	case MSR_IA32_SYSENTER_ESP:
		msr_info->data = vmcs_readl(GUEST_SYSENTER_ESP);
		break;
	case MSR_IA32_BNDCFGS:
		if (!kvm_mpx_supported() ||
		    (!msr_info->host_initiated &&
		     !guest_cpuid_has(vcpu, X86_FEATURE_MPX)))
			return 1;
		msr_info->data = vmcs_read64(GUEST_BNDCFGS);
		break;
	case MSR_IA32_MCG_EXT_CTL:
		if (!msr_info->host_initiated &&
		    !(vmx->msr_ia32_feature_control &
		      FEAT_CTL_LMCE_ENABLED))
			return 1;
		msr_info->data = vcpu->arch.mcg_ext_ctl;
		break;
	case MSR_IA32_FEAT_CTL:
		msr_info->data = vmx->msr_ia32_feature_control;
		break;
	case MSR_IA32_VMX_BASIC ... MSR_IA32_VMX_VMFUNC:
		if (!nested_vmx_allowed(vcpu))
			return 1;
		if (vmx_get_vmx_msr(&vmx->nested.msrs, msr_info->index,
				    &msr_info->data))
			return 1;
		/*
		 * Enlightened VMCS v1 doesn't have certain fields, but buggy
		 * Hyper-V versions are still trying to use corresponding
		 * features when they are exposed. Filter out the essential
		 * minimum.
		 */
		if (!msr_info->host_initiated &&
		    vmx->nested.enlightened_vmcs_enabled)
			nested_evmcs_filter_control_msr(msr_info->index,
							&msr_info->data);
		break;
	case MSR_IA32_RTIT_CTL:
		if (!vmx_pt_mode_is_host_guest())
			return 1;
		msr_info->data = vmx->pt_desc.guest.ctl;
		break;
	case MSR_IA32_RTIT_STATUS:
		if (!vmx_pt_mode_is_host_guest())
			return 1;
		msr_info->data = vmx->pt_desc.guest.status;
		break;
	case MSR_IA32_RTIT_CR3_MATCH:
		if (!vmx_pt_mode_is_host_guest() ||
			!intel_pt_validate_cap(vmx->pt_desc.caps,
						PT_CAP_cr3_filtering))
			return 1;
		msr_info->data = vmx->pt_desc.guest.cr3_match;
		break;
	case MSR_IA32_RTIT_OUTPUT_BASE:
		if (!vmx_pt_mode_is_host_guest() ||
			(!intel_pt_validate_cap(vmx->pt_desc.caps,
					PT_CAP_topa_output) &&
			 !intel_pt_validate_cap(vmx->pt_desc.caps,
					PT_CAP_single_range_output)))
			return 1;
		msr_info->data = vmx->pt_desc.guest.output_base;
		break;
	case MSR_IA32_RTIT_OUTPUT_MASK:
		if (!vmx_pt_mode_is_host_guest() ||
			(!intel_pt_validate_cap(vmx->pt_desc.caps,
					PT_CAP_topa_output) &&
			 !intel_pt_validate_cap(vmx->pt_desc.caps,
					PT_CAP_single_range_output)))
			return 1;
		msr_info->data = vmx->pt_desc.guest.output_mask;
		break;
	case MSR_IA32_RTIT_ADDR0_A ... MSR_IA32_RTIT_ADDR3_B:
		index = msr_info->index - MSR_IA32_RTIT_ADDR0_A;
		if (!vmx_pt_mode_is_host_guest() ||
			(index >= 2 * intel_pt_validate_cap(vmx->pt_desc.caps,
					PT_CAP_num_address_ranges)))
			return 1;
		if (index % 2)
			msr_info->data = vmx->pt_desc.guest.addr_b[index / 2];
		else
			msr_info->data = vmx->pt_desc.guest.addr_a[index / 2];
		break;
	case MSR_TSC_AUX:
		if (!msr_info->host_initiated &&
		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
			return 1;
		goto find_shared_msr;
	default:
	find_shared_msr:
		msr = find_msr_entry(vmx, msr_info->index);
		if (msr) {
			msr_info->data = msr->data;
			break;
		}
		return kvm_get_msr_common(vcpu, msr_info);
	}

	return 0;
}
```

#### Example Usage

```c
u64 get_fsgsbase_from_vmcs(struct kvm_vcpu *vcpu, u32 index)
{
        struct msr_data *g_msr = (struct msr_data *)kmalloc(sizeof(struct msr_data), GFP_KERNEL);
        u64 ret;

        g_msr->index    = index;
        kvm_x86_ops.get_msr(vcpu, g_msr);
        ret             = g_msr->data;
        kfree(g_msr);

        return ret;
}
EXPORT_SYMBOL(get_fsgsbase_from_vmcs);
```
