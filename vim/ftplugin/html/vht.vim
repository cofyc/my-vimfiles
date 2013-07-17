" HTML templates
" Author: Mikolaj Machowski ( mikmach AT wp DOT pl )
" License: GPL v. 2.0
" Version: 1.4
" Last_change: 25 aug 2004
" 
" Replica of DreamWeaver(tm) templates and libraries.

" Initialization {{{
set nocp
let s:save_cpo= &cpo
set cpo&vim

if exists("loaded_vht")
 finish
endif
let g:loaded_vht = 1

" }}}

" ======================================================================
" Commands
" ======================================================================
" Templates {{{
command! -nargs=? VHTcommit call VHT_Commit(<q-args>)
command! -nargs=? VHTupdate call VHT_Update(<q-args>)
command! -nargs=? VHTcheckout call VHT_Checkout(<q-args>)
command! -nargs=? VHTstrip call VHT_Strip(<q-args>)
command! -nargs=? VHTinsert call VHT_Insert(<q-args>)

" }}}
" Libraries {{{
command! -nargs=? VHLcommit call VHL_Commit(<q-args>)
command! -nargs=? VHLupdate call VHL_Update(<q-args>)
command! -nargs=? VHLcheckout call VHL_Checkout(<q-args>)
command! -nargs=? VHLinsert call VHL_Insert(<q-args>)

" }}}
" Show available templates/libraries {{{
command! -nargs=0 VHTshow call VHT_Show("templates")
command! -nargs=0 VHLshow call VHT_Show("libraries")

" }}}
" Check if editable regions are properly declared {{{
command! -nargs=0 VHTcheck echo VHT_Check()

" }}}

" ======================================================================
" Main functions
" ======================================================================
" VHT_Commit: write noneditable area to .vht file {{{
" Description: Write file line by line to register, skipping editable
" 		areas, then overwriting .vht file. Meantime it will extract
" 		links and change them to fullpaths ":p".
function! VHT_Commit(tmplname)

	" Check the most important thing about templates: is a storage place
	" for them?
	let vhtlevel = VHT_GetMainFileName(":p:h")
	if isdirectory(vhtlevel.'/Templates/') != 0
		let vhtdir = vhtlevel.'/Templates/'
	else
		echomsg "VHT: Templates directory doesn't exist. Create it!"
		return
	endif

	" Check if all regions are safely declared
	let vhtcheck = VHT_Check()
	if vhtcheck != ''
		echo vhtcheck
		return
	endif
		
	" Save current position
	let sline = line('.')
	let cpos = line(".") . " | normal!" . virtcol(".") . "|"

	let curd = getcwd()
	let filedir = expand('%:p:h')
	" change to dir where is file to get proper extension of relative
	" filenames
	call VHT_CD(filedir)

	normal! gg
	let editable = 0
	let z_rez = @z
	let @z = ''
	while line('.') <= line('$')
		let line = getline('.')
		if editable == 1 && line !~ '<!--\s*#EndEditable.*-->'
			normal! j
			continue
		endif
		if line =~ '<!--\s*#BeginEditable.*-->'
			let editable = 1
		endif
		if line =~ '<!--\s*#EndEditable.*-->'
			let editable = 0
		endif

		" Check if in line are links, when positive expand them to full
		" paths
		let line = VHT_ExpandLinks(line)

		" Prevent inserting blank line at the beginning
		if @z == ''
			let @z = line
		else
			let @z = @z."\n".line
		endif

		" Service last line without infinite loop
		if line('.') == line('$')
			break
		endif

		normal! j
	endwhile

	" Put contents of @z to template file. Find .htmlmain to check where
	" Templates is dir for them - following Dreamweaver.
	" Let check if argument exists or name of template was previously
	" set. This will enable use of multiply templates in one project. 
	if a:tmplname != ''
		let vhtfile = vhtdir.a:tmplname.'.vht'
		let b:vhtemplate = a:tmplname

	elseif exists("b:vhtemplate") && a:tmplname == ''
		let vhtfile = vhtdir.b:vhtemplate.'.vht'

	else
		let vhtname = input("You didn't specify Template name.\n".
				   \   "Enter name of existing template -\n".
				   \   VHT_ListFiles(vhtdir, 'vht').
				   \   "\nOr a new one (<Enter> to abandon action): ")

		if vhtname != ''
			let b:vhtemplate = vhtname
			let vhtfile = vhtdir.b:vhtemplate.'.vht'
		else

			silent! exe cpos
			return
		endif

	endif

	silent! exe "below 1split ".vhtfile
	silent! normal! gg"_dG
	silent! put! z
	silent! write
	silent! exe "bwipe ".vhtfile
	let @z = z_rez

	" Return to current dir
	call VHT_CD(curd)

	if getline('$') == ''
		silent! $d
	endif

	silent! exe cpos

endfunction

" }}}
" VHT_Checkout: 0read in template to current file {{{
" Description: Locate template and read in to the current file. Also
" 		correct links. It assumes file is empty!
function! VHT_Checkout(tmplname)
	" Check the most important thing about templates: is a storage place
	" for them?
	let vhtlevel = VHT_GetMainFileName(":p:h")
	if isdirectory(vhtlevel.'/Templates/') != 0
		let vhtdir = vhtlevel.'/Templates/'
	else
		echomsg "VHT: Templates directory doesn't exist. Create it!"
		return
	endif

	" Put contents of @z to template file. Find .htmlmain to check where
	" Templates is dir for them - following Dreamweaver.
	" Let check if argument exists or name of template was previously
	" set. This will enable use of multiply templates in one project. 
	if a:tmplname != ''
		let vhtfile = vhtdir.a:tmplname.'.vht'
		let b:vhtemplate = a:tmplname

	elseif exists("b:vhtemplate") && a:tmplname == ''
		let vhtfile = vhtdir.b:vhtemplate.'.vht'

	else
		let vhtname = input("You didn't specify Template name.\n".
				   \   "Enter name of template -\n".
				   \   VHT_ListFiles(vhtdir, 'vht').
				   \   "\n(<Enter> to abandon action): ")

		if vhtname != ''
			let b:vhtemplate = vhtname
			let vhtfile = vhtdir.b:vhtemplate.'.vht'

		else
			return

		endif

	endif

	exe 'silent 0read '.vhtfile

	let curd = getcwd()
	let filedir = expand('%:p:h')
	" change to dir where is file to get proper extension of relative
	" filenames
	call VHT_CD(filedir)

	normal! gg

	while line('.') <= line('$')

		call VHT_CollapseLinks(getline('.'))

		" Service last line without infinite loop
		if line('.') == line('$')
			break
		endif

		normal! j

	endwhile

	" Return to current dir
	call VHT_CD(curd)

	if getline('$') == ''
		silent $d
	endif

	normal! gg

endfunction

" }}}
" VHT_Update: update template area preserving changes in Editable {{{
" Description: Save editable areas to variables/registers/temporary
" 		files, remove file, checkout template, paste editables into
" 		proper places.
function! VHT_Update(tmplname)

	" Check the most important thing about templates: is a storage place
	" for them?
	let vhtlevel = VHT_GetMainFileName(":p:h")
	if isdirectory(vhtlevel.'/Templates/') != 0
		let vhtdir = vhtlevel.'/Templates/'
	else
		echomsg "VHT: Templates directory doesn't exist. Create it!"
		return
	endif

	" Check if all regions are safely declared
	let vhtcheck = VHT_Check()
	if vhtcheck != ''
		echo vhtcheck
		return
	endif

	let sline = line('.')
	let cpos = line(".") . " | normal!" . virtcol(".") . "|"

	let z_rez = @z

	normal! gg

	while search('<!--\s*#BeginEditable .*-->', 'W')
		let regname = matchstr(getline('.'), '<!--\s*#BeginEditable\s*"\zs.\{-}\ze"')
		if getline(line('.')+1) !~ '<!--\s*#EndEditable ' 
			:silent .+1,/<!--\s*#EndEditable /-1 y z
		else
			continue
		endif
		let b:vht_{regname} = @z

	endwhile

	silent normal! gg"_dG

	call VHT_Checkout(a:tmplname)

	while search('<!--\s*#BeginEditable .*-->', 'W')
		let regname = matchstr(getline('.'), '<!--\s*#BeginEditable\s*"\zs.\{-}\ze"')
		if exists("b:vht_".regname)
			let @z = b:vht_{regname}
			silent put z
		endif

	endwhile

	let @z = z_rez

	if getline('$') == ''
		silent $d
	endif

	silent exe cpos

endfunction
" }}}
" VHT_Strip: remove current/last/all editable areas tags from file {{{
" Description: Go to last opening tag, s/// it, go to the first closing
"              tag, s/// it and return to start position.
"              Use s/// and not g// to preserve line numbering
function! VHT_Strip(all)

	let cpos = line(".") . " | normal!" . virtcol(".") . "|"

	if a:all == ''
		normal! j

		if search('<!--\s*#BeginEditable .*-->', 'bW')
			silent! s/<!--\s*#BeginEditable.\{-}-->//e
			call search('<!--\s*#EndEditable ', 'W')
			silent! s/<!--\s*#EndEditable.\{-}-->//e
			silent! exe cpos
			return

		else
			echo "Could't find editable region, exit."
			silent! exe cpos
			return

		endif
		
	elseif a:all == 'all'
		silent! %s/<!--\s*#BeginEditable.\{-}-->//ge
		silent! %s/<!--\s*#EndEditable.\{-}-->//ge

	else
		echo "Argument not supported, exit."

	endif

	silent! exe cpos
	return

endfunction
" }}}
" VHT_Insert: insert template of editable region {{{
" Description: 
function! VHT_Insert(name)

	if a:name == '' || !exists("a:name")
		let name = ''

	else
		if a:name =~ '^[A-Za-z_][A-Za-z0-9_]*'
			let name = a:name
		else
			echo "Declared region name contains illegal characters, check help for details"
			return
		endif

	endif

	let beginline = '<!-- #BeginEditable "'.name.'" -->'

	put =beginline
	put ='<!-- #EndEditable -->'

	normal! k

	return

endfunction
" }}}

" VHL_Commit: commit current/last library to repository {{{
" Description: Find last BeginLibraryItem and put whole area between
" tags to file described in argument of start tag
function! VHL_Commit(libitem)

	let vhllevel = VHT_GetMainFileName(":p:h")

	" Save current position
	let sline = line('.')
	let cpos = line(".") . " | normal!" . virtcol(".") . "|"

	if a:libitem == 'all'
		normal! gg
	    while search('<!--\s*#BeginLibraryItem ', 'W')
			call VHL_Commit('')
		endwhile
		silent exe cpos
		return
	endif


	" If we start on BeginLibraryItem make sure to include it
	normal! j

	let line = search('<!--\s*#BeginLibraryItem ', 'bW')

	if line == 0
		silent exe cpos
		return
	endif

	let curd = getcwd()
	let filedir = expand('%:p:h')
	" change to dir where is file to get proper extension of relative
	" filenames
	call VHT_CD(filedir)

	let z_rez = @z
	let @z = ''

	let libname = matchstr(getline('.'), '<!--\s*#BeginLibraryItem\s*"\zs.\{-}\ze"')

	" Add extension to library name if user forgot about that
	if libname !~ '\.vhl'
		"call substitute(getline('.'), libname, libname.'\.vhl', '')
		silent! exe 's/BeginLibraryItem\s*"'.libname.'/\0\.vhl/e'
		let libname = libname.'.vhl'
		echo "Don't forget to add .vhl extension to Library Item name!"
	endif

	if libname[0] == '~'
		let vhlfile = fnamemodify(libname, ':p')
	elseif libname[0] !~ '[\/]'
		let vhlfile = vhllevel.'/'.libname
	else
		let vhlfile = vhllevel.libname
	endif

	silent normal! j

	while getline('.') !~ '<!--\s*#EndLibraryItem '

		" Check if in line are links, when positive expand them to full
		" paths
		let curline = VHT_ExpandLinks(getline('.'))

		" Prevent inserting blank line at the beginning
		if @z == ''
			let @z = curline
		else
			let @z = @z."\n".curline
		endif

		silent normal! j

	endwhile

	if filewritable(vhlfile) == 0
		" Hmm. Maybe this is new Lib?
		if filewritable(fnamemodify(vhlfile, ":p:h")) == 2
			" OK. Directory exists, just file isn't there. Proceed.
			exe 'silent below 1split '.vhlfile
			silent put! z
			silent $d
			silent write!
			exe 'bwipe '.vhlfile

		else
			" Something is wrong with pathname. Abort! Abort! Abort!
			echomsg "VHL: Can't write to or create Library with this path."

		endif

	else
		" Library already exist, we need to update its contents with @z
		let g:lfile = vhlfile
		exe 'silent below 1split '.vhlfile
		silent normal! gg"_dG
		silent put! z
		silent $d
		silent write!
		exe 'bwipe '.vhlfile

	endif

	let @z = z_rez

	call VHT_CD(curd)

	silent exe cpos

endfunction
"
" }}}
" VHL_Update: update contents of current/last library in file. {{{
" Description: Find last BeginLibraryItem and update area between tags
" tags to file described in argument of start tag
function! VHL_Update(libitem)

	let vhllevel = VHT_GetMainFileName(":p:h")

	" Save current position
	let sline = line('.')
	let cpos = line(".") . " | normal!" . virtcol(".") . "|"

	if a:libitem == 'all'
		normal! gg
	    while search('<!--\s*#BeginLibraryItem ', 'W')
			call VHL_Update('')
		endwhile
		silent exe cpos
		return
	endif

	" If we start on BeginLibraryItem make sure to include it
	normal! j

	let curd = getcwd()
	let filedir = expand('%:p:h')
	" change to dir where is file to get proper extension of relative
	" filenames
	call VHT_CD(filedir)

	" First we have to find if LibItem exists.
	let line = search('<!--\s*#BeginLibraryItem ', 'bW')

	" End if there is no LibItem above
	if line == 0
		silent exe cpos
		return
	endif

	let libname = matchstr(getline('.'), '<!--\s*#BeginLibraryItem\s*"\zs.\{-}\ze"')
	if libname !~ '^[\/]'
		let libname = '/'.libname
	endif

	let vhlfile = vhllevel.libname

	if filewritable(vhlfile) == 0
		" Something is wrong with pathname. Abort now!
		call VHT_CD(curd)
		silent exe cpos
		echomsg "VHL: Can't find this Library - check path."

		return

	endif

	" When we know LibItem exists we can remove current lib.
	if getline(line('.')+1) !~ '<!--\s*#EndLibraryItem ' 
		silent .+1,/<!--\s*#EndLibraryItem /-1 d _
	endif
	" Make sure we are back at the line with BeginLibraryItem
	exe line
	exe 'silent read '.vhlfile

	" Change links in Library from full to relative
	while getline('.') !~ '<!--\s*#EndLibraryItem '
		call VHT_CollapseLinks(getline('.'))
		normal! j

	endwhile

	call VHT_CD(curd)
	silent exe cpos

endfunction
"
" }}}
" VHL_Checkout: put at cursor position contents of library {{{
" Description: Find Library and put chosen snippet into cursor position
" 	(with links parsing)
function! VHL_Checkout(libitem)
	let vhllevel = VHT_GetMainFileName(":p:h")

	let sline = line('.')
	let cpos = line(".") . " | normal!" . virtcol(".") . "|"

	" Put contents of @z to template file. Find .htmlmain to check where
	" Templates is dir for them - following Dreamweaver.
	" Let check if argument exists or name of template was previously
	" set. This will enable use of multiply templates in one project. 
	if a:libitem != ''

		let vhlname = a:libitem

		if a:libitem[0] == '~'
			let vhlfile = fnamemodify(a:libitem, ':p')

		elseif a:libitem[0] != '/'
			let vhlfile = vhllevel.'/'.a:libitem

		endif

	else
		let vhlname = input("You didn't specify Library path.\n".
				   \   "Enter path to existing library -\n".
				   \   VHT_ListFiles(vhllevel, 'vhl').
				   \   "\n(<Enter> to abandon action): ")

		if vhlname != ''
			let vhlfile = vhllevel.'/'.vhlname

		else
			return

		endif

	endif

	if filereadable(vhlfile) != 1
		echomsg "VHL: Not correct path to Library. Try Again!"
		exe sline
		silent exe cpos
		return

	else
		exe 'silent below 1split '.vhlfile
		let z_rez = @z
		silent normal! gg"zyG
		let @z = '<!-- #BeginLibraryItem "'.vhlname.'" -->'."\n".@z."\n".
			\    '<!-- #EndLibraryItem -->'
		exe 'bwipe '.vhlfile
		exe sline
		silent put z
		let @z = z_rez

	endif

	let curd = getcwd()
	let filedir = expand('%:p:h')
	" change to dir where is file to get proper extension of relative
	" filenames
	call VHT_CD(filedir)

	" Make sure we are back at the beginning of Library content
	exe sline + 1

	" Change links in Library from full to relative
	while getline('.') !~ '<!--\s*#EndLibraryItem '
		call VHT_CollapseLinks(getline('.'))
		normal! j

	endwhile

	call VHT_CD(curd)
	silent exe cpos

endfunction
"
" }}}
" VHL_Strip: remove current/last/all library tags from file {{{
" Description: Go to last opening tag, s/// it, go to the first closing
"              tag, s/// it and return to start position.
"              Use s/// and not g// to preserve line numbering
function! VHL_Strip(all)

	let cpos = line(".") . " | normal!" . virtcol(".") . "|"

	if a:all == ''
		normal! j

		if search('<!--\s*#BeginLibraryItem .*-->', 'bW')
			silent! s/<!--\s*#BeginLibraryItem.\{-}-->//e
			call search('<!--\s*#EndLibraryItem ', 'W')
			silent! s/<!--\s*#EndLibraryItem.\{-}-->//e
			silent! exe cpos
			return

		else
			echo "Could't find library item, exit."
			silent! exe cpos
			return

		endif
		
	elseif a:all == 'all'
		silent! %s/<!--\s*#BeginLibraryItem.\{-}-->//e
		silent! %s/<!--\s*#EndLibraryItem.\{-}-->//e

	else
		echo "Argument not supported, exit."

	endif

	silent! exe cpos
	return

endfunction
" }}}
" VHL_Insert: insert template of editable region {{{
" Description: 
function! VHL_Insert(name)

	if a:name != '' && a:name !~ '\.vhl$'
		let name = a:name.'.vhl'

	else
		let name = a:name

	endif

	let beginline = '<!-- #BeginLibraryItem "'.name.'" -->'

	put =beginline
	put ='<!-- #EndLibraryItem -->'

	normal! k

	return

endfunction
" }}}

" VHT_Show: Show templates/libraries available in project {{{
" Description: Find files through ListFiles function depending on
" profile
function! VHT_Show(profile)

	let projname = VHT_GetMainFileName(":p:h")

	if a:profile == 'templates'

		" Check if Templates directory exists
		let vhtlevel = VHT_GetMainFileName(":p:h")
		if isdirectory(vhtlevel.'/Templates/') != 0
			let vhtdir = vhtlevel.'/Templates/'
		else
			echomsg "VHT: Templates directory doesn't exist. Create it!"
			return
		endif

		" Check if current file has template assigned
		if exists("b:vhtemplate")
			let curtmpl = b:vhtemplate
		else
			let curtmpl = 'NONE'
		endif

		echo 'Current template: '.curtmpl."\n".
		   \ 'Templates available in project '.projname." :\n".
		   \ VHT_ListFiles(vhtdir, 'vht')

	elseif a:profile == 'libraries'

		let vhllevel = VHT_GetMainFileName(":p:h")

		echo "Libraries available in project ".projname." :\n".
			  \ VHT_ListFiles(vhllevel, 'vhl')

	endif

endfunction

" }}}

" VHT_Check: check if templates were properly declared {{{
" Description: Go through the file and check if tags around editable
"              regions match rigid regexps.
function! VHT_Check()

	" Save position
	let cpos = line(".") . " | normal!" . virtcol(".") . "|"

	normal! gg

	let badline = ''

	while search('<!--\s*#BeginEditable.*-->', 'W')
		if getline('.') !~ '^\s*<!--\s*#BeginEditable\s\+"[A-Za-z_][A-Za-z0-9_]*"\s*-->\s*$'
			let badline = badline." ".line('.').":    ".getline('.')."\n"
		endif
	endwhile

	normal! gg

	while search('<!--\s*#EndEditable.*-->', 'W')
		if getline('.') !~ '^\s*<!--\s*#EndEditable\s*-->\s*$'
			let badline = badline." ".line('.').":    ".getline('.')."\n"
		endif
	endwhile

	silent exe cpos

	let g:badl = badline

	if badline != ''
		return "Not all editable regions were safely declared. List of them:\n"
					\ .badline."End of operation."
	else
		return ''

	endif

endfunction

" }}}
" ======================================================================
" Support for taglist.vim
" ======================================================================
" Sets Tlist_Ctags_Cmd for taglist.vim and regexps for ctags {{{
if !exists("g:tlist_html_settings") 
	let g:tlist_html_settings = 'html;a:Anchors;e:Editable regions;l:Libraries'
endif

if exists("Tlist_Ctags_Cmd")
	let s:html_ctags = g:Tlist_Ctags_Cmd
else
	let s:html_ctags = 'ctags' " Configurable?
endif

if exists("Tlist_Ctags_Cmd") && g:Tlist_Ctags_Cmd !~ '#BeginEditable' || !exists("Tlist_Ctags_Cmd")
	let g:Tlist_Ctags_Cmd = s:html_ctags .' --langdef=html --langmap=html:.html.htm'
	\.' --regex-html="/ #BeginEditable \"([A-Za-z_][A-Za-z0-9_]*)\"/\1/e,editable/"'
	\.' --regex-html="/ #BeginLibraryItem \"([^\"]*)\"/\1/l,library/"'
endif

" }}}
" ======================================================================
" Auxiliary functions
" ======================================================================
" VHT_ListFiles: give list of templates or libraries {{{
" Description: cd to template/library dir and get list of files, remove
" extensions
function! VHT_ListFiles(vhtdir, ext)
	let curd = getcwd()
	call VHT_CD(a:vhtdir)
	if a:ext == 'vht'
		let filelist = glob("*")
		let filelist = substitute(filelist, '\.vht', '', 'ge')
	elseif a:ext == 'vhl'
		let filelist = globpath(".,Library", '*.\(vhl\|lbi\)')
		let filelist = substitute(filelist, '\(^\|\n\)\..', '\1', 'ge')
	endif
	call VHT_CD(curd)
	return filelist
endfunction

" }}}
" VHT_CollapseLinks: Change full paths of links to relative {{{
" Description: go through read file up to End LibraryItem and change
" links
function! VHT_CollapseLinks(line)
	" Update links in read file - up to EndLibraryItem
	if a:line =~? '\(\(href\|src\|location\)\s*=\|\(window\.open\|url\)(\)'
		if a:line =~? '\(window\.open\|url\)('
			let link = matchstr(a:line, "\\(window\\.open\\|url\\)(\\('\\|\"\\)\\?\\zs.\\{-}\\ze\\2)")
		else
			let link = matchstr(a:line, "\\(href\\|src\\|location\\)\\s\*=\\s\*\\('\\|\"\\)\\zs.\\{-}\\ze\\2")
		endif
		" Check for protocols and # or filereadable() is enough?
		if !filereadable(link)
			return
		endif
		let rellink = VHT_RelPath(link, expand('%:p'))
		" What chars should be escaped?
		let esclink = escape(link, ' \.?')
		let escrellink = escape(rellink, ' \.?')
		" Should changing of paths be 'g'lobal or not?
		exe 'silent s+'.esclink.'+'.escrellink.'+e'
	endif

endfunction

" }}}
" VHT_ExpandLinks: Change names in links from relative to full path {{{
" Description: take line and change names if necessary
function! VHT_ExpandLinks(line)

	let line = a:line

	if line =~? '\(\(href\|src\|location\)\s*=\|\(window\.open\|url\)(\)'
		if line =~? '\(window\.open\|url\)('
			let link = matchstr(line, "\\(window\\.open\\|url\\)(\\('\\|\"\\)\\?\\zs.\\{-}\\ze\\2)")
		else
			let link = matchstr(line, "\\(href\\|src\\|location\\)\\s\*=\\s\*\\('\\|\"\\)\\zs.\\{-}\\ze\\2")
		endif
		if !filereadable(link)
			return line
		endif
		let fulllink = fnamemodify(link, ':p')
		" What chars should be escaped?
		let esclink = escape(link, ' \.?')
		let escfulllink = escape(fulllink, ' \.?')
		let line = substitute(line, link, escfulllink, 'e')
	endif

	return line

endfunction

" }}}
" ----------------------------------------------------------------------
" These functions (with cosmetic changes) are coming from vim-latexSuite
" project - http://vim-latex.sourceforge.net
" VHT_GetMainFileName: gets the name of the root html file. {{{
" Description:  returns the full path name of the main file.
"               This function checks for the existence of a .htmlmain file
"               which might point to the location of a "main" html file.
"               If .htmlmain exists, then return the full path name of the
"               file being pointed to by it.
"
"               Otherwise, return the full path name of the current buffer.
"
"               You can supply an optional "modifier" argument to the
"               function, which will optionally modify the file name before
"               returning.
"               NOTE: From version 1.6 onwards, this function always trims
"               away the .htmlmain part of the file name before applying the
"               modifier argument.
function! VHT_GetMainFileName(...)
	if a:0 > 0
		let modifier = a:1
	else
		let modifier = ':p'
	endif

	" If the user wants to use his own way to specify the main file name, then
	" use it straight away.
	if VHT_GetVarValue('VHT_MainFileExpression', '') != ''
		exec 'let retval = '.VHT_GetVarValue('VHT_MainFileExpression', '')
		return retval
	endif

	let curd = getcwd()

	let dirmodifier = '%:p:h'
	let dirLast = expand(dirmodifier)
	call VHT_CD(dirLast)

	" move up the directory tree until we find a .htmlmain file.
	" TODO: Should we be doing this recursion by default, or should there be a
	"       setting?
	while glob('*.htmlmain') == ''
		let dirmodifier = dirmodifier.':h'
		" break from the loop if we cannot go up any further.
		if expand(dirmodifier) == dirLast
			break
		endif
		let dirLast = expand(dirmodifier)
		call VHT_CD(dirLast)
	endwhile

	let lheadfile = glob('*.htmlmain')
	if lheadfile != ''
		" Remove the trailing .htmlmain part of the filename... We never want
		" that.
		let lheadfile = fnamemodify(substitute(lheadfile, '\.htmlmain$', '', ''), modifier)
	else
		" If we cannot find any main file, just modify the filename of the
		" current buffer.
		let lheadfile = expand('%'.modifier)
	endif

	call VHT_CD(curd)

	" NOTE: The caller of this function needs to escape spaces in the
	"       file name as appropriate. The reason its not done here is that
	"       escaping spaces is not safe if this file is to be used as part of
	"       an external command on certain platforms.
	return lheadfile
endfunction 
" }}}
" VHT_CD: cds to given directory escaping spaces if necessary {{{
" " Description: 
function! VHT_CD(dirname)
	exec 'cd '.VHT_EscapeSpaces(a:dirname)
endfunction " }}}
" VHT_EscapeSpaces: escapes unescaped spaces from a path name {{{
" Description:
function! VHT_EscapeSpaces(path)
	return substitute(a:path, '[^\\]\(\\\\\)*\zs ', '\\ ', 'g')
endfunction " }}}
" VHT_GetVarValue: gets the value of the variable {{{
" Description: 
" 	See if a window-local, buffer-local or global variable with the given name
" 	exists and if so, returns the corresponding value. Otherwise return the
" 	provided default value.
function! VHT_GetVarValue(varname, default)
	if exists('w:'.a:varname)
		return w:{a:varname}
	elseif exists('b:'.a:varname)
		return b:{a:varname}
	elseif exists('g:'.a:varname)
		return g:{a:varname}
	else
		return a:default
	endif
endfunction " }}}
" VHT_Common: common part of strings {{{
function! s:VHT_Common(path1, path2)
	" Assume the caller handles 'ignorecase'
	if a:path1 == a:path2
		return a:path1
	endif
	let n = 0
	while a:path1[n] == a:path2[n]
		let n = n+1
	endwhile
	return strpart(a:path1, 0, n)
endfunction " }}}
" VHT_NormalizePath:  {{{
" Description: 
function! VHT_NormalizePath(path)
	let retpath = a:path
	if has("win32") || has("win16") || has("dos32") || has("dos16")
		let retpath = substitute(retpath, '\\', '/', 'ge')
	endif
	if isdirectory(retpath) && retpath !~ '/$'
		let retpath = retpath.'/'
	endif
	return retpath
endfunction " }}}
" VHT_RelPath: ultimate file name {{{
function! VHT_RelPath(explfilename,texfilename)
	let path1 = VHT_NormalizePath(a:explfilename)
	let path2 = VHT_NormalizePath(a:texfilename)

	let n = matchend(<SID>VHT_Common(path1, path2), '.*/')
	let path1 = strpart(path1, n)
	let path2 = strpart(path2, n)
	if path2 !~ '/'
		let subrelpath = ''
	else
		let subrelpath = substitute(path2, '[^/]\{-}/', '../', 'ge')
		let subrelpath = substitute(subrelpath, '[^/]*$', '', 'ge')
	endif
	let relpath = subrelpath.path1
	return escape(VHT_NormalizePath(relpath), ' ')
endfunction " }}}

" vim:fdm=marker:ff=unix:noet:ts=4:sw=4:nowrap
