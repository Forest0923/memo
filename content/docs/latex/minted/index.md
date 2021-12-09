---
title: "Using minted for Syntax highlighting"
description: ""
lead: ""
date: 2021-11-29T14:59:27+09:00
lastmod: 2021-11-29T14:59:27+09:00
draft: false
images: []
menu: 
  docs:
    parent: "latex"
weight: 40
toc: true
---

## About

- minted is a package that enable to add syntax highlight by using Pygments library.

## Installation

- Pygments is written in Python and can be installed by pip

```sh
pip install Pygments
```

- Package minted is already installed if you use texlive.

## Usage

- At the preamble add:

```tex
\usepackage[cache=false]{minted}
\usepackage{xcolor}

\definecolor{code-bg}{rgb}{0.95, 0.95, 0.95}
```

- In the document, you can use syntax highlight like this:

```tex
\begin{minted}[breaklines, linenos, frame=lines, bgcolor=code-bg]{c}
#include <stdio.h>
int main(){
    printf("Hello, World!");
}
\end{minted}
```

- You can include source files by using `\inputminted`:

```tex
\inputminted[breaklines, linenos, frame=lines, bgcolor=code-bg]{python}{src/hello.py}
```

- Options:

|Option|Description|
|:--|:--|
|breaklines | Insert break when source code exceeds page width.|
|linenos | Add line numbers.|
|frame=lines | Add frame (line, single, ...).|
|bgcolor=code-bg | Add background color.|
