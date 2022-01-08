---
title: "きれいな数式の表示"
draft: false
weight: 20
---

# きれいな数式の表示

## **MathJax**

[MathJax](https://www.mathjax.org/) は LaTeX のようなきれいな数式を表示するためのライブラリです．使用する場合は以下のタグを読み込む必要があります．

```html
<script src="https://polyfill.io/v3/polyfill.min.js?features=es6"></script>
<script id="MathJax-script" async src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js"></script>
```

数式は `\[\]` や `\begin{align}\end{align}` などで囲むことで書くことができます．

```latex
\[a^2 + b^2 = c^2\]
```

or

```latex
\begin{align}
1 &= e^{i\theta}e^{-i\theta}\\
  &= \left(\cos{\theta}+i\sin{\theta}\right) \left(\cos{\theta}-i\sin{\theta}\right)\\
  &= \sin^2{\theta}+\cos^2{\theta}
\end{align}
```

インラインの数式は `$` や `\(\)` を使うことで表現できます．

数式に番号が必要な場合は以下のようなスクリプトを追加すると自動で番号がつけられます．

```html
<script type="text/x-mathjax-config">
MathJax.Hub.Config({
TeX: { equationNumbers: { autoNumber: "all" } }
});
</script>
```

## **KaTeX**

[KaTeX](https://katex.org/) は MathJax と同様の機能を提供するライブラリですが，特に速度に重きをおいています．使用するためには以下のタグを読み込む必要があります．

```html
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.15.1/dist/katex.min.css" integrity="sha384-R4558gYOUz8mP9YWpZJjofhk+zx0AS11p36HnD2ZKj/6JR5z27gSSULCNHIRReVs" crossorigin="anonymous">
<script defer src="https://cdn.jsdelivr.net/npm/katex@0.15.1/dist/katex.min.js" integrity="sha384-z1fJDqw8ZApjGO3/unPWUPsIymfsJmyrDVWC8Tv/a1HeOtGmkwNd/7xUS0Xcnvsx" crossorigin="anonymous"></script>
<script defer src="https://cdn.jsdelivr.net/npm/katex@0.15.1/dist/contrib/auto-render.min.js" integrity="sha384-+XBljXPPiv+OzfbB3cVmLHf4hdUFHlWNZN5spNQ7rmHTXpd7WvJum6fIACpNNfIR" crossorigin="anonymous"></script>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        renderMathInElement(document.body, {
          // customised options
          // • auto-render specific keys, e.g.:
          delimiters: [
              {left: '$$', right: '$$', display: true},
              {left: '$', right: '$', display: false},
              {left: '\\(', right: '\\)', display: false},
              {left: '\\[', right: '\\]', display: true}
          ],
          // • rendering keys, e.g.:
          throwOnError : false
        });
    });
</script>
```
