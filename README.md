# Vim

> To me, vi is Zen. To use vi is to practice zen. Every command is a koan. Profound to the user, unintelligible to the uninitiated. You discover truth every time you use it.
> 
> -- reddy@lion.austin.com

## Notes

### Align columns

See table_format.vim.
See http://www.vim.org/scripts/script.php?script_id=294 for Align usage.
See http://www.drchip.org/astronaut/vim/align.html#Examples for Align examples.
See http://vimcasts.org/episodes/aligning-text-with-tabular-vim/.

1. align columns separeted by spaces

```
<leader>tf
```

2. align on something

a=ok=
bb=wrong

```
Align =
```

or 

```
Tab/=
```

3. do not align

```
Tab/:\zs
```

4. table markup

|start|eat|left|
|12|5|7|

```
Tab/|
```

5. align on text

See http://stackoverflow.com/questions/2129519/align-text-only-on-first-separator-in-vim.

a=b=
bb=ccc

->

a=   b=
bb=  ccc

```
tab /=\zs/
```

6. align on first separactor only

a=b=
bb=ccc

->

a  = b=
ab = ccc

```
AlignCtrl lp1P1:
Align =
```

### Hexadecimal Edit

Toggle key: <ctrl-h>

### Regular buffer style command line edit

In normal mode, type `q/`.
In command mode, type `<ctrl-f>`.

<CR> to executes.

### List loaded scripts
  
http://vim.wikia.com/wiki/List_loaded_scripts

## Plugins

See `git submodules` for most plugins.

## References

- Vim documentation: http://vimdoc.sourceforge.net/
- Vim wiki: http://vim.wikia.com/wiki/Category:Getting_started
- Vim structure: http://www.22ideastreet.com/debug/vim-directory-structure/
- A good collection of vim configs: https://github.com/liangxianzhe/dotvim
