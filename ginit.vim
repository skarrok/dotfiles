if exists("g:neovide")
  set guifont=Cascadia\ Code:h13
  let g:neovide_cursor_animation_length=0
  let g:neovide_cursor_vfx_mode=""
else " neovim-qt
  GuiFont Hack:h10
  GuiTabline 0
  GuiPopupmenu 0
endif
