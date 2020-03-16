# Navigation

In general, you want to spend as little of your time in vim's insert mode as
possible, because in the mode it acts like a dumb editor. This is why most vim
novices spend so much time in insert mode -- it makes vim easy to use. But
vim's real power lies in command line! You'll find that the better you know
vim, the less time you will spend in insert mode

## Use h, j, k, and l

h: left

j: down

k: up

l: right

## Use motions to move the cursor in the current line

`f{x}`: move the cursor forward to the next occurrence of x on the current
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

## Move efficiently through the file

vim has many commands that can send you to where you want to go in your file --
there's rarely a need to scroll manually through it. The below keystrokes are
not technically motions, since they move around in the file instead of in a
particular line.

`<c-f>`: jump forward by a screenful of text

`<c-b>`: jump backward by a screenful of text

`<c-d>`: jump forward (down) a half screen

`<c-u>`: jump backward (up) a half screen

`<c-y>`: move forward (down) a line

`<c-e>`: move backward (up) a line

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

`m{x}`: make a bookmark named `{x}` at current cursor positiongo to the line
that you last edit

`\`{x}`: go to bookmark named `{x}`

`\`.`: go to the line that you last edit

## Jump

`<C-O>`: go to older cursor position in jump list
`<C-I>`: go to newer cursor position in jump list

## Navigating files

`Explore`

`Sexplore` - horizontal split

  Press '%' to create new file in explore window.

`Vexplore` - vertical split

`CTRL-^`   - Edit the alternate file.  Mostly the alternate file is
          the previously edited file.  This is a quick way to
          toggle between two files.

## References

- http://robertames.com/files/vim-editing.html
- `:help navigation`
