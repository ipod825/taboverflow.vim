function! taboverflow#movetab(dir)
    let cur_tab = tabpagenr()
    let next_tab = cur_tab + a:dir
    let last_tab = tabpagenr('$')

    if next_tab == 0
        exec 'tabmove '.last_tab
    elseif next_tab > last_tab
        tabmove 0
    else
        let dir = a:dir>0?'+'.a:dir:a:dir
        exec 'tabmove '.dir
    endif
endfunction

function! taboverflow#reducetabs(tabs, total_size)
    let max_width = &columns-1
    if a:total_size <= max_width
        return a:tabs
    endif

    let tabs = a:tabs
    let last_tab = tabpagenr('$')
    let cur = tabpagenr()-1
    let left = cur
    let right = (left + 1)%last_tab
    let accepted_tabs = []
    let cur_width = 0
    let fail = 0

    while fail<2 && !tabs[cur].checked
        if cur_width + tabs[cur].width > max_width
            let fail += 1
            if fail == 2
                if cur == left
                    call insert(accepted_tabs, tabs[cur], 0)
                else
                    call add(accepted_tabs, tabs[cur])
                endif
                break
            else
                let cur = cur==left?right:left
                continue
            endif
        endif

        let tabs[cur].checked = v:true
        let cur_width += tabs[cur].width
        if cur == left
            call insert(accepted_tabs, tabs[cur], 0)
            let left = (left-1+last_tab)%last_tab
            let cur = right
        else
            call add(accepted_tabs, tabs[cur])
            let right = (right+1)%last_tab
            let cur = left
        endif
    endwhile
    return accepted_tabs
endfunction

function! taboverflow#calcwidth(content)
    let content = substitute(a:content, '%#[^#]*#', '', 'g')
    return strwidth(content)
endfunction

function! taboverflow#tabline()
    let tabs = []
    let total_size = 0
    for i in range(tabpagenr('$'))
        let content = g:TaboverflowLabel(i+1)
        call add(tabs, {'content': content,
                    \'width': taboverflow#calcwidth(content),
                    \'checked':v:false})
        let total_size += tabs[-1].width
    endfor
    let tabs = taboverflow#reducetabs(tabs, total_size)

    let s = ''
    for tab in tabs
        let s .= tab.content
    endfor
    let s .= '%#TabLineFill#%T'
    return s
endfunction

function! taboverflow#defaultlabelfn(n)
    let buflist = tabpagebuflist(a:n)
    let winnr = tabpagewinnr(a:n)
    let res = '%#Visual#'.taboverflow#unicode_num(a:n)
    if a:n == tabpagenr()
        let res .= '%#TabLineSel#'
    else
        let res .= '%#TabLine#'
    endif
    let bufnr = buflist[winnr - 1]
    if getbufvar(bufnr, '&modified') == 1
        let res .= '*'
    endif
    let bufname = fnamemodify(bufname(bufnr), ':t')
    if empty(bufname)
        let bufname = '[No Name]'
    endif
    let res .= bufname
    return res
endfunction


fu taboverflow#unicode_num(number)
    let unicode_number = ""
    let small_numbers = ["⁰", "¹", "²", "³", "⁴", "⁵", "⁶", "⁷", "⁸", "⁹"]
    let number_str    = string(a:number)
    for i in range(0, len(number_str) - 1)
        let unicode_number .= small_numbers[str2nr(number_str[i])]
    endfor
    return unicode_number
endfu
