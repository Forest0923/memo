---
title: "Syntax Highlighting"
draft: false
weight: 10
---

# Syntax Highlighting

How to post the source code with syntax highlighting.

## **Gist**

Using GitHub Gist, you can put the source code by simply pasting Script tags.
Copy the tag in the upper right corner of the Gist repository and paste it into the body to insert the source code.

```html
<script src="https://gist.github.com/Forest0923/dad279ab557ae30bc51e4a9d8cf5bd7d.js"></script>
```

<script src="https://gist.github.com/Forest0923/dad279ab557ae30bc51e4a9d8cf5bd7d.js"></script>

## **prism.js**

[prism.js](https://prismjs.com/) is a syntax highlighting tool implemented in JavaScript. To use prism.js, add the following script tag to the head.

```html
<link href='https://cdnjs.cloudflare.com/ajax/libs/prism/1.17.1/themes/prism-twilight.min.css' rel='stylesheet'/>
<link href='https://cdnjs.cloudflare.com/ajax/libs/prism/1.17.1/plugins/line-numbers/prism-line-numbers.min.css' rel='stylesheet'/>
```

Additionally, insert following code in the body.

```html
<script src='https://cdnjs.cloudflare.com/ajax/libs/prism/1.17.1/prism.min.js'/>
<script src='https://cdnjs.cloudflare.com/ajax/libs/prism/1.17.1/plugins/autoloader/prism-autoloader.min.js'/>
<script src='https://cdnjs.cloudflare.com/ajax/libs/prism/1.17.1/plugins/line-numbers/prism-line-numbers.min.js'/>
```

You can display the highlighted code by writing as follows.

```html
<pre class="line-numbers"><code class="language-c">#include &lt;stdio.h&gt;
int main(){
  printf("Hello, World!\n");
}</code></pre>
```
