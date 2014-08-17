# File Formats

First of all, all newline are stored as <CR>(\r) char in VIM buffer.

EOL in three formats:

unix: `<NL>`
docs: `<CR><NL>`
mac: `<CR>`

In VIM buffer, EOL chars in current format are all converted to '\n'.

Show current file format:

```
:echo &fileformat
```

## Chars

#### `<CR>`

name: Carriage Return
display in VIM: `^M`
literal char in c: '\r'

#### `<NL>`

name: newline char in unix format
display in VIM: not showed
notes: use '\r' to match <NL> in vim replacement pattern, '\n' stands for <Nul>
char, but if you want to search <NL>, you need to use '\n'.

`s/\n/\n/g`: replace <NL> with <Nul>
`s/\n/\r/g': replace <NL> with <NL> itself

#### `<Nul>`:

name: NULL character
display in VIM: ^@
literal char in c: '\0'
notes: '\0' in files are stored as <NL> in VIM buffer.

## Converting

1. dos -> unix

```
:edit ++ff=unix # don't treat `<CR>` as part of EOL
:w
:%s/\r//gc # remove `<CR>` from file
```

2. unix to dos

```
:edit ++ff=dos
:w
```

## References

- http://stackoverflow.com/questions/350661/vim-n-vs-r
- http://vimdoc.sourceforge.net/htmldoc/usr_23.html#23.1
