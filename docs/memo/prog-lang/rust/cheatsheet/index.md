---
title: "Rust Cheat Sheet"
draft: false
weight: 40
---

## Array

### 最大値・最小値

```rs
let max = array.iter().max().unwrap();
```

```rs
let min = array.iter().min().unwrap();
```

## str, String

### 先頭一致

```rs
assert!("hello, world!".ends_with("h"));
assert!("hello, world!".ends_with("hello"));
```

### 末尾一致

```rs
assert!("hello, world!".ends_with("!"));
assert!("hello, world!".ends_with("world!"));
```
