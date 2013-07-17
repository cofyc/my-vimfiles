" Vim syntax file
" Language: CObj
" Maintainer: Yecheng Fu <cofyc.jackson@gmail.com>

if version < 600
    syntax clear
elseif exists("b:current_syntax")
    finish
endif

syn case match

" syncing method
syn sync minlines=100

" Comments
syn keyword cobjTodo             contained TODO FIXME XXX
syn match   cobjComment          "#.*$" contains=cobjTodo,@Spell


" Function declaration
syn region cobjFunction transparent matchgroup=cobjFunction start="\<func\>" end="\<end\>" contains=ALLBUT,cobjTodo,cobjSpecial


" String
syn match  cobjSpecial contained "\\[\\abfnrtv\'\"]\|\\\d\{,3}"
syn region cobjString  start=+'+ end=+'+ skip=+\\\\\|\\'+ contains=cobjSpecial,@Spell
syn region cobjString  start=+"+ end=+"+ skip=+\\\\\|\\"+ contains=cobjSpecial,@Spell

" Number (Integer/Float/Complex)
syn match   cobjNumber      "\<0[oO]\=\o\+[Ll]\=\>"
syn match   cobjNumber      "\<0[xX]\x\+[Ll]\=\>"
syn match   cobjNumber      "\<0[bB][01]\+[Ll]\=\>"
syn match   cobjNumber      "\<\%([1-9]\d*\|0\)[Ll]\=\>"
syn match   cobjNumber      "\<\d\+[jJ]\>"
syn match   cobjNumber      "\<\d\+[eE][+-]\=\d\+[jJ]\=\>"
syn match   cobjNumber
    \ "\<\d\+\.\%([eE][+-]\=\d\+\)\=[jJ]\=\%(\W\|$\)\@="
syn match   cobjNumber
    \ "\%(^\|\W\)\@<=\d*\.\d\+\%([eE][+-]\=\d\+\)\=[jJ]\=\>"

" Builtins Names
syn keyword cobjBuiltin     False True None
syn keyword cobjBuiltin     str type int print file

" Keywords
syn keyword cobjStatement   return local break continue while for in if elif else do end func
syn keyword cobjStatement   try catch throw finally
syn keyword cobjStatement   and or not is in


" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_cobj_syntax_inits")
  if version < 508
    let did_cobj_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink cobjStatement           Statement
  HiLink cobjString              String
  HiLink cobjNumber              Number
  HiLink cobjFunction            Function
  HiLink cobjComment             Comment
  HiLink cobjTodo                Todo
  HiLink cobjSpecial             SpecialChar
  HiLink cobjBuiltin             Identifier

  delcommand HiLink
endif

let b:current_syntax = "cobj"
