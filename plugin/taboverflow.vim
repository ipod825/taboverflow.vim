if exists('g:taboveflow#loaded')
  finish
endif

let g:taboveflow#loaded = 1

let s:save_cpo = &cpo
set cpo&vim

noremap <silent> <unique> <script> <Plug>TabMovePrev :call taboverflow#movetab(-1)<cr>
noremap <silent> <unique> <script> <Plug>TabMoveNext :call taboverflow#movetab(1)<cr>

let g:TaboverflowLabel = get(g:, 'TaboverflowLabel', function('taboverflow#defaultlabelfn'))

augroup taboverflow
    autocmd!
    autocmd VimEnter * set tabline=%!taboverflow#tabline()
augroup END


let &cpo = s:save_cpo
unlet s:save_cpo
