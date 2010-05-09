" vim:foldmethod=marker:fen:
scriptencoding utf-8

" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}

" Functions {{{

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

" }}}

" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
