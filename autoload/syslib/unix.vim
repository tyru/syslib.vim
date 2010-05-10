" vim:foldmethod=marker:fen:
scriptencoding utf-8

" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}

" Functions {{{

function! syslib#unix#remove_directory(name) "{{{
    return syslib#_libcallnr('remove_directory', [a:name])
endfunction "}}}

" TODO
function! syslib#unix#rename_directory(old, new) "{{{
endfunction "}}}

function! syslib#unix#create_symlink(name, to_path) "{{{
    return syslib#_libcallnr('create_symlink', [a:name, a:to_path])
endfunction "}}}

function! syslib#unix#create_hardlink(name, to_path) "{{{
    return syslib#_libcallnr('create_hardlink', [a:name, a:to_path])
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
