" vim:foldmethod=marker:fen:
scriptencoding utf-8

" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}

" Functions {{{

function! syslib#create_directory(name, prot) "{{{
    return mkdir(a:name, '', a:prot)
endfunction "}}}

function! syslib#make_path(name, prot) "{{{
    return mkdir(a:name, 'p', a:prot)
endfunction "}}}

function! syslib#remove_file(fname) "{{{
    return delete(a:fname)
endfunction "}}}

function! syslib#rename_file(from, to) "{{{
    return rename(a:from, a:to)
endfunction "}}}

" }}}

" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
