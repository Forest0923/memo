---
title: "Call Systemcall in Rust"
description: ""
lead: ""
date: 2021-11-29T14:56:54+09:00
lastmod: 2021-11-29T14:56:54+09:00
draft: false
images: []
menu: 
  docs:
    parent: "lang"
weight: 30
toc: true
---

## Use `system-call` crate

- Add a dependency to `Cargo.toml`:

```toml
[dependencies]
system-call="0.1.3"
```

- Sample code:

```rust
#[macro_use]
extern crate syscall;

fn main() {
    let mut pid;
    let cpid;
    let mut val = 0;
    unsafe {
        pid = syscall!(GETPID);
    }
    println!("before:	val is {}, pid is {}", val, pid);
    unsafe {
        cpid = syscall!(FORK);
    }
    if cpid < 0 {
        println!("Fork error");
        return;
    } else if cpid == 0 {
        val += 1;
        unsafe {
            pid = syscall!(GETPID);
        }
        println!("child:	val is {}, pid is {}", val, pid);
        return;
    }
    unsafe {
        pid = syscall!(GETPID);
    }
    println!("parent:	val is {}, pid is {}", val, pid);
}
```

- Output:

```text
% rustup run nightly cargo run
warning: comparison is useless due to type limits
  --> src/main.rs:15:8
   |
15 |     if cpid < 0 {
   |        ^^^^^^^^
   |
   = note: `#[warn(unused_comparisons)]` on by default

warning: 1 warning emitted

    Finished dev [unoptimized + debuginfo] target(s) in 0.01s
     Running `target/debug/syscall_crate_test`
before: val is 0, pid is 3497
parent: val is 0, pid is 3497
child:  val is 1, pid is 3499
```

- Source code of syscall crate is in the `~/.cargo/registry/src/github.com-[hash]/system-call-[version]/`.
