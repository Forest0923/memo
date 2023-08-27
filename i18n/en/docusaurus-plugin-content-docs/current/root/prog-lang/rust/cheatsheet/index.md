---
title: "Rust Cheat Sheet"
draft: false
weight: 40
---

## Array

### Maximum/minimum value

```rs
let max = array.iter().max().unwrap();
```

```rs
let min = array.iter().min().unwrap();
```

## str, String

### prefix matching

```rs
assert!("hello, world!".ends_with("h"));
assert!("hello, world!".ends_with("hello"));
```

### suffix matching

```rs
assert!("hello, world!".ends_with("!"));
assert!("hello, world!".ends_with("world!"));
```
