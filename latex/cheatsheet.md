---
title: Cheat sheet
date: 2020-02-12
---

## Expression
### Expression numbers

- If you need expression numbers:

```
\begin{eqnarray}
  y=\alpha x + \beta
\end{eqnarray}
```

- If you don't need expression numbers:

```
\[
  y=\alpha x + \beta
\]
```

### To align equivalents, use:

```
\[
  \cos 2 \alpha &=& \cos^2 \alpha - \sin^2 \alpha\\
  &=& 2 \cos^2 \alpha - 1\\
  &=& 1 - 2 \sin^2 \alpha
\]

% or

\begin{eqnarray}
  \cos 2 \alpha &=& \cos^2 \alpha - \sin^2 \alpha\\
  &=& 2 \cos^2 \alpha - 1\\
  &=& 1 - 2 \sin^2 \alpha
\end{eqnarray}
```

### Simultaneous equations:

```
\begin{eqnarray}
  \begin{cases}
    \left(x_1 - 2\right)^2 + x_2^2 + x_3^2 = 1\\
    x_1 + x_3 = 3
  \end{cases}
\end{eqnarray}

% or

\begin{numcases}
  {}
  \left(x_1 - 2\right)^2 + x_2^2 + x_3^2 = 1\\
  x_1 + x_3 = 3
\end{numcases}
```

### Matrix:

```
\begin{eqnarray}
\left(
\begin{array}{ccccc}
a_{11} & \cdots & a_{1i} & \cdots & a_{1n}\\
\vdots & \ddots &        &        & \vdots \\
a_{i1} &        & a_{ii} &        & a_{in} \\
\vdots &        &        & \ddots & \vdots \\
a_{n1} & \cdots & a_{ni} & \cdots & a_{nn}
\end{array}
\right)
\end{eqnarray}
```

## Source code
- minted

```
\begin{minted}[linenos, breaklines, frame=lines]{c}
#include <stdio.h>
int main(){
  printf("Hello, World!");
  return 0;
}
\end{minted}

%or

\inputminted[linenos, breaklines, frame=lines]{language}{src/hello.c}
```

## Figures

```
% Command written below need `\usepackage{here}`
\begin{figure}[H]
  \centering
  \includegraphics[width=10cm]{path2image}
  \caption{hoge}
  \label{fig1}
\end{figure}
```

## Table

```
% Command written below need `\usepackage{here}`
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

```
\footnote[number]{text}
```