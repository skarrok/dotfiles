if exists("g:neovide")
  set guifont=CaskaydiaCove\ NFP,Cascadia\ Code:h13
  set clipboard= " fix for yyp
  let g:neovide_cursor_animation_length=0
  let g:neovide_cursor_vfx_mode=""
else " neovim-qt
  "GuiFont Hack:h13
  GuiFont! CaskaydiaCove Nerd Font:h13
  GuiTabline 0
  GuiPopupmenu 0
  GuiRenderLigatures 1
endif
