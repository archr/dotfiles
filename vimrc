" Specify a directory for plugins (for Neovim: ~/.local/share/nvim/plugged)
call plug#begin('~/.vim/plugged')

Plug 'godlygeek/tabular'
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'kien/ctrlp.vim'
Plug 'JazzCore/ctrlp-cmatcher'
Plug 'wakatime/vim-wakatime'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'scrooloose/syntastic'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'jiangmiao/auto-pairs'
Plug 'scrooloose/nerdtree'
Plug 'Shougo/neocomplete.vim'
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'
Plug 'mileszs/ack.vim'
Plug 'gcmt/wildfire.vim'
Plug 'tpope/vim-fugitive'
Plug 'mattn/emmet-vim', { 'for': ['javascript.jsx', 'html', 'css'] }
Plug 'sbdchd/neoformat'
Plug 'digitaltoad/vim-pug'
Plug 'chriskempson/base16-vim'
Plug 'tpope/vim-rhubarb'
Plug 'machakann/vim-highlightedyank'
Plug 'liuchengxu/space-vim-dark'
Plug 'colepeters/spacemacs-theme.vim'
Plug 'easymotion/vim-easymotion'

" javascript
Plug 'pangloss/vim-javascript', { 'for': ['javascript', 'javascript.jsx'] }
Plug 'elzr/vim-json', { 'for': 'json' }
Plug 'mxw/vim-jsx', { 'for': ['javascript', 'javascript.jsx'] }
Plug 'othree/javascript-libraries-syntax.vim', { 'for': ['javascript', 'javascript.jsx'] }

" elixir
Plug 'elixir-lang/vim-elixir', { 'for': 'elixir' }

Plug 'gcorne/vim-sass-lint'

call plug#end()

" Configuration
syntax on

filetype on
filetype plugin on
filetype indent on

let mapleader = ','

colorscheme default
set background=dark
set mouse=a
set tabstop=2
set shiftwidth=2
set expandtab
set nospell
set encoding=utf-8
set nowrap
set backspace=indent,eol,start
set cursorline
set number
set incsearch
set hlsearch
set ignorecase
set smartcase
set wildmenu
set wildmode=list:longest,full
set whichwrap=b,s,h,l,<,>,[,]
set list
set listchars=tab:›\ ,trail:•,extends:#,nbsp:.
set clipboard=unnamed
set autoindent
set smartindent
set splitright
set undofile
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set undodir=~/.vim-tmp
set nobackup
set noswapfile
set nowritebackup
set relativenumber

" Color colum max 120
" set colorcolumn=120
" highlight ColorColumn ctermbg=gray
let g:highlightedyank_highlight_duration = 400
map y <Plug>(highlightedyank)

command WQ wq
command Wq wq
command W w
command Q q

map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Remove whitespaces
fun! <SID>StripTrailingWhitespaces()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfun

autocmd FileType javascript,css autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()

" vim-jsx
let g:jsx_ext_required = 0

" vim-airline
set laststatus=2
let g:airline_powerline_fonts=1
let g:airline_theme= 'powerlineish'

" syntastic
let g:syntastic_sass_checkers=["sasslint"]
let g:syntastic_scss_checkers=["sasslint"]
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_javascript_eslint_exec = 'eslint_d'
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" ctrlp.vim
map <leader>lc :CtrlP<CR><C-\>c
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_show_hidden = 1
let g:ctrlp_custom_ignore = {
   \ 'dir': 'node_modules\|DS_Store$\|bower_components\|public\|.git$\|.happypack'
   \ }

" ack.vim
let g:ackprg = 'ag --nogroup --nocolor --column'
let g:ackhighlight = 1
let g:ack_autoclose = 1

noremap <Leader>a :Ack <cword><cr>

" nerdtree
map <C-n> :NERDTreeToggle<CR>
map <leader>e :NERDTreeFind<CR>
let NERDTreeIgnore=['\.py[cd]$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$', 'node_modules', 'public', 'build', 'bower_components', '.DS_Store', '\.sublime-project$', '\.sublime-workspace$', 'dist']
let NERDTreeChDirMode=0
let NERDTreeQuitOnOpen=1

" vim-indent-guides
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_enable_on_vim_startup = 1

" javascript-libraries-syntax.vim
let g:used_javascript_libs = 'underscore,react,chai'

" neocomplete.vim
let g:acp_enableAtStartup = 0
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#sources#dictionary#dictionaries = {
      \ 'default' : '',
      \ 'vimshell' : $HOME.'/.vimshell_hist',
      \ 'scheme' : $HOME.'/.gosh_completions'
      \ }

if !exists('g:neocomplete#keyword_patterns')
  let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"

" neosnippet.vim
let g:neosnippet#enable_snipmate_compatibility = 1
let g:neosnippet#snippets_directory='~/dev/github/vim-snippets'

imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" emmet-vim
let g:user_emmet_settings = {
      \  'javascript.jsx' : {
      \      'extends' : 'jsx',
      \    'quote_char': "'",
      \  },
      \}

" neoformat
let g:neoformat_javascript_standard = {
      \ 'exe': 'prettier-standard',
      \ 'args': ['--stdin'],
      \ 'stdin': 1,
      \ }

let g:neoformat_enabled_javascript = ['eslint_d']
:nmap <C-i> :Neoformat<CR>

" wakatime
let g:wakatime_PythonBinary = '/usr/bin/python'  " (Default: 'python')

if has('gui_running')
  set noeb vb t_vb=
  set anti enc=utf-8
  set guifont=Roboto\ Mono\ for\ Powerline:h14
  set lines=80 columns=180 linespace=0
  set transparency=2
  colorscheme space-vim-dark
  let g:airline_theme='minimalist'
  let g:space_vim_dark_background = 234
  hi Comment cterm=italic
endif

