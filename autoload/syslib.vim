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

    function! syslib#supported_symlink()
        return 0
    endfunction
    function! syslib#supported_hardlink()
        return 0
    endfunction
elseif has('win32unix')
    " cygwin
    function! syslib#get_os_name()
        return 'cygwin'
    endfunction

    function! syslib#supported_symlink()
        return 0
    endfunction
    function! syslib#supported_hardlink()
        return 0
    endfunction
elseif has('unix')
    " Unix like environment
    function! syslib#get_os_name()
        return 'unix'
    endfunction

    function! syslib#supported_symlink()
        return 1
    endfunction
    function! syslib#supported_hardlink()
        return 1
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

" TODO
" - rename_directory()
" - open_file_fd()
" - close_file_fd()
" - seek_file_fd()
" - read_file_fd()
" - write_file_fd()
" - flush_file_fd()

" Functions {{{

function! syslib#load() "{{{
    " dummy function to load this file.
endfunction "}}}



" Wrapper for built-in functions.
function! syslib#create_directory(name, ...) "{{{
    try
        return call('mkdir', [a:name, ''] + a:000)
    catch /E739:/    " Can't create directory.
        return 0
    endtry
endfunction "}}}

function! syslib#create_path(name, ...) "{{{
    try
        return call('mkdir', [a:name, 'p'] + a:000)
    catch /E739:/    " Can't create directory.
        return 0
    endtry
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



function! syslib#is_exist(name) "{{{
    return getftype(a:name) != ''
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



function! syslib#get_current_errno() "{{{
    return syslib#_libcallnr('get_current_errno', [])
endfunction "}}}

function! syslib#get_last_errno() "{{{
    return syslib#_libcallnr('get_last_errno', [])
endfunction "}}}

function! syslib#remove_directory(name) "{{{
    return syslib#_libcallnr('remove_directory', [a:name])
endfunction "}}}

function! syslib#create_symlink(path, symlink_path) "{{{
    return syslib#_libcallnr('create_symlink', [a:path, a:symlink_path])
endfunction "}}}

function! syslib#create_hardlink(path, hardlink_path) "{{{
    return syslib#_libcallnr('create_hardlink', [a:path, a:hardlink_path])
endfunction "}}}



function! syslib#_libcall(...) "{{{
    return s:deserialize(call('s:libcall', [0] + a:000))
endfunction "}}}

function! syslib#_libcallnr(...) "{{{
    return call('s:libcall', [1] + a:000)
endfunction "}}}

function! s:libcall(libcallnr, funcname, args) "{{{
    return call(
    \   (a:libcallnr ? 'libcallnr' : 'libcall'),
    \   [
    \       g:syslib_dll_path,
    \       'syslib_' . a:funcname,
    \       (empty(a:args) ? '' : s:serialize(a:args)),
    \   ]
    \)
endfunction "}}}

function! s:serialize(args) "{{{
    if type(a:args) != type([]) || empty(a:args)
        throw printf('syslib: s:serialize(): invalid argument')
    elseif len(a:args) == 1
        " Do not serialize one argument; it is wasteful.
        " C function which has one argument receives raw argument, not serialized.
        return a:args[0]
    else
        let ret = ''
        for arg in a:args
            let ret .= nr2char(type(arg))
            for c in split(arg, '\zs')
                if c ==# "\xFF"    " separator
                    let ret .= "\xFE\xFF"
                elseif c ==# "\xFE"    " escape character
                    let ret .= "\xFE\xFE"
                else
                    let ret .= c
                endif
            endfor
            let ret .= "\xFF"
        endfor
        return ret . "\xFF"    " \xFF\xFF at the end of data.
    endif
endfunction "}}}
function! s:deserialize(bytes) "{{{
    if type(a:bytes) != type("") || strlen(a:bytes) == 0
        throw printf('syslib: s:deserialize(): invalid argument')
    else
        let cur_arg = ''
        let cur_type = char2nr(a:bytes[0])
        let ret = []
        let pos = 1
        let len = strlen(a:bytes)
        let invalid_argument = 'syslib: s:deserialize(): invalid byte sequence'
        while pos < len
            let char      = a:bytes[pos]
            let next_char = a:bytes[pos + 1]

            if char ==# "\xFE"    " escape character
                if pos + 1 >= len
                    throw invalid_argument . " - No more bytes"
                elseif next_char ==# "\xFE"
                    let cur_arg .= "\xFE"
                    let pos += 2
                    continue
                elseif next_char ==# "\xFF"
                    let cur_arg .= "\xFF"
                    let pos += 2
                    continue
                else
                    throw invalid_argument . " - Escaped but not special character"
                endif
            elseif char ==# "\xFF"    " separator
                call add(ret, s:convert_type(cur_arg, cur_type))
                if next_char ==# "\xFF"
                    return ret
                endif
                let cur_arg = ''
                let cur_type = char2nr(next_char)
                let pos += 2
            else
                let cur_arg .= char
                let pos += 1
            endif
        endwhile
        throw invalid_argument . " - End of bytes"
    endif
endfunction "}}}
function! s:convert_type(bytes, type) "{{{
    if a:type == type(0)
        return str2nr(a:bytes)
    elseif a:type == type("")
        return a:bytes
    " elseif a:type == type(function('tr'))
    " elseif a:type == type([])
    " elseif a:type == type({})
    elseif a:type == type(0.0)
        return str2float(a:bytes)
    else
        throw "s:convert_type() - invalid type"
    endif
endfunction "}}}

" }}}

" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
