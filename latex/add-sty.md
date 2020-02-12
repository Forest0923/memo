---
title: Using original style file
date: 2020-02-12
---

## Create style file (~.sty)
### Create new command
- `\newcomand` and `\renewcommand` allow you to define new command.
- Usage:
```
\newcommand{\command-name}[argument-number][default]{definition}
\renewcommand{\command-name}[argument-number][default]{definition}
```

- Example:
```
\newcommand{\myfig}[4][width=5cm]{
  \begin{figure}[H]
    \centering
    \includegraphics[#1]{#2}
    \caption{#3}
    \label{fig:#4}
  \end{figure}
}
```

### Create new environment
- `\newenvironment` and `\renewenvironment` allow you to define new environment.
- Usage:
```
\newenvironment{environment-name}[argument-number][default]{before}{after}
\renewenvironment{environment-name}[argument-number][default]{before}{after}
```

- Example:
```
\definecolor{code-bg}{rgb}{0.95, 0.95, 0.95}

\newenvironment{code}[2][]
{\VerbatimEnvironment\begin{minted}[breaklines, frame=lines, bgcolor=code-bg, #1]{#2}}
{\end{minted}}
```

## Add style files
- Put your file under `/usr/local/share/texmf/tex/latex` and execute `mktexlsr` as a root user.
```
username@ubuntu:/usr/local/share/texmf/tex/latex/mypkg
$ sudo mktexlsr
```

## Tip: Where to put the files
You can get the path of texmf.conf like this.

```
$ kpsewhich -all texmf.cnf 
/etc/texmf/web2c/texmf.cnf
/usr/share/texmf/web2c/texmf.cnf
/usr/share/texlive/texmf-dist/web2c/texmf.cnf
```

When you look inside the file, you will found the following description.

```
...
73 % Local additions to the distribution trees.
74 TEXMFLOCAL = /usr/local/share/texmf
...
232 % p(La)TeX.
233 TEXINPUTS.ptex          = .;$TEXMF/tex/{ptex,plain,generic,}//
234 TEXINPUTS.platex        = .;$TEXMF/tex/{platex,latex,generic,}//  
...
```

According to these descriptions you can get a correct position.
