" vim:foldmethod=marker:fen:
scriptencoding utf-8

" Load Once {{{
if exists('g:loaded_syslib') && g:loaded_syslib
    finish
endif
let g:loaded_syslib = 1
" }}}
" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}

" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
