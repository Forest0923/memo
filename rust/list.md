---
title: List in Rust
date: 2020-02-15
---

# list

```rust
use List::{Cons, Nil};

#[derive(Debug)]
enum List {
    Cons(i32, Box<List>),
    Nil,
}

impl List {
    fn create(val: i32) -> List {
        Cons(val, Box::new(Nil))
    }

    fn prepend(self, val: i32) -> List{
        Cons(val, Box::new(self))
    }

    fn len(&self) -> u32 {
        match *self {
            Cons(_, ref tail) => 1 + tail.len(),
            Nil => 0
        }
    }
}

fn main() {
    let mut list = List::create(0);
    list = list.prepend(1);
    list = list.prepend(2);
    list = list.prepend(3);
    list = list.prepend(4);
    list = list.prepend(5);
    let length = list.len();
    println!("length: {}, {:?}", length, list);
}
```