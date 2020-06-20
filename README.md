taboverflow.vim
=============

![Screenshot](https://user-images.githubusercontent.com/1246394/85211803-98e97f80-b301-11ea-8e84-25a8041a9337.png)

taboverflow.vim deals with the problem that the current tab becomes invisible in the tabline when there are too many tabs. Users can fully customize it by implementing a `label` function.

## Installation
------------

Using vim-plug

```viml
Plug 'ipod825/taboverflow.vim'
```

## Customization
------------
Implement `g:TaboverflowLabel` returning the string for each tab.
```vim
" This is the default implementation
function s:MyTabLabel(n)
    let buflist = tabpagebuflist(a:n)
    let winnr = tabpagewinnr(a:n)
    let res = '%#Search#'.taboverflow#unicode_num(a:n)
    if a:n == tabpagenr()
        let res .= '%#TabLineSel#'
    else
        let res .= '%#TabLine#'
    endif
    let res .= fnamemodify(bufname(buflist[winnr - 1]), ':t')
    return res
endfunction
let g:TaboverflowLabel = function('s:MyTabLabel')

" This mappings are for moving tabs arounbd.
nmap <c-m-h> <Plug>TabMovePrev
nmap <c-m-l> <Plug>TabMoveNext
```
## Related
------------
- [taboo.vim](https://github.com/gcmt/taboo.vim)
- [vim-xtabline](https://github.com/mg979/vim-xtabline)
