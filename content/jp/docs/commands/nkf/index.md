---
title: "nkf"
draft: false
weight: 20
---

# nkf

## Install

{{< tabpane "install" >}}
{{< tab "Arch" >}}

```sh
paru -S nkf
```

{{< /tab >}}
{{< tab "Ubuntu" >}}

```sh
sudo apt install nkf
```

{{< /tab >}}
{{< /tabpane >}}

## Usage

- To convert any file to UTF-8 + LF:

```sh
nkf -w -Lu --overwrite input_file
```

- To convert C files in current directory to UTF-8 + LF:

```sh
find . -iname "*.c" -type f -print0 | xargs -0 nkf -w -LF --overwrite
```
