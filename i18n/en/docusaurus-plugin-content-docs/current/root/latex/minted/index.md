---
title: "Using minted for Syntax Highlighting"
draft: false
weight: 40
---
## About

minted is a package that enable to add syntax highlight by using Pygments library.

## Installation

Pygments is written in Python and can be installed by pip

```sh
pip install Pygments
```

Package minted is already installed if you use texlive.

## Usage

At the preamble add some commands as follows.

```tex
\usepackage[cache=false]{minted}
\usepackage{xcolor}

\definecolor{code-bg}{rgb}{0.95, 0.95, 0.95}
```

You can then use syntax highlighting in your document as follows.

```tex
\begin{minted}[breaklines, linenos, frame=lines, bgcolor=code-bg]{c}
#include <stdio.h>
int main(){
    printf("Hello, World!");
}
\end{minted}
```

Otherwise, you can use `\inputminted` to include source files.

```tex
\inputminted[breaklines, linenos, frame=lines, bgcolor=code-bg]{python}{src/hello.py}
```

There are several options for configuring the code visuals.

|Option|Description|
|:--|:--|
|breaklines | Insert break when source code exceeds page width.|
|linenos | Add line numbers.|
|frame=lines | Add frame (line, single, ...).|
|bgcolor=code-bg | Add background color.|
