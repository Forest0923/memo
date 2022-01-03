---
title: "minted を使用したシンタックスハイライト"
draft: false
weight: 40
---

# minted を使用したシンタックスハイライト

minted は Python 製の Pygments ライブラリを用いたシンタックスハイライティングを行うパッケージです．

## インストール

Pygments は Python 製のライブラリで pip を使ってインストールできます．

```sh
pip3 install Pygments
```

minted は TeX Live に含まれているので新たな sty などは不要です．

## 使い方

プリアンブルに次の内容を追加します．

```tex
\usepackage[cache=false]{minted}
\usepackage{xcolor}

\definecolor{code-bg}{rgb}{0.95, 0.95, 0.95}
```

ドキュメント内で次のように minted を使うことでハイライトされます．

```tex
\begin{minted}[breaklines, linenos, frame=lines, bgcolor=code-bg]{c}
#include <stdio.h>
int main(){
    printf("Hello, World!");
}
\end{minted}
```

ファイルをインポートする場合は `\inputminted` を使います．

```tex
\inputminted[breaklines, linenos, frame=lines, bgcolor=code-bg]{python}{src/hello.py}
```

複数のオプションがありますが，下のような意味があります．

|Option|Description|
|:--|:--|
|breaklines | ページ幅よりもコードが長いときに自動で改行する |
|linenos | コード行数を表示する |
|frame=lines | フレームを追加する |
|bgcolor=code-bg | 背景色を追加する |
