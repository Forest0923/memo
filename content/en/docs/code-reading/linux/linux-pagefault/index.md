+++
title = "Page Fault handling"
description = ""
tags = [
  "Linux"
]
draft = false
+++

## Introduction

このページでは Linux においてページフォルトが発生した際の処理の流れを説明していきます．
なお，このページでは Linux v5.8.13 のソースコードに基づいて説明を行います．

<!--
## Background

### Page Table

### Interrupt Descriptor Table
-->

## Callgraph

arch/x86/mm/fault.c
mm/memory.c

```text
asm_exc_page_fault()

--> handle_page_fault()

# --> do_kern_addr_fault()
--> do_user_addr_fault()

--> handle_mm_fault()

--> __handle_mm_fault()
```

```text
fixup_user_fault()

--> handle_mm_fault()

--> __handle_mm_fault()
```
