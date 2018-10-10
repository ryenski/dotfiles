" Leader
let mapleader = " "

set backspace=2   " Backspace deletes like most programs in insert mode
set nobackup
set nowritebackup
set noswapfile    " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
set history=50
set ruler         " show the cursor position all the time
set showcmd       " display incomplete commands
set incsearch     " do incremental searching
set laststatus=2  " Always display the status line
set autowrite     " Automatically :write before running commands

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
endif

if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

filetype plugin indent on

augroup vimrcEx
  autocmd!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile Appraisals set filetype=ruby
  autocmd BufRead,BufNewFile *.md set filetype=markdown
  autocmd BufRead,BufNewFile .{jscs,jshint,eslint}rc set filetype=json
augroup END

" When the type of shell script is /bin/sh, assume a POSIX-compatible
" shell for syntax highlighting purposes.
let g:is_posix = 1

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab

" Display extra whitespace
set list listchars=tab:»·,trail:·,nbsp:·

" Use one space, not two, after punctuation.
set nojoinspaces

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag -Q -l --nocolor --hidden -g "" %s'

  " ag is fast enough that CtrlP doesn't need to cache
  " let g:ctrlp_use_caching = 0

  if !exists(":Ag")
    command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
    nnoremap \ :Ag<SPACE>
  endif
endif

" http://stackoverflow.com/questions/21017857/ctrlp-still-searches-the-ignored-directory
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/node_modules/*,*/public/packs*,*/doc/*,*/docs/*,*/storage/*
if exists("g:ctrlp_user_command")
  unlet g:ctrlp_user_command
endif

" Make it obvious where 80 characters is
set textwidth=80
set colorcolumn=+1

" Numbers
set number
set numberwidth=5

" Tab completion
" will insert tab at beginning of line,
" will use completion if not at beginning
set wildmode=list:longest,list:full
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <Tab> <c-r>=InsertTabWrapper()<cr>
inoremap <S-Tab> <c-n>

" Switch between the last two files
nnoremap <leader><leader> <c-^>

" Reminder to use hjkl
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

" vim-test mappings
nnoremap <silent> <Leader>t :TestFile<CR>
nnoremap <silent> <Leader>s :TestNearest<CR>
nnoremap <silent> <Leader>l :TestLast<CR>
nnoremap <silent> <Leader>a :TestSuite<CR>
nnoremap <silent> <leader>gt :TestVisit<CR>

" Run commands that require an interactive shell
nnoremap <Leader>r :RunInInteractiveShell<space>

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" configure syntastic syntax checking to check on open as well as save
let g:syntastic_check_on_open=1
let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-"]
let g:syntastic_quiet_messages = { "type": "style" }
let g:syntastic_eruby_ruby_quiet_messages =
    \ {"regex": "possibly useless use of a variable in void context"}

execute pathogen#infect()

syntax enable

let g:enable_bold_font = 1

set path=$PWD/**

" Show just the filename
" https://github.com/bling/vim-airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#bufferline#enabled = 1
let g:airline#extensions#syntastic#enabled = 0
let g:airline_powerline_fonts = 1
let g:airline_theme = "violet"

" Asynchronous Lint Engine
let g:ale_sign_column_always = 1
let g:airline#extensions#ale#enabled = 1
let g:ale_linters = { 'scss': ['scsslint'] }
let g:ale_fixers = {
\   'javascript': ['prettier', 'eslint'],
\   'ruby': ['rubocop'],
\   'slim': ['stylelint'],
\   'erb' : ['erb', 'tidy'],
\   'html': ['tidy']
\ }
let g:ale_enabled = 1
let g:ale_fix_on_save = 1
let g:ale_completion_enabled = 1

:au FocusLost * silent! wa

" http://stackoverflow.com/questions/2968548/vim-return-to-command-mode-when-focus-is-lost
:au FocusLost,TabLeave * call feedkeys("\<C-\>\<C-n>")

" This allows buffers to be hidden if you've modified a buffer.
" This is almost a must if you wish to use buffers in this way.
set hidden

" Wrap lines automatically
set textwidth=120
set wrap
set linebreak

" Set spellfile to location that is guaranteed to exist, can be symlinked to
" Dropbox or kept in Git and managed outside of thoughtbot/dotfiles using rcm.
set spellfile=$HOME/.vim-spell-en.utf-8.add

" Autocomplete with dictionary words when spell check is on
set complete+=kspell

" Always use vertical diffs
set diffopt+=vertical

" To open a new empty buffer
" This replaces :tabnew which I used to bind to this mapping
nmap <leader>T :enew<cr>

" Move to the next buffer
nmap <leader>l :bnext<CR>

" Move to the previous buffer
nmap <leader>h :bprevious<CR>

" Close the current buffer and move to the previous one
" This replicates the idea of closing a tab
nmap <leader>bd :bp <BAR> bd #<CR>

" Show all open buffers and their status
nmap <leader>bl :ls<CR>

" Go to alternate file
nmap <leader>a :A<CR>
" Go to related file
nmap <leader>r :R<CR>
" Go to file
nmap <leader>g gf<CR>
" Close buffer
nmap <leader>q :q<CR>

nmap <leader>w :w<CR>
nmap <leader>s :split<CR>
nmap <leader>v :vsplit<CR>

" Quick buffer navigation with Command key
map <D-[> :bprevious<CR>
map <D-]> :bnext<CR>

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Close the buffer in the current split without closing the split
nnoremap <C-w> :bp\|bd #<CR>

nnoremap <C-[> <C-w>h
nnoremap <C-]> <C-w>l

" Bubble single lines
nmap <C-Up> ddkP
nmap <C-Down> ddp
" Bubble Multiple Lines

nnoremap ` :NERDTreeToggle<CR>
map <leader>r :NERDTreeFind<cr>

" https://github.com/thiagoalessio/rainbow_levels.vim
" Creating a mapping to turn it on and off:
map <leader>l :RainbowLevelsToggle<cr>
" Automatically turning it on for certain file types:
" au FileType xml,yaml,yml :RainbowLevelsOn
let g:rainbow_levels = [
    \{'ctermfg': 2, 'guifg': '#a6e22e'},
    \{'ctermfg': 6, 'guifg': '#66d9ef'},
    \{'ctermfg': 4, 'guifg': '#ae81ff'},
    \{'ctermfg': 5, 'guifg': '#f92672'},
    \{'ctermfg': 1, 'guifg': '#fd971f'},
    \{'ctermfg': 3, 'guifg': '#f4bf75'},
    \{'ctermfg': 7, 'guifg': '#f8f8f2'},
    \{'ctermfg': 0, 'guifg': '#75715e'}]

set cursorline
set cursorcolumn
set relativenumber

" Local config
if filereadable($HOME . "/.vimrc.local")
  source ~/.vimrc.local
endif
