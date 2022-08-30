""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" ==> Setting for neovim-qt
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Disable qt popup
GuiPopupmenu 0

" Enable line
GuiLinespace 1

" Disable qt tab line 
GuiTabline 0

" Set format of tab name 
set guitablabel=\[%N\]\ %t\ %M 

"Set Font
set guifont=Fira\ Code:h10
set guifont=Fira\ Code:10

" Set key map to paste 
inoremap <silent> <S-Insert> <C-R>+
