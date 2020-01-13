call plug#begin('~/.local/share/nvim/plugged')

Plug 'mxw/vim-jsx'                  " JSX highlighting, for react
Plug 'pangloss/vim-javascript'      " JS syntax and indentation
Plug 'kien/ctrlp.vim'               " CtrlP fuzzy file finder
Plug 'airblade/vim-gitgutter'       " Show git line status in the gutter
Plug 'tpope/vim-fugitive'           " git plugin for git stuff
Plug 'tpope/vim-rhubarb'            " More git stuff
Plug 'Yggdroot/indentLine'          " Indent line guides
Plug 'mg979/vim-visual-multi'       " Multiple cursors
Plug 'tmhedberg/SimpylFold'         " Python folding
Plug 'vim-scripts/indentpython.vim' " Python indentation
Plug 'vim-airline/vim-airline'      " Powerline
Plug 'jparise/vim-graphql'          " Graphql syntax highlighting
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'morhetz/gruvbox'              " Theme
Plug 'elzr/vim-json'                " JSON highlighting
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}

call plug#end()

" Base settings

set number
set expandtab
set autoindent
set nobackup
set backspace=indent,eol,start  " Make backspace work as expected
set mouse=nicr                  " Enables mouse scrolling in vim inside iterm2
set ignorecase
set incsearch                   " Incremental search while typing
set sidescroll=1                " Scroll one char horizontally instead of half page
set sidescrolloff=20            " How many chars away from the edge should start scroll

let g:gruvbox_contrast_dark='hard'
if !("g:syntax_on")
  syntax on
  colorscheme gruvbox
endif

let mapleader=","

let g:python3_host_prog ='/usr/local/opt/pyenv/versions/3.8.0/bin/python'

" Search highlight
set hlsearch

" Default tab sizes
set ts=2 sts=2 sw=2

" Different tab sizes based on filetypes
autocmd Filetype html setlocal ts=2 sts=2 sw=2
autocmd Filetype javascript setlocal ts=2 sts=2 sw=2
autocmd Filetype json setlocal ts=2 sts=2 sw=2
autocmd Filetype css setlocal ts=2 sts=2 sw=2
autocmd Filetype python setlocal ts=4 sts=4 sw=4
autocmd Filetype lua setlocal ts=4 sts=4 sw=4
autocmd Filetype sql setlocal ts=8 sts=8 sw=8

autocmd BufRead,BufNewFile *.kit set filetype=html

" Airline config
""""""""""""""""""""
let g:airline_powerline_fonts = 1

" CtrlP
""""""""""""""""""""""""""""""
" Use ripgrep
set wildignore+=*/.git/*,*/tmp/*,*.swp,*.pyc
set grepprg=rg\ --color=never
let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
let g:ctrlp_use_caching = 0

" Key mappings
""""""""""""""""""""""""""""""
nnoremap <leader>[ :cprev<CR>
nnoremap <leader>] :cnext<CR>
nnoremap <M-j> jzz
nnoremap <M-k> kzz
nmap <silent> <C-h> <Plug>(coc-diagnostic-prev)
nmap <silent> <C-l> <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

let g:VM_default_mappings = 0
let g:VM_maps = {}
let g:VM_maps["Add Cursor Down"] = '<C-J>'
let g:VM_maps["Add Cursor Up"]   = '<C-K>'

" Git Gutter
""""""""""""""""""""""""""""""
let g:gitgutter_override_sign_column_highlight = 0
let g:gitgutter_highlight_linenrs = 1
highlight SignColumn ctermbg=234

highlight GitGutterAdd ctermfg=green
highlight GitGutterChange ctermfg=yellow
highlight GitGutterDelete ctermfg=red
highlight GitGutterChangeDelete ctermfg=magenta

highlight link GitGutterAddLineNr  GitGutterAdd
highlight link GitGutterChangeLineNr  GitGutterChange
highlight link GitGutterDeleteLineNr  GitGutterDelete
highlight link GitGutterChangeDeleteLineNr  GitGutterChangeDelete

nmap <C-d> :GitGutterPreviewHunk<CR>

" Functions
""""""""""""""""""""""""""""""""""
map <Leader>x :call InsertLine()<CR>

autocmd FileType javascript let breakpoint_string=expand("debugger;")
autocmd FileType python     let breakpoint_string=expand("breakpoint()  # noqa: E702 XXX BREAKPOINT!!")

function! InsertLine()
  execute "normal o".g:breakpoint_string
endfunction

" Remember last position
""""""""""""""""""""""""""""""""""
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Highlight trailing whitespace
""""""""""""""""""""""""""""""""""
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

" coc-vim configuration
""""""""""""""""""""""""""""""""""
nmap <C-x> :CocCommand<CR>

set updatetime=300
set cmdheight=2

" Use tab for trigger completion with characters ahead and navigate.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"


" Misc
""""""""""""""""""""""""""""""""""
let g:indentLine_concealcursor=""
autocmd QuickFixCmdPost *Ggrep* cwindow " To automatically open quickfix window after grepping

let g:tagbar_ctags_bin ='/usr/local/Cellar/ctags/5.8_1/bin/ctags'  " Specify a specific ctag version for tagbar
let g:tagbar_width = 60

vmap <C-c> "+y
nmap <C-b> "+p
imap ,, <Esc>
vmap ,, <Esc>

let g:indentLine_char = '│'

let g:gitroot=system("git rev-parse --show-toplevel")
let g:is_gitrepo = v:shell_error == 0

" Folding
" let anyfold_activate=1
set foldlevel=15
hi Folded ctermbg=None
" Enable folding with the spacebar
nnoremap <space> za

command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')
" autocmd BufWritePre *.py :OR

let $NVIM_TUI_ENABLE_TRUE_COLOR=1

let g:gitroot=system("git rev-parse --show-toplevel")
let g:is_gitrepo = v:shell_error == 0
silent! cd `=gitroot`

" Python syntax highlighting customizations
function CustomHighlights()
  hi semshiSelected        ctermfg=159 ctermbg=234 cterm=underline
  hi semshiBuiltin         ctermfg=219
  hi semshiParameter       ctermfg=221
  hi semshiParameterUnused ctermfg=69 cterm=underline
endfunction
autocmd FileType python call CustomHighlights()
