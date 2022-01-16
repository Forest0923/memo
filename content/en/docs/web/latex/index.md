---
title: "Expressions like LaTeX"
draft: false
weight: 20
---

# Beautiful Mathmatical Expressions

## **MathJax**

[MathJax](https://www.mathjax.org/) is a library for displaying beautiful mathematical expressions like LaTeX. To use it, you need to add the following code.

```html
<script src="https://polyfill.io/v3/polyfill.min.js?features=es6"></script>
<script id="MathJax-script" async src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js"></script>
```

Expressions can be written by enclosing them with `\[\]`, `\begin{align}\end{align}` or etc.

Examples:

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

Inline expressions can be written by enclosing the expression with `$` or `\(\)`.

If you need numbering for expressions, you can add a script like the following to automatically number the expressions.

```html
<script type="text/x-mathjax-config">
MathJax.Hub.Config({
TeX: { equationNumbers: { autoNumber: "all" } }
});
</script>
```

## **KaTeX**

[KaTeX](https://katex.org/) is a library that provides the same functionality as MathJax, but with a special emphasis on speed. To use it, you need to add the following tags.


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
