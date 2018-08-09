" Vim Run Command File
"
" File: ~/.vimrc
" Author: Yecheng Fu <cofyc.jackson@gmail.com>

set nocompatible
set backspace=indent,eol,start

" File Format
set fileformats=unix,dos,mac " file formats to try when opening file

" File Encoding
set encoding=utf-8  " internal encoding
set fileencodings=utf-8,gb18030 " file encodings to try when opening file

" History Line
set history=1000

" Filetype
filetype on
filetype plugin on
filetype indent on
let g:c_syntax_for_h = 1

" Set mapleader
let mapleader = ","

" Syntax Highlight
syntax on

" Color
colorscheme zellner

set autoread
set so=7
set wildmenu
set ruler
set cmdheight=1
set nu
set lz
set hid
set incsearch
set magic
set noerrorbells
set novisualbell
set showmatch
set mat=2
set hlsearch
set laststatus=2
"set statusline=%F%m%r%h%w%y[%{&fileencoding}][%{&ff}]\ \ Line:\ %l/%L\ \ Col:\ %c\ \ Cwd:\ %{getcwd()}
set statusline=%F%m%r%h%w%y[%{&fileencoding}][%{&ff}]\ \ Line:\ %l/%L\ \ Col:\ %c
set nobackup
set nowritebackup
set noswapfile

" Folding
set foldenable
set foldlevel=0

" Tabs
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smarttab
set expandtab

" Indent
set autoindent
set breakindent
" Only enable smartindent for c-like programming languages, see
" https://vi.stackexchange.com/a/5591.
au BufRead,BufNewFile *.c   :set smartindent
au BufRead,BufNewFile *.cpp :set smartindent
au BufRead,BufNewFile *.c   :set smartindent 

" Pathogen, install plugins/scripts in private directories.
runtime bundle/vim-pathogen/autoload/pathogen.vim
let g:pathogen_disabled = ['vim-cobj', 'Command-T']
call pathogen#infect()

" Abbreviations
iab xdate <C-R>=strftime("Date: %a %b %d %H:%M:%S %Y %z")<CR>
iab xdate1 <C-R>=strftime("%d %b %Y")<CR>
iab xauthor Author: Yecheng Fu <cofyc.jackson@gmail.com>
iab xnick Cofyc
iab xname Yecheng
iab xfname Yecheng Fu
iab xmail cofyc.jackson@gmail.com

" Tab Page Shortcuts
map <F2>    :tabprevious<CR>
map <F3>    :tabnext<CR>
map <F4>    :tabnew .<CR>
map <F5>    :tabclose<CR>

" Exchange Words Separated By '[, ]'
map <leader>x :s/\v([^, (){}\[\]]*)([, ]\s*)([^, (){}\[\]]*)/\3\2\1/<CR> :nohlsearch<CR>

" Remove Trailing Spaces
function! RemoveTrailingSpaces()
    silent! %s/\v\s+$//
    echom "Trailing spaces removed."
endfunction
map <leader>r :call RemoveTrailingSpaces()<CR>

" Insert Line Number
map <leader>l :g/^/ s//\=line('.').' '/<CR>

" Title Case
" change capital letters to uppercase
map <leader>u :s/\<\(\w\)\(\w*\)\>/\u\1\2/g<CR> :nohlsearch<CR>
" strict version (addtion to previous, change letters follows capital to lowercase)
map <leader>U :s/\<\(\w\)\(\w*\)\>/\u\1\L\2/g<CR> :nohlsearch<CR>

" Cmd: XmlFmt
command! XmlFmt set ft=xml | execute "%!xmllint --format -"

" Cmd: HtmlFmt
command! HtmlFmt set ft=html | execute "%!tidy -q -i -asxhtml 2>/dev/null"

" Cmd: JsonFmt
command! JsonFmt set ft=json | execute "%!python -m json.tool"

" Windows
set wmh=0

" Plugins: Taglist
let Tlist_File_Fold_Auto_Close = 1
let Tlist_Exit_OnlyWindow = 1
map <F6> :TlistToggle<CR>
map <F7> :TlistUpdate<CR>

" Plugins: gitcommit
autocmd FileType gitcommit DiffGitCached | wincmd r | wincmd =
au BufRead,BufNewFile *.vcl :set ft=vcl

" Macros
" @link http://vim.wikia.com/wiki/Macros
:nnoremap <Space> @q

" Improved hex editing: http://vim.wikia.com/wiki/Improved_Hex_editing
nnoremap <C-H> :Hexmode<CR>
inoremap <C-H> <Esc>:Hexmode<CR>
vnoremap <C-H> :<C-U>Hexmode<CR>

command -bar Hexmode call ToggleHex()
function! ToggleHex()
    " hex mode should be considered a read-only operation
    " save values for modified and read-only for restoration later,
    " and clear the read-only flag for now
    let l:modified=&mod
    let l:oldreadonly=&readonly
    let &readonly=0
    let l:oldmodifiable=&modifiable
    let &modifiable=1

    if !exists("b:editHex") || !b:editHex
        " save old options
        let b:oldft=&ft
        let b:oldbin=&bin
        " set new options
        setlocal binary " make sure it overrides any textwidth, etc.
        let &ft="xxd"
        " set status
        let b:editHex=1
        " switch to hex editor
        %!xxd
    else
        " restore old options
        let &ft=b:oldft
        if !b:oldbin
          setlocal nobinary
        endif
        " set status
        let b:editHex=0
        " return to normal editing
        %!xxd -r
    endif
    " restore values for modified and read only state
    let &mod=l:modified
    let &readonly=l:oldreadonly
    let &modifiable=l:oldmodifiable
endfunction

" autocmds to automatically enter hex mode and handle file writes properly
if has("autocmd")
  " vim -b : edit binary using xxd-format!
  augroup Binary
    au!

    " set binary option for all binary files before reading them
    au BufReadPre *.bin,*.hex setlocal binary

    " if on a fresh read the buffer variable is already set, it's wrong
    au BufReadPost *
          \ if exists('b:editHex') && b:editHex |
          \   let b:editHex = 0 |
          \ endif

    " convert to hex on startup for binary files automatically
    au BufReadPost *
          \ if &binary | :silent Hexmode | endif

    " When the text is freed, the next time the buffer is made active it will
    " re-read the text and thus not match the correct mode, we will need to
    " convert it again if the buffer is again loaded.
    au BufUnload *
          \ if getbufvar(expand("<afile>"), 'editHex') == 1 |
          \   call setbufvar(expand("<afile>"), 'editHex', 0) |
          \ endif

    " before writing a file when editing in hex mode, convert back to non-hex
    au BufWritePre *
          \ if exists("b:editHex") && b:editHex && &binary |
          \  let oldro=&ro | let &ro=0 |
          \  let oldma=&ma | let &ma=1 |
          \  silent exe "%!xxd -r" |
          \  let &ma=oldma | let &ro=oldro |
          \  unlet oldma | unlet oldro |
          \ endif

    " after writing a binary file, if we're in hex mode, restore hex mode
    au BufWritePost *
          \ if exists("b:editHex") && b:editHex && &binary |
          \  let oldro=&ro | let &ro=0 |
          \  let oldma=&ma | let &ma=1 |
          \  silent exe "%!xxd" |
          \  exe "set nomod" |
          \  let &ma=oldma | let &ro=oldro |
          \  unlet oldma | unlet oldro |
          \ endif
  augroup END
endif

" http://vim.wikia.com/wiki/Opening_multiple_files_from_a_single_command-line
function! Sp(dir, ...)
    let split = 'sp'
    if a:dir == '1'
        let split = 'vsp'
    endif
    if(a:0 == 0)
        execute split
    else
        let i = a:0
        while(i > 0)
            execute 'let files = glob (a:' . i . ')'
            for f in split (files, "\n")
                execute split . ' ' . f
            endfor
            let i = i - 1
        endwhile
        windo if expand('%') == '' | q | endif
endif
endfunction
com! -nargs=* -complete=file Sp call Sp(0, <f-args>)
com! -nargs=* -complete=file Vsp call Sp(1, <f-args>)

" http://stackoverflow.com/questions/290465/vim-how-to-paste-over-without-overwriting-register
" I haven't found how to hide this function (yet)
function! RestoreRegister()
  let @" = s:restore_reg
  return ''
endfunction

function! s:Repl()
    let s:restore_reg = @"
    return "p@=RestoreRegister()\<cr>"
endfunction

" NB: this supports "rp that replaces the selection by the contents of @r
vnoremap <silent> <expr> p <sid>Repl()

"
au BufRead,BufNewFile *.pl :set tw=79
au BufRead,BufNewFile *.c :set tw=79
au BufRead,BufNewFile *.erl :set tw=79
au BufRead,BufNewFile *.md :set tw=79
"au BufRead,BufNewFile *.sh :set tw=79

" Redefine iskeyword, (Perl6 use dash)
au BufRead,BufNewFile *.pl :set iskeyword=@,48-57,_,192-255,#,-

" Plugin: TagBar
nnoremap <silent> <F8> :TagbarToggle<CR>
let g:tagbar_left = 1
let g:tagbar_sort = 0
"" TagBar/gotags
let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
    \ }

" LeaderF
" let g:Lf_WindowPosition = 'left'
" let g:Lf_HideHelp = 1
" noremap <silent> <F8> :LeaderfFunction!<cr>

" No end of line on last line
" Add end of line at end: :set binary :set eol
" Remove end of line at end: :set binary :set noeol
"au BufWritePre * :set binary | set noeol
"au BufWritePre *.php :set noeol
"au BufWritePost * :set nobinary | set eol

" Create parent directories on save.
" http://stackoverflow.com/questions/4292733/vim-creating-parent-directories-on-save
function s:MkNonExDir(file, buf)
    if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
        let dir=fnamemodify(a:file, ':h')
        if !isdirectory(dir)
            call mkdir(dir, 'p')
        endif
    endif
endfunction
augroup BWCCreateDir
    autocmd!
    autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup END

" indent guides
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red   ctermbg=0
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=7

" go
au BufRead,BufNewFile *.go set noexpandtab
"au FileType go au BufWritePre <buffer> Fmt
au BufNewFile,BufRead *.goc setf c

" Plugin: vim-go
let g:go_disable_autoinstall = 1
let g:go_fmt_command = "goimports"
let g:go_fmt_autosave = 0 " too slow
let g:go_asmfmt_autosave = 0
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_fmt_fail_silently = 1
let g:go_play_open_browser = 0
let g:go_get_update = 0
" increase memory limit, go to definition requires many memory now
set maxmempattern=2000

" Plugin: Align
" align on first separator only
map <leader>tf= :Align! lp1P1: =<CR>
" we use pp instead of =>
map <leader>tfpp :Align! lp1P1: =><CR> 
map <leader>tf: :Align! lp1P1: :<CR>

" Plugin: Tabularize
" http://vimcasts.org/episodes/aligning-text-with-tabular-vim/
if exists(":Tabularize")
  nmap <leader>a= :Tabularize /=<CR>
  vmap <leader>a= :Tabularize /=<CR>
  nmap <leader>a: :Tabularize /:\zs<CR>
  vmap <leader>a: :Tabularize /:\zs<CR>
  nmap <leader>a| :Tabularize /|<CR>
  vmap <leader>a| :Tabularize /|<CR>
endif

" Call :Tabularize command each time you insert a | character.
inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a
function! s:align()
  let p = '^\s*|\s.*\s|\s*$'
  if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
    Tabularize/|/l1
    normal! 0
    call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction

" Plugin: EasyAlign
" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)

" Plugin: PreserveNoEOL
let g:PreserveNoEOL = 1

" modeline
set modeline
set modelines=5

" spell check
set nospell " default off
set spelllang=en_us,cjk
set spellcapcheck=  " disable capitalized words check
set spellfile=~/.vim/spell/en.utf-8.add
autocmd BufRead,BufNewFile *.md setlocal spell
autocmd FileType gitcommit setlocal spell
set complete+=kspell

" Plugin: NERDTree
map <C-n> :NERDTreeToggle<CR>
"" Open a NERDTree automatically when vim starts up if no files were specified.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
"" Close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" Plugin: NERDCommenter
let g:NERDCustomDelimiters = {
    \ 'sshconfig': { 'left': '#' },
    \ 'haproxy': { 'left': '#' }
    \ }
let g:NERDSpaceDelims = 1
map <C-C> <leader>c<space>
imap <C-C> <ESC><leader>c<space>i

" JSON
let g:vim_json_syntax_conceal = 0

""" Completion
set completeopt-=preview

" VOoM
function ToggleOutLiner(type)
    if a:type == "markdown"
        VoomToggle markdown
    else
        VoomToggle markdown
    endif
endfunction
nnoremap <silent> <F9> :call ToggleOutLiner(&l:filetype)<CR>

""" formatting
autocmd FileType javascript noremap <buffer> <leader>f :call JsBeautify()<cr>
" for html
autocmd FileType html noremap <buffer> <leader>f :call HtmlBeautify()<cr>
" for css or scss
autocmd FileType css noremap <buffer> <leader>f :call CSSBeautify()<cr>
" formatting/range
autocmd FileType javascript vnoremap <buffer> <leader>f :call RangeJsBeautify()<cr>
autocmd FileType html vnoremap <buffer> <leader>f :call RangeHtmlBeautify()<cr>
autocmd FileType css vnoremap <buffer> <leader>f :call RangeCSSBeautify()<cr>

autocmd FileType c noremap <buffer> <leader>f :call Uncrustify('c')<CR>
autocmd FileType c vnoremap <buffer> <leader>f :call RangeUncrustify('c')<CR>
" autocmd FileType cpp noremap <buffer> <leader>f :call Uncrustify('cpp')<CR>
" autocmd FileType cpp vnoremap <buffer> <leader>f :call RangeUncrustify('cpp')<CR>

let g:clang_format#detect_style_file=1
autocmd FileType cpp,objc nnoremap <buffer><Leader>f :<C-u>ClangFormat<CR>
autocmd FileType cpp,objc vnoremap <buffer><Leader>f :ClangFormat<CR>

" https://github.com/tell-k/vim-autopep8
let g:autopep8_disable_show_diff=1
autocmd FileType python noremap <buffer> <leader>f :call Autopep8()<CR>
autocmd FileType python vnoremap <buffer> <leader>f :call Autopep8()<CR>
" go (extra redraw! to avoid messing up screen)
autocmd FileType go noremap <buffer> <leader>f :GoFmt<CR> :redraw!<CR>
autocmd FileType go vnoremap <buffer> <leader>f :GoFmt<CR> :redraw!<CR>

" Plugin: vim-template
let g:templates_directory = '~/.vim/templates'
let g:templates_no_builtin_templates = 1

" Tips: Show spaces in list
" Run `:set list` to turn on
" Run `:set nolist` to turn off
" See docs/ShowSpacesInListMode.md for more infos.
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣
