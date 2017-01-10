# Modeline Magic
#
# vim: ft=markdown et sw=8 ts=8
# 

## Enable modeline

```
:set modeline
:set modelines=5
```

## Examples

With "set", the modeline ends at the first colon not following a backslash.

```
/* vim: set ft=cpp: */
```

Without "set", no text can follow the options, so for example, the following is
invalid:


```
/* vim: ft=markdown */
```

## References

- http://vim.wikia.com/wiki/Modeline_magic
