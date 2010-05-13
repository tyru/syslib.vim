" vim:foldmethod=marker:fen:
scriptencoding utf-8

" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}



function! s:run()
    call syslib#load()

    let deserialize = simpletap#util#get_local_func('/autoload/syslib\.vim$', 'deserialize')
    if deserialize == ''
        throw "Can't get s:deserialize() Funcref"
    endif
    let Fn_deserialize = function(deserialize)
    IsDeeply Fn_deserialize("foo\xFFbar\xFF\xFF"), ['foo', 'bar']
    IsDeeply Fn_deserialize("foo\xFFbar\xFFb\xFE\xFEa\xFE\xFFz\xFF\xFF"), ['foo', 'bar', "b\xFEa\xFFz"]

    let serialize = simpletap#util#get_local_func('/autoload/syslib.vim$', 'serialize')
    if serialize == ''
        throw "Can't get s:serialize() Funcref"
    endif
    let Fn_serialize = function(serialize)
    Is Fn_serialize(['foo', 'bar']), "foo\xFFbar\xFF\xFF"
    Is Fn_serialize(['foo', 'bar', "b\xFEa\xFFz"]), "foo\xFFbar\xFFb\xFE\xFEa\xFE\xFFz\xFF\xFF"
endfunction

call s:run()
Done


" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
