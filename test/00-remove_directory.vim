" vim:foldmethod=marker:fen:
scriptencoding utf-8

" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}


function! s:remove_directory(dir) "{{{
    if has('unix')
        call system('rmdir ' . shellescape(a:dir))
    elseif has('win32') || has('win64')
        " XXX: I don't test on windows. so this might be wrong.
        call system('system rmdir /Q /s ' . shellescape(a:dir))
    else
        Skip "sorry, your platform can't perform this test."
    endif
endfunction "}}}

function! s:run()
    let test_dir = 'foo'

    if isdirectory(test_dir)
        call s:remove_directory(test_dir)
        if isdirectory(test_dir)
            throw printf("can't delete directory '%s'...", test_dir)
        endif
    endif

    call mkdir(test_dir)
    OK isdirectory(test_dir), printf("directory '%s' was successfully created.", getcwd() . '/' . test_dir)

    call syslib#remove_directory(test_dir)
    OK !isdirectory(test_dir), printf("directory '%s' was deleted.", test_dir)
endfunction

call s:run()
Done


" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
