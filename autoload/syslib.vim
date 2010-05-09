" vim:foldmethod=marker:fen:
scriptencoding utf-8

" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}

" Functions {{{



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



" Wrapper for built-in functions.
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



" Stubs for each architecture.
function! syslib#remove_directory(...) "{{{
    return call('syslib#' . syslib#get_os_name() . '#remove_directory', a:000)
endfunction "}}}

function! syslib#rename_directory(...) "{{{
    return call('syslib#' . syslib#get_os_name() . '#rename_directory', a:000)
endfunction "}}}

function! syslib#open_file(...) "{{{
    return call('syslib#' . syslib#get_os_name() . '#open_file', a:000)
endfunction "}}}

function! syslib#close_file(...) "{{{
    return call('syslib#' . syslib#get_os_name() . '#close_file', a:000)
endfunction "}}}

function! syslib#remove_path(...) "{{{
    return call('syslib#' . syslib#get_os_name() . '#remove_path', a:000)
endfunction "}}}

function! syslib#is_symlink(...) "{{{
    return call('syslib#' . syslib#get_os_name() . '#is_symlink', a:000)
endfunction "}}}

function! syslib#create_symlink(...) "{{{
    return call('syslib#' . syslib#get_os_name() . '#create_symlink', a:000)
endfunction "}}}

function! syslib#follow_symlink(...) "{{{
    return call('syslib#' . syslib#get_os_name() . '#follow_symlink', a:000)
endfunction "}}}

function! syslib#create_hardlink(...) "{{{
    return call('syslib#' . syslib#get_os_name() . '#create_hardlink', a:000)
endfunction "}}}

" }}}

" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
