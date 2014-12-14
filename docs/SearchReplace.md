# Search Replace

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

## References

- http://vim.wikia.com/wiki/Search_and_replace
