" vim:foldmethod=marker:fen:
scriptencoding utf-8

" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}



function! s:run()
    call syslib#load()

    let Fn_deserialize = simpletap#util#get_local_func('/autoload/syslib.vim$', 'deserialize')
    if type(Fn_deserialize) != type(function('tr'))
        throw "Can't get s:deserialize() Funcref"
    endif
    Is Fn_deserialize("foo\xFFbar\xFF\xFF"), ['foo', 'bar']
    Is Fn_deserialize("foo\xFFbar\xFFb\xFE\xFEa\xFE\xFFz\xFF\xFF"), ['foo', 'bar', "b\xFEa\xFFz"]

    let Fn_serialize = simpletap#util#get_local_func('/autoload/syslib.vim$', 'serialize')
    if type(Fn_serialize) != type(function('tr'))
        throw "Can't get s:serialize() Funcref"
    endif
    Is Fn_serialize(['foo', 'bar']), "foo\xFFbar\xFF\xFF"
    Is Fn_serialize(['foo', 'bar', "b\xFEa\xFFz"]), "foo\xFFbar\xFFb\xFE\xFEa\xFE\xFFz\xFF\xFF"
endfunction

call s:run()
Done


" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
