# Search Replace

## case sensitivity

```vim
/\ccopyright # case insensitive
/\Ccopyright # case sensitive
```

See http://stackoverflow.com/a/2287449/288089.

## Disable search highlights

```vim
:nohl
```

## Substituting patterns with a corresponding case-sensitive text

Use [keepcase](http://www.vim.org/scripts/script.php?script_id=6)

```text
Hello hello helLo HELLO
```

do with

```vim
:'<,'>SubstituteCase/\chello/goodbye/g
```

## Substitution all case variants

```
facility
FACILITY
```

:%S/facility/building/g

## Disable magic (regex, etc)

```
:%sno/raw_search_string/raw_replace_string/g
```

## References

- http://vim.wikia.com/wiki/Search_and_replace
- https://github.com/tpope/vim-abolish
