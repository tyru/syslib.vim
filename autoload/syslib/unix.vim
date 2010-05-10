" vim:foldmethod=marker:fen:
scriptencoding utf-8

" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}

" Functions {{{

" TODO
function! syslib#unix#remove_directory(name) "{{{
endfunction "}}}

" TODO
function! syslib#unix#rename_directory(name) "{{{
endfunction "}}}

" TODO
function! syslib#unix#open_file(name, mode) "{{{
endfunction "}}}

" TODO
function! syslib#unix#close_file(name, mode) "{{{
endfunction "}}}

" TODO
function! syslib#unix#remove_path(name, recursively) "{{{
endfunction "}}}

" TODO
function! syslib#unix#create_symlink(name, to_path) "{{{
endfunction "}}}

function! syslib#unix#follow_symlink(name, recursively) "{{{
    let name = a:name
    if a:recursively
        while syslib#is_symlink(name)
            let name = s:readlink(name)
        endwhile
        return name
    else
        return s:readlink(name)
    endif
endfunction "}}}

" TODO
function! s:readlink(name) "{{{
endfunction "}}}

" }}}

" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
