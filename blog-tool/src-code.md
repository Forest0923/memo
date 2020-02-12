---
title: Add source code to blog
date: 2020-02-12
---

## Use Gist
- Copy script tag from up right of the Gist.
- Paste script tag in the `body`.

> [!WARN]
> If your gist repo has more than one items, all items are pasted!

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
