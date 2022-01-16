---
title: "シンタックスハイライト"
draft: false
weight: 10
---

# シンタックスハイライト

ソースコードをハイライト付きで掲載する方法について．

## **Gist**

GitHub Gist を用いると Script タグを貼り付けるだけでソースコードを載せることができます．
Gist のリポジトリの右上にあるタグをコピーして body に貼り付けるとソースコードが挿入されます．

```html
<script src="https://gist.github.com/Forest0923/dad279ab557ae30bc51e4a9d8cf5bd7d.js"></script>
```

<script src="https://gist.github.com/Forest0923/dad279ab557ae30bc51e4a9d8cf5bd7d.js"></script>

## **prism.js**

[prism.js](https://prismjs.com/) は JavaScript で実装されたシンタックスハイライトツールです．prism.js を使うためには，まず以下のスクリプトタグを head に追加します．

```html
<link href='https://cdnjs.cloudflare.com/ajax/libs/prism/1.17.1/themes/prism-twilight.min.css' rel='stylesheet'/>
<link href='https://cdnjs.cloudflare.com/ajax/libs/prism/1.17.1/plugins/line-numbers/prism-line-numbers.min.css' rel='stylesheet'/>
```

次に以下のタグを body に追加します．

```html
<script src='https://cdnjs.cloudflare.com/ajax/libs/prism/1.17.1/prism.min.js'/>
<script src='https://cdnjs.cloudflare.com/ajax/libs/prism/1.17.1/plugins/autoloader/prism-autoloader.min.js'/>
<script src='https://cdnjs.cloudflare.com/ajax/libs/prism/1.17.1/plugins/line-numbers/prism-line-numbers.min.js'/>
```

以下のように書くことでハイライト付きのコードが表示されます．

```html
<pre class="line-numbers"><code class="language-c">#include &lt;stdio.h&gt;
int main(){
  printf("Hello, World!\n");
}</code></pre>
```
