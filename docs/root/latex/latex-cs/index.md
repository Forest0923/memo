---
title: "LaTeX Cheat Sheet"
draft: false
weight: 20
---
## 数式

### **式番号**

式番号が必要な場合：

```tex
\begin{eqnarray}
  y=\alpha x + \beta
\end{eqnarray}
```

$$
  y=\alpha x + \beta
  \tag{1}
$$

式番号が必要ない場合：

```tex
\[
  y=\alpha x + \beta
\]
```

$$
  y=\alpha x + \beta
$$

### **数式を揃える**

イコールの位置で複数の数式を揃える場合は \& を使います．

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

### **連立方程式**

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

### **行列**

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

```latex
\sum_{\alpha=0}^{\beta}
```

$$
\sum_{\alpha=0}^{\beta}
$$

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
\begin{aligned}
\geq\\
\geqq
\end{aligned}
$$

### **≦**

```latex
\leq
\leqq
```

$$
\begin{aligned}
\leq\\
\leqq
\end{aligned}
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

### **空集合∅**

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

### **ベクトル**

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
