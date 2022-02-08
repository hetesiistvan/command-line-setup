set number
set cursorline

" Tab settings
set tabstop=4
" Enabling tab replacement for the scripts
autocmd BufNewFile,BufRead,BufReadPost *.lib set shiftwidth=4
autocmd BufNewFile,BufRead,BufReadPost *.lib set expandtab
autocmd BufNewFile,BufRead,BufReadPost *.sh set shiftwidth=4
autocmd BufNewFile,BufRead,BufReadPost *.sh set expandtab

" Displaying whitespace
set list
"set listchars=nbsp:_,tab:>-,trail:~,extends:>,precedes:<
set listchars=space:.,nbsp:.,multispace:-,tab:\\u21A3\\u00B7,trail:.,conceal:*,extends:\\u1433,precedes:\\u1438

" Plugin configuration
call plug#begin('~/.config/nvim/plugged')

Plug 'scrooloose/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ishan9299/nvim-solarized-lua'
Plug 'airblade/vim-gitgutter'
Plug 'doronbehar/nvim-fugitive'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'vim-scripts/taglist.vim'
Plug 'dense-analysis/ale'
Plug 'jiangmiao/auto-pairs'

call plug#end()

" NERDTree configuration
let NERDTreeWinSize=50
let NERDTreeShowHidden=1
let NERDTreeMinimalUI=1
let NERDTreeShowBookmarks=1
" Automatically start NERDTree
"autocmd VimEnter * NERDTree | wincmd p
" Start NERDTree when Vim is started without file arguments.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | wincmd p | endif
" Open the existing NERDTree on each new tab.
autocmd BufWinEnter * if getcmdwintype() == '' | silent NERDTreeMirror | endif
" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
" NERDTree Git plugin configuration
let g:NERDTreeGitStatusUseNerdFonts = 1
" Toggle NERDTree
autocmd VimEnter * nnoremap ,n :NERDTreeToggle<CR>

" Color settings
set termguicolors
let g:solarized_visibility = 'low'
colorscheme solarized

" Git gutter
set updatetime=1000
" autocmd VimEnter * GitGutterLineHighlightsEnable
autocmd VimEnter * GitGutterLineNrHighlightsEnable

" Taglist settings
let Tlist_Use_Right_Window = 1
autocmd VimEnter * nnoremap ,t :TlistToggle<CR>

" ALE settings
let g:ale_fix_on_save = 1
let g:ale_fixers = {
\   '*': ['trim_whitespace'],
\   'sh': ['shfmt'],
\   'lib': ['shfmt'],
\   'tf': ['terraform'],
\}
let g:ale_sh_shfmt_options = "-i 4"

" FZF settings
autocmd VimEnter * nnoremap ,f :Files<CR>
autocmd VimEnter * nnoremap ,a :Ag <C-R><C-W><CR>
autocmd VimEnter * vnoremap ,a y:Ag <C-R>"<CR>

" *.lib extension
autocmd BufNewFile,BufRead,BufReadPost *.lib set syntax=bash

" Generic keyboard shortcuts
autocmd VimEnter * map ,c :let @/=""<CR>

" Config editing
autocmd VimEnter * nnoremap ,<F1> :e ~/.config/nvim/init.vim<CR>
autocmd VimEnter * nnoremap ,<F2> :source ~/.config/nvim/init.vim<CR>

