---
title: "LaTeX Cheat Sheet"
draft: false
weight: 20
katex: true
---
## Expressions

### **Expression Number**

If you need an expression number:

{{< columns >}}

```tex
\begin{eqnarray}
  y=\alpha x + \beta
\end{eqnarray}
```

$$
  y=\alpha x + \beta
  \tag{1}
$$

{{< /columns >}}

If you do not need an expression number:

{{< columns >}}

```tex
\[
  y=\alpha x + \beta
\]
```

$$
  y=\alpha x + \beta
$$

{{< /columns >}}

### **Align Equations**

Use \& to align multiple equations at equal positions.

{{< columns >}}

```tex
\[
  a&=b+c \\
  d+e&=f
\]
```

$$
\begin{aligned}
  a&=b+c \\\
  d+e&=f
\end{aligned}
$$

{{< /columns >}}

{{< columns >}}

```tex
\begin{eqnarray}
  a&=b+c \\
  d+e&=f
\end{eqnarray}
```

$$
\begin{aligned}
  a&=b+c \\\
  d+e&=f
\end{aligned}
$$

{{< /columns >}}

### **Simultaneous Equations**

{{< columns >}}

```tex
\begin{eqnarray}
  \begin{cases}
    (x - 2)^2 + y^2 + z^2 = 1\\
    x + z = 3
  \end{cases}
\end{eqnarray}
```

$$
\begin{cases}
   \left(x - 2\right)^2 + y^2 + z^2 = 1\\\
    x + z = 3
\end{cases}
$$

{{< /columns >}}

{{< columns >}}

```tex
\begin{numcases}
  {}
  (x - 2)^2 + y^2 + z^2 = 1\\
  x + z = 3
\end{numcases}
```

$$
\begin{cases}
   \left(x - 2\right)^2 + y^2 + z^2 = 1\\\
    x + z = 3
\end{cases}
$$

{{< /columns >}}

### **Matrix**

{{< columns >}}

```tex
\begin{eqnarray}
  \left(
  \begin{array}{cc}
    a & b \\
    c & d
  \end{array}
  \right)
\end{eqnarray}
```

$$
\begin{pmatrix}
   a & b \\\
   c & d
\end{pmatrix}
$$

{{< /columns >}}

## Source Code

### **minted**

To write code directly in a tex file, use minted.

```tex
\begin{minted}[linenos, breaklines, frame=lines]{c}
#include <stdio.h>
int main(){
  printf("Hello, World!");
  return 0;
}
\end{minted}
```

Use inputminted to specify a file and put the source code in it.

```tex
\inputminted[linenos, breaklines, frame=lines]{language}{src/hello.c}
```

## Figure

This is an example of inserting a single image. In the example below, the package here is used to insert the image at the specified position. (`\usepackage{here}`)

```tex
\begin{figure}[H]
  \centering
  \includegraphics[width=10cm]{path2image}
  \caption{hoge}
  \label{fig1}
\end{figure}
```

## Table

The table can be written as follows, but it is easier to create it automatically using [Table generator](https://www.tablesgenerator.com/).

```tex
\begin{table}[H]
  \centering
  \caption{title}
  \label{tbl:1}
  \begin{tabular}{ccc}
    \hline
    e1 & e2 & e3 \\
    \hline
    11 & 12 & 13 \\
    21 & 22 & 23 \\
    31 & 32 & 33 \\
    \hline
  \end{tabular}
\end{table}
```

## Footnote

```tex
\footnote[number]{text}
```

## Special Characters and Operators

### **Σ**

{{< columns >}}

```latex
\sum_{\alpha=0}^{\beta}
```

$$\sum_{\alpha=0}^{\beta}$$

{{< /columns >}}

### **∫**

{{< columns >}}

```latex
\int_{\alpha}^{\beta}
```

$$
\int_{\alpha}^{\beta}
$$

{{< /columns >}}

### **lim**

{{< columns >}}

```latex
\lim_{n \to \infty}
```

$$
\lim_{n \to \infty}
$$

{{< /columns >}}

### **≠**

{{< columns >}}

```latex
\neq
```

$$
\neq
$$

{{< /columns >}}

### **≈**

{{< columns >}}

```latex
\approx
```



$$
\approx
$$

{{< /columns >}}

### **≒**

{{< columns >}}

```latex
\fallingdotseq
```



$$
\fallingdotseq
$$

{{< /columns >}}

### **≡**

{{< columns >}}

```latex
\equiv
```



$$
\equiv
$$

{{< /columns >}}

### **>**

{{< columns >}}

```latex
\geq
```



$$
\geq
$$

{{< /columns >}}

### **<**

{{< columns >}}

```latex
\leq
```



$$
\leq
$$

{{< /columns >}}

### **≧**

{{< columns >}}

```latex
\geqq
```



$$
\geqq
$$

{{< /columns >}}

### **≦**

{{< columns >}}

```latex
\leqq
```



$$
\leqq
$$

{{< /columns >}}

### **×**

{{< columns >}}

```latex
\times
```



$$
\times
$$

{{< /columns >}}

### **÷**

{{< columns >}}

```latex
\div
```



$$
\div
$$

{{< /columns >}}

### **±**

{{< columns >}}

```latex
\pm
```



$$
\pm
$$

{{< /columns >}}

### **∈**

{{< columns >}}

```latex
\in
```



$$
\in
$$

{{< /columns >}}

### **⊂**

{{< columns >}}

```latex
\subset
```



$$
\subset
$$

{{< /columns >}}

### **∩**

{{< columns >}}

```latex
\cap
```



$$
\cap
$$

{{< /columns >}}

### **∪**

{{< columns >}}

```latex
\cup
```



$$
\cup
$$

{{< /columns >}}

### **Null Set ∅**

{{< columns >}}

```latex
\emptyset
```



$$
\emptyset
$$

{{< /columns >}}

### **∞**

{{< columns >}}

```latex
\infty
```



$$
\infty
$$

{{< /columns >}}

### **Vector**

{{< columns >}}

```latex
\vec{a}
```



$$
\vec{a}
$$

{{< /columns >}}

{{< columns >}}

```latex
\bm{a}
```



$$
\bm{a}
$$

{{< /columns >}}

### **Partial, Del, ∂**

{{< columns >}}

```latex
\partial
```



$$
\partial
$$

{{< /columns >}}
