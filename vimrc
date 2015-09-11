" Neobundle configuration
if has('vim_starting')
  if &compatible
    set nocompatible
  endif

  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neoBundle.vim', 'master'

NeoBundle 'Shougo/vimproc.vim', {
  \ 'build' : {
  \     'windows' : 'make -f make_mingw32.mak',
  \     'cygwin' : 'make -f make_cygwin.mak',
  \     'mac' : 'make -f make_mac.mak',
  \     'unix' : 'make_unix.mak',
  \   },
  \ }

NeoBundle 'chriskempson/base16-vim'
NeoBundle 'bling/vim-airline'
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'jistr/vim-nerdtree-tabs'
NeoBundle 'JazzCore/ctrlp-cmatcher', {'build':{'unix': './install.sh'}}
NeoBundle 'wakatime/vim-wakatime'
NeoBundle 'nathanaelkane/vim-indent-guides'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'airblade/vim-gitgutter'
NeoBundle 'kristijanhusak/vim-multiple-cursors'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-repeat'
NeoBundle 'jiangmiao/auto-pairs'
NeoBundle 'Shougo/neocomplete.vim'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'

NeoBundle 'mxw/vim-jsx'
NeoBundle 'archr/javascript-libraries-syntax.vim'
NeoBundle 'archr/yajs.vim'
NeoBundle 'pangloss/vim-javascript'
NeoBundleLazy 'elzr/vim-json', {'autoload': {'filetypes': ['json']}}
NeoBundleLazy 'mattn/emmet-vim', {'autoload':{'filetypes':['html','css', 'javascript']}}

call neobundle#end()
NeoBundleCheck

syntax on

filetype on
filetype plugin on
filetype indent on

set t_Co=256
colorscheme base16-tomorrow
let base16colorspace=256
set background=dark
set guifont=Input\ Mono:13

set tabstop=2
set shiftwidth=2
set expandtab
set nospell
set encoding=utf-8

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
set foldenable
set list
set listchars=tab:›\ ,trail:•,extends:#,nbsp:.
set clipboard=unnamed

let mapleader = ','

set undofile
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set undodir=~/.vim-tmp
set nobackup
set noswapfile
set nowritebackup


autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS

fun! <SID>StripTrailingWhitespaces()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfun

autocmd FileType javascript,css autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()

" ctrlp.vim
let g:ctrlp_match_window_bottom = 1
let g:ctrlp_match_window_reversed = 0

let g:ctrlp_match_window_reversed = 0
let g:ctrlp_match_func = {'match' : 'matcher#cmatch' }

let g:ctrlp_custom_ignore = {
  \ 'dir': 'node_modules\|\.DS_Store$\|bower_components\|public\|\.git$'
  \ }

" vim-airline
set laststatus=2
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme= 'powerlineish'


" syntastic
let g:syntastic_javascript_checkers = ['eslint']


" netrw
let g:netrw_liststyle = 3
let g:netrw_list_hide = ".git,.sass-cache,.jpg,.png,.svg,.DS_Store,node_modules,.ebextensions,build,bower_components"
let g:netrw_preview = 1

" vim-indent-guides
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_enable_on_vim_startup = 1

" neocomplete.vim
let g:acp_enableAtStartup = 0
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#enable_auto_delimiter = 1
let g:neocomplete#max_list = 15
let g:neocomplete#force_overwrite_completefunc = 1

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
  \ 'default' : '',
  \ 'vimshell' : $HOME.'/.vimshell_hist',
  \ 'scheme' : $HOME.'/.gosh_completions'
  \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
  let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplete#close_popup() . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplete#close_popup()
inoremap <expr><C-e>  neocomplete#cancel_popup()

if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif


" nerdtree
map <C-e> <plug>NERDTreeTabsToggle<CR>
map <leader>e :NERDTreeFind<CR>
nmap <leader>nt :NERDTreeFind<CR>

let NERDTreeShowBookmarks=1
let NERDTreeIgnore=['\.py[cd]$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$', 'node_modules', 'public', 'build', 'bower_components', '.DS_Store', '\.sublime-project$', '\.sublime-workspace$', 'dist']
let NERDTreeChDirMode=0
let NERDTreeQuitOnOpen=1
let NERDTreeMouseMode=2
let NERDTreeShowHidden=1
let NERDTreeKeepTreeInNewTab=1
let g:nerdtree_tabs_open_on_gui_startup=0


" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
"imap <expr><TAB>
" \ pumvisible() ? "\<C-n>" :
" \ neosnippet#expandable_or_jumpable() ?
" \    "\<TAB>" : "\<Plug>(neosnippet_expand_or_jump)"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif


let g:neosnippet#enable_snipmate_compatibility = 1
let g:neosnippet#snippets_directory='~/dev/github/vim-snippets'
