---
title: "LaTeX Cheat Sheet"
draft: false
weight: 20
katex: true
---
## 数式

### **式番号**

式番号が必要な場合：

{{< columns >}}

```tex
\begin{eqnarray}
  y=\alpha x + \beta
\end{eqnarray}
```

<---></br>

$$
  y=\alpha x + \beta
  \tag{1}
$$

{{< /columns >}}

式番号が必要ない場合：

{{< columns >}}

```tex
\[
  y=\alpha x + \beta
\]
```

<---></br>

$$
  y=\alpha x + \beta
$$

{{< /columns >}}

### **数式を揃える**

イコールの位置で複数の数式を揃える場合は \& を使います．

{{< columns >}}

```tex
\[
  a&=b+c \\
  d+e&=f
\]
```

<---></br>

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

<---></br>

$$
\begin{aligned}
  a&=b+c \\\
  d+e&=f
\end{aligned}
$$

{{< /columns >}}

### **連立方程式**

{{< columns >}}

```tex
\begin{eqnarray}
  \begin{cases}
    (x - 2)^2 + y^2 + z^2 = 1\\
    x + z = 3
  \end{cases}
\end{eqnarray}
```

<---></br>

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

<---></br>

$$
\begin{cases}
   \left(x - 2\right)^2 + y^2 + z^2 = 1\\\
    x + z = 3
\end{cases}
$$

{{< /columns >}}

### **行列**

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

<---></br></br></br>

$$
\begin{pmatrix}
   a & b \\\
   c & d
\end{pmatrix}
$$

{{< /columns >}}

## ソースコード

### **minted**

tex ファイル内で直接コードを書くときは minted を使います．

```tex
\begin{minted}[linenos, breaklines, frame=lines]{c}
#include <stdio.h>
int main(){
  printf("Hello, World!");
  return 0;
}
\end{minted}
```

ファイルを指定してソースコードを載せるときは inputminted を使います．

```tex
\inputminted[linenos, breaklines, frame=lines]{language}{src/hello.c}
```

## 画像

画像を1枚載せたい場合の例です．下の例では here というパッケージを使用することで指定した位置に画像を挿入しています．（`\usepackage{here}`）

```tex
\begin{figure}[H]
  \centering
  \includegraphics[width=10cm]{path2image}
  \caption{hoge}
  \label{fig1}
\end{figure}
```

## 表

表は次のように書くことができますが，[Table generator](https://www.tablesgenerator.com/)などを使って自動で作成したほうが楽です．

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

## 注釈

```tex
\footnote[number]{text}
```

## 特殊な文字や演算子

### **Σ**

{{< columns >}}

```latex
\sum_{\alpha=0}^{\beta}
```

<--->

$$\sum_{\alpha=0}^{\beta}$$

{{< /columns >}}

### **∫**

{{< columns >}}

```latex
\int_{\alpha}^{\beta}
```

<--->

$$
\int_{\alpha}^{\beta}
$$

{{< /columns >}}

### **lim**

{{< columns >}}

```latex
\lim_{n \to \infty}
```

<--->

$$
\lim_{n \to \infty}
$$

{{< /columns >}}

### **≠**

{{< columns >}}

```latex
\neq
```

<--->

$$
\neq
$$

{{< /columns >}}

### **≈**

{{< columns >}}

```latex
\approx
```

<--->

$$
\approx
$$

{{< /columns >}}

### **≒**

{{< columns >}}

```latex
\fallingdotseq
```

<--->

$$
\fallingdotseq
$$

{{< /columns >}}

### **≡**

{{< columns >}}

```latex
\equiv
```

<--->

$$
\equiv
$$

{{< /columns >}}

### **>**

{{< columns >}}

```latex
\geq
```

<--->

$$
\geq
$$

{{< /columns >}}

### **<**

{{< columns >}}

```latex
\leq
```

<--->

$$
\leq
$$

{{< /columns >}}

### **≧**

{{< columns >}}

```latex
\geqq
```

<--->

$$
\geqq
$$

{{< /columns >}}

### **≦**

{{< columns >}}

```latex
\leqq
```

<--->

$$
\leqq
$$

{{< /columns >}}

### **×**

{{< columns >}}

```latex
\times
```

<--->

$$
\times
$$

{{< /columns >}}

### **÷**

{{< columns >}}

```latex
\div
```

<--->

$$
\div
$$

{{< /columns >}}

### **±**

{{< columns >}}

```latex
\pm
```

<--->

$$
\pm
$$

{{< /columns >}}

### **∈**

{{< columns >}}

```latex
\in
```

<--->

$$
\in
$$

{{< /columns >}}

### **⊂**

{{< columns >}}

```latex
\subset
```

<--->

$$
\subset
$$

{{< /columns >}}

### **∩**

{{< columns >}}

```latex
\cap
```

<--->

$$
\cap
$$

{{< /columns >}}

### **∪**

{{< columns >}}

```latex
\cup
```

<--->

$$
\cup
$$

{{< /columns >}}

### **空集合∅**

{{< columns >}}

```latex
\emptyset
```

<--->

$$
\emptyset
$$

{{< /columns >}}

### **∞**

{{< columns >}}

```latex
\infty
```

<--->

$$
\infty
$$

{{< /columns >}}

### **ベクトル**

{{< columns >}}

```latex
\vec{a}
```

<--->

$$
\vec{a}
$$

{{< /columns >}}

{{< columns >}}

```latex
\bm{a}
```

<--->

$$
\bm{a}
$$

{{< /columns >}}

### **Partial, Del, ∂**

{{< columns >}}

```latex
\partial
```

<--->

$$
\partial
$$

{{< /columns >}}
