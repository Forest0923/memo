---
title: "[KVM] EPT"
description: ""
tags: [
  "Linux", "QEMU/KVM", "EPT"
]
---

<!-- ## Introduction

## Background -->

## Initialize EPT

## Add new entry

## Update entry

### Update state bits

```text
__direct_map()
--> mmu_set_spte()
--> set_spte()
--> mmu_spte_update()
--> mmu_spte_update_no_track()
```

```c
static bool mmu_spte_update(u64 *sptep, u64 new_spte)
{
	bool flush = false;
	u64 old_spte = mmu_spte_update_no_track(sptep, new_spte);

	if (!is_shadow_present_pte(old_spte))
		return false;

	/*
	 * For the spte updated out of mmu-lock is safe, since
	 * we always atomically update it, see the comments in
	 * spte_has_volatile_bits().
	 */
	if (spte_can_locklessly_be_made_writable(old_spte) &&
	      !is_writable_pte(new_spte))
		flush = true;

	/*
	 * Flush TLB when accessed/dirty states are changed in the page tables,
	 * to guarantee consistency between TLB and page tables.
	 */

	if (is_accessed_spte(old_spte) && !is_accessed_spte(new_spte)) {
		flush = true;
		kvm_set_pfn_accessed(spte_to_pfn(old_spte));
	}

	if (is_dirty_spte(old_spte) && !is_dirty_spte(new_spte)) {
		flush = true;
		kvm_set_pfn_dirty(spte_to_pfn(old_spte));
	}

	return flush;
}
```

### Update PFN

```text
kvm_mmu_notifier_change_pte()
--> kvm_set_spte_hva()
--> kvm_handle_hva()
--> kvm_handle_hva_range()
--> kvm_set_pte_rmapp()
```

```c
static int kvm_set_pte_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
			     struct kvm_memory_slot *slot, gfn_t gfn, int level,
			     unsigned long data)
{
	u64 *sptep;
	struct rmap_iterator iter;
	int need_flush = 0;
	u64 new_spte;
	pte_t *ptep = (pte_t *)data;
	kvm_pfn_t new_pfn;

	WARN_ON(pte_huge(*ptep));
	new_pfn = pte_pfn(*ptep);

restart:
	for_each_rmap_spte(rmap_head, &iter, sptep) {
		rmap_printk("kvm_set_pte_rmapp: spte %p %llx gfn %llx (%d)\n",
			    sptep, *sptep, gfn, level);

		need_flush = 1;

		if (pte_write(*ptep)) {
			pte_list_remove(rmap_head, sptep);
			goto restart;
		} else {
			new_spte = *sptep & ~PT64_BASE_ADDR_MASK; // update PFN
			new_spte |= (u64)new_pfn << PAGE_SHIFT;

			new_spte &= ~PT_WRITABLE_MASK;  // unwritable
			new_spte &= ~SPTE_HOST_WRITEABLE;

			new_spte = mark_spte_for_access_track(new_spte);

			mmu_spte_clear_track_bits(sptep);
			mmu_spte_set(sptep, new_spte);
		}
	}

	if (need_flush && kvm_available_flush_tlb_with_range()) {
		kvm_flush_remote_tlbs_with_address(kvm, gfn, 1);
		return 0;
	}

	return need_flush;
}
```

## Free EPT
