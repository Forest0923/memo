---
title: "LaTeX Cheat Sheet"
draft: false
weight: 20
katex: true
---
## Expressions

### **Expression Number**

If you need an expression number:

```tex
\begin{eqnarray}
  y=\alpha x + \beta
\end{eqnarray}
```

$$
  y=\alpha x + \beta
  \tag{1}
$$

If you do not need an expression number:

```tex
\[
  y=\alpha x + \beta
\]
```

$$
  y=\alpha x + \beta
$$

### **Align Equations**

Use \& to align multiple equations at equal positions.

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

### **Simultaneous Equations**

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

### **Matrix**

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

```latex
\sum_{\alpha=0}^{\beta}
```

$$\sum_{\alpha=0}^{\beta}$$

### **∫**

```latex
\int_{\alpha}^{\beta}
```

$$
\int_{\alpha}^{\beta}
$$

### **lim**

```latex
\lim_{n \to \infty}
```

$$
\lim_{n \to \infty}
$$

### **≠**

```latex
\neq
```

$$
\neq
$$

### **≈**

```latex
\approx
```



$$
\approx
$$

### **≒**

```latex
\fallingdotseq
```

$$
\fallingdotseq
$$

### **≡**

```latex
\equiv
```

$$
\equiv
$$

### **>**

```latex
\gt
```

$$
\gt
$$

### **\<**

```latex
\lt
```

$$
\lt
$$

### **≧**

```latex
\geq
\geqq
```

$$
\geq\\
\geqq
$$

### **≦**

```latex
\leq
\leqq
```

$$
\leq\\
\leqq
$$

### **×**

```latex
\times
```



$$
\times
$$

### **÷**

```latex
\div
```



$$
\div
$$

### **±**

```latex
\pm
```



$$
\pm
$$

### **∈**

```latex
\in
```



$$
\in
$$

### **⊂**

```latex
\subset
```

$$
\subset
$$

### **∩**

```latex
\cap
```

$$
\cap
$$

### **∪**

```latex
\cup
```

$$
\cup
$$

### **Null Set ∅**

```latex
\emptyset
```

$$
\emptyset
$$

### **∞**

```latex
\infty
```

$$
\infty
$$

### **Vector**

```latex
\vec{a}
```

$$
\vec{a}
$$

```latex
\bm{a}
```

$$
\bm{a}
$$

### **Partial, Del, ∂**

```latex
\partial
```

$$
\partial
$$
