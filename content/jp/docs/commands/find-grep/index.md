---
title: "find and grep"
draft: false
weight: 60
---
## Source Code Reading with find + grep

```sh
find . -type f \( -name '*.c' -o -name '*.h' \) -print0 | xargs -0 grep -C 3 -Hni 'root_hpa'
```
