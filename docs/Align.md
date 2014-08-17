# Align

See http://www.vim.org/scripts/script.php?script_id=294 for Align usage.
See http://www.drchip.org/astronaut/vim/align.html#Examples for Align examples.
See http://vimcasts.org/episodes/aligning-text-with-tabular-vim/.

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
Align =
```

or 

```
Tab/=
```

## do not align

```
Tab/:\zs
```

## table markup

|start|eat|left|
|12|5|7|

```
Tab/|
```

## align on text instead of separator

See http://stackoverflow.com/questions/2129519/align-text-only-on-first-separator-in-vim.

a=b=
bb=ccc

->

a=   b=
bb=  ccc

```
tab /=\zs/
```

## align on first separactor only

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
