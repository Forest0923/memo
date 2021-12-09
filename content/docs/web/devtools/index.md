---
title: "Web Development"
description: ""
lead: ""
date: 2021-11-29T14:59:47+09:00
lastmod: 2021-11-29T14:59:47+09:00
draft: false
images: []
menu: 
  docs:
    parent: "web"
weight: 10
toc: true
---

## Use Gist

- Copy script tag from up right of the Gist.
- Paste script tag in the `body`.

## Use `prism.js`

- [`prism.js`](https://prismjs.com/) is a syntax highlighter written in js.
- Add the following code in the `head`.

```html
<link href='https://cdnjs.cloudflare.com/ajax/libs/prism/1.17.1/themes/prism-twilight.min.css' rel='stylesheet'/>
<link href='https://cdnjs.cloudflare.com/ajax/libs/prism/1.17.1/plugins/line-numbers/prism-line-numbers.min.css' rel='stylesheet'/>
```

- Additionally, insert following code in the `body`.

```html
<script src='https://cdnjs.cloudflare.com/ajax/libs/prism/1.17.1/prism.min.js'/>
<script src='https://cdnjs.cloudflare.com/ajax/libs/prism/1.17.1/plugins/autoloader/prism-autoloader.min.js'/>
<script src='https://cdnjs.cloudflare.com/ajax/libs/prism/1.17.1/plugins/line-numbers/prism-line-numbers.min.js'/>
```

- Example:

```html
<pre class="line-numbers"><code class="language-c">#include &lt;stdio.h&gt;
int main(){
  printf("Hello, World!\n");
}</code></pre>
```

## About

- It is easy to add MathJax to your web site.
- All you have to do is add following script tag in the body tag.

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
