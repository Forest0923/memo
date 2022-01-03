---
title: "自作の sty ファイルの作り方"
draft: false
weight: 30
---

# 自作の sty ファイルの作り方

## sty ファイルを作成する

### **新しいコマンドの定義**

`\newcomand` と `\renewcommand` を使うことで新しいコマンドを定義することができます．

```tex
\newcommand{\command-name}[argument-number][default]{definition}
\renewcommand{\command-name}[argument-number][default]{definition}
```

例えば画像を載せるときのラッパーを作りたいときは次のように定義することができます．

```tex
\newcommand{\myfig}[4][width=5cm]{
  \begin{figure}[H]
    \centering
    \includegraphics[#1]{#2}
    \caption{#3}
    \label{fig:#4}
  \end{figure}
}
```

### **新しい環境の定義**

`\newenvironment` and `\renewenvironment` を使うことで新しい環境を定義することができます．

```tex
\newenvironment{environment-name}[argument-number][default]{before}{after}
\renewenvironment{environment-name}[argument-number][default]{before}{after}
```

下の例では minted のラッパーとなる code という環境を定義しています

```tex
\definecolor{code-bg}{rgb}{0.95, 0.95, 0.95}

\newenvironment{code}[2][]
{\VerbatimEnvironment\begin{minted}[breaklines, frame=lines, bgcolor=code-bg, #1]{#2}}
{\end{minted}}
```

## sty ファイルの登録

作成した sty ファイルを `/usr/local/share/texmf/tex/latex` に配置し， `mktexlsr` を実行します．

```sh
cd /usr/local/share/texmf/tex/latex
sudo mktexlsr
```
