" vim:foldmethod=marker:fen:
scriptencoding utf-8

" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}

" Get current OS name string. "{{{
if has('win16') || has('win32') || has('win64') || has('win95')
    " MS Windows.
    function! syslib#get_os_name()
        return 'win'
    endfunction
elseif has('unix') || has('win32unix')
    " Unix like environment (currently cygwin included).
    function! syslib#get_os_name()
        return 'unix'
    endfunction
else
    echoerr "Sorry, syslib.vim does not support your environment."
    finish
endif
" }}}

" Global Variables {{{
if !exists('g:syslib_dll_path')
    let g:syslib_dll_path = expand("<sfile>:p:h") . '/' . (syslib#get_os_name() ==# 'win' || exists('$WINDIR') ? 'syslib.dll' : 'syslib.so')
endif
if has('iconv')
  " Dll path should be encoded with default encoding.  Vim does not convert
  " it from &enc to default encoding.
  let g:syslib_dll_path = iconv(g:syslib_dll_path, &encoding, "default")
endif
" }}}

" Functions {{{

" Wrapper for built-in functions.
function! syslib#create_directory(name, ...) "{{{
    return call('mkdir', [a:name, ''] + a:000)
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

function! syslib#follow_symlink(name) "{{{
    return resolve(a:name)
endfunction "}}}

function! syslib#remove_path(name) "{{{
    return call('syslib#' . syslib#get_os_name() . '#remove_path', a:000)
endfunction "}}}



function! syslib#is_file(name) "{{{
    return getftype(a:name) ==# 'file'
endfunction "}}}

function! syslib#is_dir(name) "{{{
    return getftype(a:name) ==# 'dir'
endfunction "}}}

function! syslib#is_symlink(name) "{{{
    return getftype(a:name) ==# 'link'
endfunction "}}}

function! syslib#is_block_device(name) "{{{
    return getftype(a:name) ==# 'bdev'
endfunction "}}}

function! syslib#is_character_device(name) "{{{
    return getftype(a:name) ==# 'cdev'
endfunction "}}}

function! syslib#is_socket(name) "{{{
    return getftype(a:name) ==# 'socket'
endfunction "}}}

function! syslib#is_fifo(name) "{{{
    return getftype(a:name) ==# 'fifo'
endfunction "}}}

function! syslib#is_other(name) "{{{
    return getftype(a:name) ==# 'other'
endfunction "}}}



function! syslib#system(expr, ...) "{{{
    " Perl-like system() function.
    if type(a:expr) == type([])
        if executable(a:expr)
            " TODO Call `a:expr[0]` directly.
            return call('system', [join(a:expr)] + a:000)
        else
            return call('system', [join(a:expr)] + a:000)
        endif
    else
        return call('system', [a:expr] + a:000)
    endif
endfunction "}}}

function! syslib#glob(expr) "{{{
    return split(glob(a:expr), '\zs')
endfunction "}}}

function! syslib#globpath(path, expr) "{{{
    return split(globpath(a:path, a:expr), '\zs')
endfunction "}}}



function! syslib#_libcall(...) "{{{
    return call('s:libcall', [0] + a:000)
endfunction "}}}

function! syslib#_libcallnr(...) "{{{
    return call('s:libcall', [1] + a:000)
endfunction "}}}

function! s:libcall(libcallnr, funcname, args) "{{{
    return call(
    \   (a:libcallnr ? 'libcallnr' : 'libcall'),
    \   [
    \       g:syslib_dll_path,
    \       a:funcname,
    \       s:pack_arguments(a:args),
    \   ]
    \)
endfunction "}}}

function! s:pack_arguments(args) "{{{
    if type(a:args) != type([]) || empty(a:args)
        throw printf('syslib: s:pack_arguments(): invalid argument')
    elseif len(a:args) == 1
        return a:args[0]
    else
        " TODO
    endif
endfunction "}}}



" Stubs for each architecture.
function! syslib#remove_directory(...) "{{{
    return call('syslib#' . syslib#get_os_name() . '#remove_directory', a:000)
endfunction "}}}

function! syslib#rename_directory(...) "{{{
    return call('syslib#' . syslib#get_os_name() . '#rename_directory', a:000)
endfunction "}}}

function! syslib#create_symlink(...) "{{{
    return call('syslib#' . syslib#get_os_name() . '#create_symlink', a:000)
endfunction "}}}

function! syslib#create_hardlink(...) "{{{
    return call('syslib#' . syslib#get_os_name() . '#create_hardlink', a:000)
endfunction "}}}



function! syslib#open_file_fd(...) "{{{
    return call('syslib#' . syslib#get_os_name() . '#open_file_fd', a:000)
endfunction "}}}

function! syslib#close_file_fd(...) "{{{
    return call('syslib#' . syslib#get_os_name() . '#close_file_fd', a:000)
endfunction "}}}

function! syslib#seek_file_fd(...) "{{{
    return call('syslib#' . syslib#get_os_name() . '#seek_file_fd', a:000)
endfunction "}}}

function! syslib#read_file_fd(...) "{{{
    return call('syslib#' . syslib#get_os_name() . '#read_file_fd', a:000)
endfunction "}}}

function! syslib#write_file_fd(...) "{{{
    return call('syslib#' . syslib#get_os_name() . '#write_file_fd', a:000)
endfunction "}}}

function! syslib#flush_file_fd(...) "{{{
    return call('syslib#' . syslib#get_os_name() . '#flush_file_fd', a:000)
endfunction "}}}
" }}}

" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
