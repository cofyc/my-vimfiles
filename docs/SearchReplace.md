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

## Changing case

In a substitute command, place \U or \L before backreferences for the desired
output. Everything after \U, stopping at \E or \e, is converted to uppercase.
Similarly, everything after \L, stopping at \E or \e, is converted to
lowercase.

Alternatively, use \u to uppercase only the first character of what follows, or
\l to lowercase only the first character.

### Examples

### Lower/upper a word

This is a test.

```
:s/\(test\)/\U\1\E file/
```

### Lower/upper the first character

This is a test.

```
:s/\(test\)/\u\1 file/
```

## References

- http://vim.wikia.com/wiki/Search_and_replace
- https://github.com/tpope/vim-abolish
- http://vim.wikia.com/wiki/Changing_case_with_regular_expressions
