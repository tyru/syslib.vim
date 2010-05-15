" vim:foldmethod=marker:fen:
scriptencoding utf-8

" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}


" `ftype` is not &filetype.
" See :help getftype()


function! s:delete(path) "{{{
    let success = 0
    if getftype(a:path) != '' && delete(a:path) !=# success
        let msg = "can't continue test because I could not delete(%s)."
        let msg = printf(msg, string(a:path))
        throw msg
    endif
endfunction "}}}

function! s:regular_file_test(test_file_name, must_exist_file) "{{{
    call s:delete(a:test_file_name)

    let success = 0
    OK writefile(['hogehoge'], a:test_file_name) ==# success, "creating regular file."

    OK getftype(a:must_exist_file) != '', printf("'%s' exists.", a:must_exist_file)

    OK syslib#is_exist(a:test_file_name)
    OK syslib#is_file(a:test_file_name)
    OK ! syslib#is_dir(a:test_file_name)
    OK ! syslib#is_symlink(a:test_file_name)
    OK ! syslib#is_block_device(a:test_file_name)
    OK ! syslib#is_character_device(a:test_file_name)
    OK ! syslib#is_socket(a:test_file_name)
    OK ! syslib#is_fifo(a:test_file_name)
    OK ! syslib#is_other(a:test_file_name)
endfunction "}}}

function! s:symlink_test(test_file_name, must_exist_file) "{{{
    call s:delete(a:test_file_name)

    OK syslib#create_symlink(a:must_exist_file, a:test_file_name), "syslib#create_symlink()"

    OK syslib#is_exist(a:test_file_name)
    OK ! syslib#is_file(a:test_file_name)
    OK ! syslib#is_dir(a:test_file_name)
    OK syslib#is_symlink(a:test_file_name)
    OK ! syslib#is_block_device(a:test_file_name)
    OK ! syslib#is_character_device(a:test_file_name)
    OK ! syslib#is_socket(a:test_file_name)
    OK ! syslib#is_fifo(a:test_file_name)
    OK ! syslib#is_other(a:test_file_name)
endfunction "}}}

function! s:hardlink_test(test_file_name, must_exist_file) "{{{
    call s:delete(a:test_file_name)

    OK syslib#create_hardlink(a:must_exist_file, a:test_file_name), "syslib#create_hardlink()"

    OK syslib#is_exist(a:test_file_name)
    OK syslib#is_file(a:test_file_name)
    OK ! syslib#is_dir(a:test_file_name)
    OK ! syslib#is_symlink(a:test_file_name)
    OK ! syslib#is_block_device(a:test_file_name)
    OK ! syslib#is_character_device(a:test_file_name)
    OK ! syslib#is_socket(a:test_file_name)
    OK ! syslib#is_fifo(a:test_file_name)
    OK ! syslib#is_other(a:test_file_name)
endfunction "}}}

function! s:run() "{{{
    let test_file_name = '03-test-foo'
    let must_exist_file = expand('$MYVIMRC')

    call s:regular_file_test(test_file_name, must_exist_file)

    if syslib#supported_symlink()
        call s:symlink_test(test_file_name, must_exist_file)
    endif

    if syslib#supported_hardlink()
        call s:hardlink_test(test_file_name, must_exist_file)
    endif

    call s:delete(test_file_name)
endfunction "}}}

call s:run()
Done


" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
