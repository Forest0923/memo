---
title: "nkf"
draft: false
weight: 20
---
## Install

{{< tabpane >}}
{{< tab header="Arch" lang="sh" >}}

paru -S nkf

{{< /tab >}}
{{< tab header="Ubuntu" lang="sh" >}}

sudo apt install nkf

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