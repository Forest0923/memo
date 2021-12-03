---
title: "Inline Assembly in Rust"
description: ""
lead: ""
date: 2021-11-29T14:56:40+09:00
lastmod: 2021-11-29T14:56:40+09:00
draft: false
images: []
menu: 
  docs:
    parent: "lang"
weight: 20
toc: true
---

## Inline assembler in rust

### `llvm_asm!()`

- Sample code:

```rust
#![feature(llvm_asm)]
fn main() {
    let i: u64 = 3;
    let j: u64 = 5;
    let o: u64;
    unsafe {
        llvm_asm!("mov $1, $0; add $2, $0;"
                : "=r"(o)
                : "{bx}"(i), "{cx}"(j));
    }
    println!("{}", o);
}
```

- Output:

```text
% rustup run nightly cargo run
   Compiling asm_test v0.1.0 (/home/mori/playground/rust/asm_test)
    Finished dev [unoptimized + debuginfo] target(s) in 0.82s
     Running `target/debug/asm_test`
8
```

### `asm!()`

- Sample code:

```rust
#![feature(asm)]
fn main() {
    let i: u64 = 3;
    let o: u64;
    unsafe {
        asm!(
            "mov {0}, {1}",
            "add {0}, {number}",
            out(reg) o,
            in(reg) i,
            number = const 5,
        );
    }
    println!("{}", o);
}
```

- Output:

```text
% rustup run nightly cargo run
   Compiling llvm_asm_test v0.1.0 (/home/mori/playground/rust/llvm_asm_test)
    Finished dev [unoptimized + debuginfo] target(s) in 0.16s
     Running `target/debug/llvm_asm_test`
8
```

### Output assembly code

- Commands:

```sh
cargo rustc -- --emit asm
# or
rustup run nightly cargo rustc -- --emit asm
cat target/debug/deps/*.s
```

> References
>
> <https://blog.rust-lang.org/inside-rust/2020/06/08/new-inline-asm.html>
>
> <https://doc.rust-lang.org/beta/unstable-book/library-features/asm.html>
