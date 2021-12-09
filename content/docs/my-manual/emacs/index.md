---
title: "Configuration of Emacs"
description: ""
lead: ""
date: 2021-11-29T12:39:11+09:00
lastmod: 2021-11-29T12:39:11+09:00
draft: false
images: []
menu: 
  docs:
    parent: "my-manual"
weight: 100
toc: true
---

## No-window-system mode

- Emacs can be run in the terminal by `emacs -nw`.
- However you got error message `Fontset ‘tty’ does not exist`, if you changed font for GUI.

## How to resolve the problem

- Add the following command.

```lisp
(if (display-graphic-p)
  (progn
    (set-face-attribute 'default nil
                        :family "Ricty Diminished Discord")
    (set-fontset-font (frame-parameter nil 'font)
                      'japanese-jisx0208
                      (cons "Ricty Diminished Discord" "iso10646-1"))
    (set-fontset-font (frame-parameter nil 'font)
                      'japanese-jisx0212
                      (cons "Ricty Diminished Discord" "iso10646-1"))
    (set-fontset-font (frame-parameter nil 'font)
                      'katakana-jisx0201
                      (cons "Ricty Diminished Discord" "iso10646-1")))
)
```

- `display-graphic-p` means:

> This function returns t if display is a graphic display capable of displaying several frames and several different fonts at once. This is true for displays that use a window system such as X, and false for text terminals.
>
> --- https://www.gnu.org/software/emacs/manual/html_node/elisp/Display-Feature-Testing.html
