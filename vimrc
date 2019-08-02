set encoding=utf-8

" Leader
let mapleader = " "

" Load bundles first to allow overwriting options
if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

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

" Make it obvious where 80 characters is
set textwidth=80
set colorcolumn=+1

" Numbers
set number
set numberwidth=5

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab

" Display extra whitespace
set list listchars=tab:»·,trail:·,nbsp:·

" Use one space, not two, after punctuation.
set nojoinspaces

" Highlight the cursor
set cursorline
set cursorcolumn
set relativenumber

" This allows buffers to be hidden if you've modified a buffer.
" This is almost a must if you wish to use buffers in this way.
set hidden

" Wrap lines automatically
set textwidth=120
set wrap
set linebreak

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
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
  autocmd BufRead,BufNewFile *.md set filetype=markdown
  autocmd BufRead,BufNewFile .{jscs,jshint,eslint}rc set filetype=json
  autocmd BufRead,BufNewFile aliases.local,zshrc.local,*/zsh/configs/* set filetype=sh
  autocmd BufRead,BufNewFile gitconfig.local set filetype=gitconfig
  autocmd BufRead,BufNewFile tmux.conf.local set filetype=tmux
  autocmd BufRead,BufNewFile vimrc.local set filetype=vim
augroup END

" ALE linting events
augroup ale
  autocmd!

  if g:has_async
    autocmd VimEnter *
      \ set updatetime=1000 |
      \ let g:ale_lint_on_text_changed = 0
    autocmd CursorHold * call ale#Queue(0)
    autocmd CursorHoldI * call ale#Queue(0)
    autocmd InsertEnter * call ale#Queue(0)
    autocmd InsertLeave * call ale#Queue(0)
  else
    echoerr "The thoughtbot dotfiles require NeoVim or Vim 8"
  endif
augroup END

" Asynchronous Lint Engine
let g:ale_sign_column_always = 1
let g:airline#extensions#ale#enabled = 1
let g:ale_linters = {
\   'css': ['stylelint'],
\   'slim': ['stylelint'],
\ }
let g:ale_fixers = {
\   'javascript': ['prettier', 'eslint'],
\   'ruby': ['rubocop'],
\   'css':  ['stylelint', 'prettier'],
\   'scss': ['stylelint'],
\   'erb' : ['erb', 'tidy'],
\   'html': ['tidy']
\ }
let g:ale_enabled = 1
let g:ale_fix_on_save = 1
let g:ale_completion_enabled = 1

" When the type of shell script is /bin/sh, assume a POSIX-compatible
" shell for syntax highlighting purposes.
let g:is_posix = 1

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag --literal --files-with-matches --nocolor --hidden -g "" %s'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0

  if !exists(":Ag")
    command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
    nnoremap \ :Ag<SPACE>
  endif
endif

" Tab completion
" will insert tab at beginning of line,
" will use completion if not at beginning
set wildmode=list:longest,list:full
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<Tab>"
    else
        return "\<C-p>"
    endif
endfunction
inoremap <Tab> <C-r>=InsertTabWrapper()<CR>
inoremap <S-Tab> <C-n>

" Set spellfile to location that is guaranteed to exist, can be symlinked to
" Dropbox or kept in Git and managed outside of thoughtbot/dotfiles using rcm.
set spellfile=$HOME/.vim-spell-en.utf-8.add

" Autocomplete with dictionary words when spell check is on
set complete+=kspell

" Always use vertical diffs
set diffopt+=vertical

" Ignore these files...
" http://stackoverflow.com/questions/21017857/ctrlp-still-searches-the-ignored-directory
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/node_modules/*,*/public/packs*,*/doc/*,*/docs/*,*/storage/*
if exists("g:ctrlp_user_command")
  unlet g:ctrlp_user_command
endif

if has("gui_running")
  " Turn on ligatures (font must support ligatures)
  set macligatures

  " get rid of scrollbars in MacVim
  set guioptions=

  let g:enable_bold_font = 1
endif

" vim-devicons
" https://github.com/ryanoasis/vim-devicons
" ctrlp glyphs
let g:webdevicons_enable_ctrlp = 0

" Auto-close tag
iabbrev </ </<C-X><C-O>
imap <C-Space> <C-X><C-O>

" Change cursor in insertmode
" let &t_SI = "\<Esc>]50;CursorShape=1\x7"
" let &t_SR = "\<Esc>]50;CursorShape=2\x7"
" let &t_EI = "\<Esc>]50;CursorShape=0\x7"


" https://github.com/thiagoalessio/rainbow_levels.vim
" Creating a mapping to turn it on and off:
" map <leader>l :RainbowLevelsToggle<cr>
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

" Auto-close tag
iabbrev </ </<C-X><C-O>
imap <C-Space> <C-X><C-O>



" configure syntastic syntax checking to check on open as well as save
let g:syntastic_check_on_open=1
let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-"]
let g:syntastic_quiet_messages = { "type": "style" }
let g:syntastic_eruby_ruby_quiet_messages =
    \ {"regex": "possibly useless use of a variable in void context"}

" Show just the filename
" https://github.com/bling/vim-airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#bufferline#enabled = 1
let g:airline#extensions#syntastic#enabled = 0
let g:airline_powerline_fonts = 1
let g:airline_theme = "violet"

" http://stackoverflow.com/questions/2968548/vim-return-to-command-mode-when-focus-is-lost
" :au FocusLost * silent! wa
:au FocusLost,TabLeave * call feedkeys("\<C-\>\<C-n>")

" Favorite mappings
if filereadable($HOME . "/.vimrc.mappings")
  source ~/.vimrc.mappings
endif

" Local config
if filereadable($HOME . "/.vimrc.local")
  source ~/.vimrc.local
endif
