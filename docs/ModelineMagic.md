# Modeline Magic
#
# vim: ft=markdown et ts=4 sw=4
# 

http://vim.wikia.com/wiki/Modeline_magic

## Examples

With "set", the modeline ends at the first colon not following a backslash.

```
/* vim: set ft=cpp: */
```

Without "set", no text can follow the options, so for example, the following is
invalid:


```
// vim: ft=markdown
```
