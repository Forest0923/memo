---
title: MathJax
date: 2020-02-12
---

## MathJax
- It is easy to add MathJax to your blog.
- All you have todo is add following script tag in the body tag.

```html
<script src="https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.5/latest.js?config=TeX-MML-AM_CHTML" async></script>
```

## Usage
- General:

```latex
\[a^2 + b^2 = c^2\]

% or

\begin{align}
1 &= e^{i\theta}e^{-i\theta}\\
  &= \left(\cos{\theta}+i\sin{\theta}\right) \left(\cos{\theta}-i\sin{\theta}\right)\\
  &= \sin^2{\theta}+\cos^2{\theta}
\end{align}
```

- Inline: `\(y = \alpha x + \beta\)`

- If you need formula numbers add this script in the body tag.

```html
<script type="text/x-mathjax-config">
MathJax.Hub.Config({
TeX: { equationNumbers: { autoNumber: "all" } }
});
</script>
```
