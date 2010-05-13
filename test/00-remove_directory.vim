" vim:foldmethod=marker:fen:
scriptencoding utf-8

" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}


function! s:rmdir(dir) "{{{
    if has('unix')
        call system('rmdir ' . shellescape(a:dir))
    elseif has('win32') || has('win64')
        " XXX: I haven't tested on windows yet. so this might be wrong.
        call system('system rmdir /Q /s ' . shellescape(a:dir))
    else
        Skip "sorry, your platform can't perform this test."
    endif
endfunction "}}}

function! s:run()
    let test_dir = 'foo'
    let fullpath_test_dir = getcwd() . '/' . test_dir

    " Remove `test_dir` if it exists.
    if getftype(test_dir) != ''
        if isdirectory(test_dir)
            call s:rmdir(test_dir)
            if isdirectory(test_dir)
                throw printf("can't remove directory '%s'...", test_dir)
            endif
        else
            Diag printf("%s '%s' exists. Remove or move it.", getftype(test_dir), fullpath_test_dir)
            throw fullpath_test_dir . " exists."
        endif
    endif

    " Create `test_dir`.
    try
        call mkdir(test_dir)
    catch
        ShowStackTrace!
    endtry
    OK isdirectory(test_dir), printf("directory '%s' was successfully created.", fullpath_test_dir)

    " Remove `test_dir`.
    call syslib#remove_directory(test_dir)
    OK !isdirectory(test_dir), printf("directory '%s' was successfully deleted.", fullpath_test_dir)
endfunction

call s:run()
Done


" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
