" vim:foldmethod=marker:fen:
scriptencoding utf-8

" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}

" Functions {{{

function! syslib#unix#remove_directory(name) "{{{
    return libcallnr(g:syslib_dll_path, 'remove_directory', a:name)
endfunction "}}}

" TODO
function! syslib#unix#rename_directory(name) "{{{
endfunction "}}}

" TODO
function! syslib#unix#create_symlink(name, to_path) "{{{
endfunction "}}}

" TODO
function! syslib#unix#create_hardlink(name, to_path) "{{{
endfunction "}}}



" TODO
function! syslib#unix#open_file_fd(name, mode) "{{{
endfunction "}}}

" TODO
function! syslib#unix#close_file_fd(fd) "{{{
endfunction "}}}

" TODO
function! syslib#unix#seek_file_fd(fd, offset, whence) "{{{
endfunction "}}}

" TODO
function! syslib#unix#read_file_fd(fd, buf, count) "{{{
endfunction "}}}

" TODO
function! syslib#unix#write_file_fd(fd, buf, count) "{{{
endfunction "}}}

" TODO
function! syslib#unix#flush_file_fd(fd) "{{{
endfunction "}}}

" }}}

" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
