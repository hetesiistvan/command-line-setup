set number
set cursorline

" Tab settings
set tabstop=4
" Enabling tab replacement for the scripts
autocmd BufNewFile,BufRead,BufReadPost *.lib set shiftwidth=4
autocmd BufNewFile,BufRead,BufReadPost *.lib set expandtab
autocmd BufNewFile,BufRead,BufReadPost *.lib set filetype=bash
autocmd BufNewFile,BufRead,BufReadPost *.lib set syntax=bash
autocmd BufNewFile,BufRead,BufReadPost *.sh set shiftwidth=4
autocmd BufNewFile,BufRead,BufReadPost *.sh set expandtab
autocmd BufNewFile,BufRead,BufReadPost *.sh set filetype=bash
" Enabling tab replacement for the Terraform files
autocmd BufNewFile,BufRead,BufReadPost *.tf set shiftwidth=2
autocmd BufNewFile,BufRead,BufReadPost *.tf set expandtab
autocmd BufNewFile,BufRead,BufReadPost *.tf set filetype=tf

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
Plug 'akinsho/bufferline.nvim', { 'tag': 'v2.*' }
Plug 'iamcco/markdown-preview.nvim'

call plug#end()

" NERDTree configuration
let NERDTreeWinSize=50
let NERDTreeShowHidden=1
let NERDTreeMinimalUI=1
let NERDTreeShowBookmarks=1
let NERDTreeShowLineNumbers=1
" Automatically start NERDTree
"autocmd VimEnter * NERDTree | wincmd p
" Start NERDTree when Vim is started without file arguments.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif
"autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | wincmd p | endif
" Open the existing NERDTree on each new tab.
"autocmd BufWinEnter * if getcmdwintype() == '' | silent NERDTreeMirror | endif
" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
" NERDTree Git plugin configuration
let g:NERDTreeGitStatusUseNerdFonts = 1
" Toggle NERDTree
autocmd VimEnter * nnoremap <silent> _n :NERDTreeToggle<CR>

" Color settings
set termguicolors
let g:solarized_visibility = 'low'
colorscheme solarized
autocmd VimEnter * nnoremap _<F3> :let g:solarized_visibility='normal'<CR>:colorscheme solarized<CR>
autocmd VimEnter * nnoremap _<F4> :let g:solarized_visibility='low'<CR>:colorscheme solarized<CR>

" Git gutter
set updatetime=1000
" autocmd VimEnter * GitGutterLineHighlightsEnable
autocmd VimEnter * GitGutterLineNrHighlightsEnable

" Taglist settings
let Tlist_Use_Right_Window = 1
let Tlist_Close_On_Select = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_Show_One_File = 1
autocmd VimEnter * nnoremap <silent> _l :TlistToggle<CR>

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
autocmd VimEnter * nnoremap <silent> _f :Files<CR>
autocmd VimEnter * nnoremap <silent> _a :Ag <C-R><C-W><CR>
autocmd VimEnter * vnoremap _a y:Ag <C-R>"<CR>
let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -l -g ""'

" Generic keyboard shortcuts
autocmd VimEnter * map <silent> _c :let @/=""<CR>
autocmd VimEnter * nnoremap <silent> _s /<C-R><C-W><CR>N
autocmd VimEnter * vnoremap <silent> _s y/<C-R>"<CR>N
autocmd VimEnter * nnoremap <silent> _1 :tabnext 1<CR>
autocmd VimEnter * nnoremap <silent> _2 :tabnext 2<CR>
autocmd VimEnter * nnoremap <silent> _3 :tabnext 3<CR>
autocmd VimEnter * nnoremap <silent> _4 :tabnext 4<CR>
autocmd VimEnter * nnoremap <silent> _5 :tabnext 5<CR>
autocmd VimEnter * nnoremap <silent> _6 :tabnext 6<CR>
autocmd VimEnter * nnoremap <silent> _7 :tabnext 7<CR>
autocmd VimEnter * nnoremap <silent> _8 :tabnext 8<CR>
autocmd VimEnter * nnoremap <silent> _9 :tabnext 9<CR>
autocmd VimEnter * nnoremap <silent> _q :tabdo q<CR>
autocmd VimEnter * nnoremap <silent> _tn :tabnew<CR>
autocmd VimEnter * nnoremap <silent> _tl :tablast<CR>

" Config editing
autocmd VimEnter * nnoremap _<F1> :e ~/.config/nvim/init.vim<CR>
autocmd VimEnter * nnoremap _<F2> :source ~/.config/nvim/init.vim<CR>

lua << EOF
require('bufferline').setup {
		options = {
				mode = "tabs",
				numbers = "ordinal"
				}
		}
EOF

