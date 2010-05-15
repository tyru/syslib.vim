" vim:foldmethod=marker:fen:
scriptencoding utf-8

" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}


function! IsLink(path)
    return getftype(a:path) ==# 'link'
    \   || (getftype(a:path) ==# 'file'
    \       && a:path =~? '\.lnk$')
endfunction
function! IsHardLink(path)
    return getftype(a:path) ==# 'file'
endfunction


function! s:run()
    let test_link_path = 'foo_link_test_file'
    let must_exist_file = expand('$MYVIMRC')

    OK getftype(must_exist_file) != '', printf("'%s' exists.", must_exist_file)

    if getftype(test_link_path) != ''
        throw printf("'%s' exists. please remove it for this test.", test_link_path)
    endif

    OK syslib#create_symlink(must_exist_file, test_link_path)
    OK IsLink(test_link_path), printf("'%s' was successfully created.", test_link_path)

    let success = 0
    OK  delete(test_link_path) ==# success, printf("'%s' was successfully deleted.", test_link_path)

    OK syslib#create_hardlink(must_exist_file, test_link_path)
    OK IsHardLink(test_link_path), printf("'%s' was successfully created.", test_link_path)

    let success = 0
    OK  delete(test_link_path) ==# success, printf("'%s' was successfully deleted.", test_link_path)
endfunction

call s:run()
Done

delfunc IsLink
delfunc IsHardLink


" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
