# Navigation

In general, you want to spend as little of your time in vim's insert mode as
possible, because in the mode it acts like a dumb editor. This is why most vim
novices spend so much time in insert mode -- it makes vim easy to use. But
vim's real power lies in command line! You'll find that the better you know
vim, the less time you will spend in insert mode

## HJKL

h: left

j: down

k: up

l: right

## Motions

`f{x}`: move the cursor `f`orward to the next occurrence of x on the current
line. 

`t{x}`: same as above, but moves the cursor to right before the character.

`F{x}:  backward

`w`: move forward by a word (punctuation considered words)

`b`: same as `w` but backward

`W`: same as `w` (but spaces separated words)

`B`: same as `b` (but spaces separated words)

`e`: same as `w` but to the end of word

`E`: same as `e` (but space separated words)

`0`: move to the beginning of the current line

`^`: move to the first character on the current line (spaces excluded)

`$`: move to the end of the line

`)`: move forward to the next sentence

`(`: same as `)` but backward

## Move in file

`<C-F>`: move forward by a screenful of text

`<C-B>`: move backward by a screenful of text

`G`: move to the end of file

`{n}G`: not identical to {count}G, this move the cursor to the `{n}`th line

`gg`: move to the beginning of the file

`H`: move to the top of the screen

`M`: move to the middle of the screen

`L`: move the bottom of the screen

``*``: move

`#`: same as above, except it moves the cursor to the previous occurance

`/{text}`: search

`?{text}`: same as `/{text}`, but in opposite direction

## Bookmark

`m{x}`: make a bookmark named `{x}` at current cursor positiongo to the line
that you last edit

``{x}`: go to bookmark named `{x}`

``.`: go to the line that you last edit
