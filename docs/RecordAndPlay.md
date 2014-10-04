# Recording And Play

Occasionally, you'll find yourself doing the same thing over and over to blocks
of text in your document. Vim will let you record an ad-hoc macro to  perform
the operation.

## Start to record

```
q{register}
```

Star macro recording into the named register. For instance:

`qa` starts recording and puts the macro into register `a`.

## End recording

```
q
```

## Replay

```
@{register}
```

Replay the macro stored in the named register. For instance:

`@a` replays the macro in register `a`.

Keep in mind that macros just record your keystrokes and play them back; they
are not magic. Recording macros is almost an art form because there are so many
commands that accomplish a given task in vim, and you must carefully select the
commands you use while your macro is recording so that they will work in all
the places you plan to execute the macro.
