---
title: "Source Code Reading with find and grep"
description: ""
lead: ""
date: 2021-11-29T12:37:51+09:00
lastmod: 2021-11-29T12:37:51+09:00
draft: false
images: []
menu: 
  docs:
    parent: "my-manual"
weight: 60
toc: true
---

## Usage

```sh
find . -type f \( -name '*.c' -o -name '*.h' \) -print0 | xargs -0 grep -C 3 -Hni 'root_hpa'
```

## find

## grep
