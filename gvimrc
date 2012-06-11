set vb noeb t_vb= " disable beep and flash
set guiheadroom=0 " no headroom
set guioptions-=T " no toolbar
set guioptions-=t " no tearoff menu items
set guioptions-=m " no menu bar
set guioptions-=r " no right scrollbar
set guioptions-=L " no left scrollbar
set guioptions-=e " no gui tabs
set guioptions+=c " use console dialog for simple choices

if has('win32')
    set guifont=Consolas:h11:cRUSSIAN
endif

