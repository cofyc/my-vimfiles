# Align

## shortcuts

```
<leader>t=
<leader>t
<leader>tsp # space
...
```

## align on provided separator

a=ok=
bb=wrong

```
:Align =
```

or 

```
:Tab /=
```

## align table markup

|start|eat|left|
|12|5|7|

```
:Tab /|
```

## don't align first separator

a=b=
bb=ccc

->

a=   b=
bb=  ccc

```
:Tab /=\zs
```

## align on first separator only

a=b=
bb=ccc

->

a  = b=
ab = ccc

```
AlignCtrl lp1P1:
Align =
```

or

```
Align! lp1P1: =
```

or

```
<leader>tf=
<leader>tf>=
<leader>tf:
```

## align end of line comments

```
:Tab /\/\/ # align `//` comments
:Tab /\/\* # align `/*` comments
:Tab /# # align `#` comments
```

## align on nth separator

```
# vim-easy-align
<Enter>2<Space> # 2nd
<Enter>*<Space> # all
<Enter>-<Space> # last
<Enter>-2<Space> # the second to the last
```

## Plugins

- tabular
  - http://vimcasts.org/episodes/aligning-text-with-tabular-vim/.
  - format: `:Tab /<pattern>`
- Align
  - http://www.drchip.org/astronaut/vim/align.html#Examples for Align examples.
  - http://www.vim.org/scripts/script.php?script_id=294 for Align usage.
- vim-easy-align: https://github.com/junegunn/vim-easy-align
