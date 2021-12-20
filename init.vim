set number
set cursorline

" Plugin configuration
call plug#begin('~/.config/nvim/plugged')

Plug 'scrooloose/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'Xuyuanp/nerdtree-git-plugin'

call plug#end()

" NERDTree configuration
let NERDTreeWinSize=50
let NERDTreeShowHidden=1
let NERDTreeMinimalUI=1
let NERDTreeShowBookmarks=1
" Automatically start NERDTree
autocmd VimEnter * NERDTree | wincmd p
" Open the existing NERDTree on each new tab.
autocmd BufWinEnter * if getcmdwintype() == '' | silent NERDTreeMirror | endif
" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
" NERDTree Git plugin configuration
let g:NERDTreeGitStatusUseNerdFonts = 1

