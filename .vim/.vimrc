"""""""""""""""""""""""""""""""""""""""""""""""""""""
"Indentation
"""""""""""""""""""""""""""""""""""""""""""""""""""""
set expandtab
set shiftwidth=2
set tabstop=2
set softtabstop=2

set autoindent
filetype plugin indent on
syntax enable

"things after case labels aren't indented
"so I can add braces in case statements
set cino==0

set nu

set splitright
set splitbelow

set showcmd

let g:markdown_folding = 1
"""""""""""""""""""""""""""""""""""""""""""""""""""""
"Code Navigation
"""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('nvim-0.1.5')
  set termguicolors
  set shada="NONE"
endif

set showmatch
set incsearch
set hlsearch
set ruler
set tagcase=smart "smart case sensitivity with :tag command

set foldlevelstart=99
set foldmethod=indent

set backup
set writebackup
set undofile

if has("win32")
  set backupdir=~/vimfiles
  set backupskip=~/vimfiles/*
  set directory=~/vimfiles
  set undodir=~/vimfiles
elseif has("unix")
  set backupdir=/tmp
  set backupskip=/tmp/*
  set directory=/tmp
  set undodir=/tmp
endif

if has("gui_running")
  set lines=30 columns=120
endif

set hidden
set history=200
set nrformats=bin,hex
set backspace=indent,eol,start " be able to backspace over these chars

set autoread

set wildmode=list:longest,full " tab complete to longest match, second tab lists all matches
set wildignorecase " ignore case when completing file and dir names

set virtualedit=block " allow visual mode block editing to extend past EOL

set path+=**

set laststatus=2    " always display statusline
set statusline=%<%f " file name and path
set statusline+=\ %m%r " modified, read-only flags
set statusline+=\ %y  " filetype according to vim
set statusline+=%=
set statusline+=\ [0x\%02.2B] " hex value under cursor
set statusline+=\ [%{v:register}] " active register
set statusline+=\ [%2.10(%l:%c%V%)\ \/\ %L] " line:column / total lines

if executable('rg')
  set grepprg=rg\ --no-messages\ --vimgrep\ --max-filesize\ 5M\ --type-add\ work:include:cpp,c,asm\ --type-add\ work:*.s43\ --type-add\ zig:*.zig
  set grepformat=%f:%l:%c:%m,%f:%l:%m
"lgrep search hotkeys
  nmap <Bslash>s yiw:lgrep "<c-R>0"<SPACE>
  nmap <Bslash>S :lgrep<SPACE>
  vmap <Bslash>s y<Leader>S"<c-R>0"<SPACE>-F<SPACE>

elseif executable("ag")
  set grepprg=ag\ --nogroup\ --nocolor\ --ignore-case\ --column\ --vimgrep
  set grepformat=%f:%l:%c:%m,%f:%l:%m
"lgrep search hotkeys
  nmap <Bslash>s yiw:lgrep "<c-R>0"<SPACE>
  nmap <Bslash>S :lgrep<SPACE>
  vmap <Bslash>s y<Leader>S"<c-R>0"<SPACE>

endif
"""""""""""""""""""""""""""""""""""""""""""""""""""""
"Key maps
"""""""""""""""""""""""""""""""""""""""""""""""""""""
set timeout timeoutlen=1000 ttimeoutlen=200
let mapleader = ','
imap jk <esc>
vmap s( c()<ESC>P
vmap s{ c{}<ESC>P
vmap s" c""<ESC>P
vmap s` c``<ESC>P
vmap s' c''<ESC>P
nmap ds( %x<c-o>x
nmap ds{ %x<c-o>x
nmap ds" %x<c-o>x
nmap ds` %x<c-o>x
nmap ds' %x<c-o>x
nmap dif viwl%d
nmap yif viwl%y
vmap <Bslash>bs c{<CR>}<ESC>P=i{
vmap s<SPACE> di<SPACE><SPACE><ESC>P
nmap j gj
nmap k gk
nmap <c-j> :lnext<CR>zz
nmap <c-k> :lprevious<CR>zz
nmap <c-n> :lnewer<CR>
nmap <c-m> :lolder<CR>
nmap <SPACE> za
nmap <a-.> 10<c-w>>
nmap <a-,> 10<c-w><
nmap <a--> 10<c-w>-
nmap <a-=> 10<c-w>+
nmap <Bslash>u g-
nmap <Bslash>r g+
nmap <Bslash>l :call LocationListToggle()<CR>
vmap <Bslash>/ :call Comment()<CR>
vmap <Bslash>\ :call Uncomment()<CR>
nmap <Bslash>] :call TogglePreview()<CR>
nmap <Bslash>n :call VerticalSplitNoteToggle()<CR>
nmap <Bslash>i =i{
nmap <Bslash>wq ggVG"+d:q!<CR>

"lvimgrep search hotkeys
nmap <Bslash>vs yiw:call EasylvimgrepSearch('<c-R>0')<CR>
nmap <Bslash>vS :call EasylvimgrepSearch('')<LEFT><LEFT>
vmap <Bslash>vs y<Leader>vS<c-R>0<CR>
vmap <Bslash>vS y<Bslash>vS<c-R>0
"""""""""""""""""""""""""""""""""""""""""""""""""""""
"Functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""
function! EasylvimgrepSearch(term)
  if (&filetype ==? "c") || (&filetype ==? "cpp") 
    execute('lvimgrep `' . a:term . '` **/*.c **/*.C **/*.h **/*.cpp **/*.hpp')
  elseif (&filetype ==? "msp")
    execute('lvimgrep `' . a:term . '` **/*.s43 **/*.h **/*.inc')
  elseif (&filetype ==? "nim")
    execute('lvimgrep `' . a:term . '` **/*.nim')
  endif
endfunction
"""""""""""""""""""""""""""""""""""""""""""""""""""""
function! EasyCtags()
  if ((&filetype ==? "c") || (&filetype ==? "cpp") || (&filetype ==? "msp"))
    execute('!ctags --langmap=Asm:.s43.h --langmap=C:.c.h.C --languages=Asm,C,C++ --regex-C="/^(DEFCW\|DEFC\|DEFW)\(\s*([a-zA-Z0-9_]+)/\2/t,definition/" -R --exclude=*Examples* .')
  else
    execute('!ctags -R .')
  endif
endfunction
"""""""""""""""""""""""""""""""""""""""""""""""""""""
function! EasyLinuxCtags()
    execute('!ctags --langmap=C:.c.h.C -R . && ctags -Ra /lib/modules/$(uname -r)')
endfunction
"""""""""""""""""""""""""""""""""""""""""""""""""""""
function! LocationListToggle()
  if exists("w:location_list_open")
    unlet w:location_list_open
    lclose
  else
    lopen
    let w:location_list_open = 1
  endif
endfunction
"""""""""""""""""""""""""""""""""""""""""""""""""""""
function! Comment()
  if (&filetype ==? "c") || (&filetype ==? "cpp") || (&filetype ==? "cs") || (&filetype ==? "zig")
    s;^;//;e
  elseif (&filetype ==? "msp")
    s/^/;/e
  elseif (&filetype ==? "sh")||(&filetype ==? "pov")||(&filetype ==? "nim")||(&filetype ==? "make")
    s/^/# /e
  elseif (&filetype ==? "vim")
    s/^/"/e
  endif
endfunction
"""""""""""""""""""""""""""""""""""""""""""""""""""""
function! Uncomment()
  if (&filetype ==? "c") || (&filetype ==? "cpp") || (&filetype ==? "cs") || (&filetype ==? "zig")
    s;^//;;e
  elseif (&filetype ==? "msp")
    s/^;//e
  elseif (&filetype ==? "sh")||(&filetype ==? "pov")||(&filetype ==? "nim")||(&filetype ==? "make")
    s/^# //e
  elseif (&filetype ==? "vim")
    s/^"//e
  endif
endfunction
"""""""""""""""""""""""""""""""""""""""""""""""""""""
function! PwinOpen()
  let w:pwin = 1
  wincmd }
endfunction

function! PwinClose()
  unlet w:pwin
  pclose
endfunction

function! TogglePreview()
  if exists("w:pwin")
    call PwinClose()
  else
    call PwinOpen()
  endif
endfunction
"""""""""""""""""""""""""""""""""""""""""""""""""""""
function! VerticalSplitNoteToggle()
  if exists("t:notes_buf_number")
    call VerticalSplitNoteClose()
  else
    call VerticalSplitNoteOpen()
  endif
endfunction

function! VerticalSplitNoteOpen()
  execute "vsplit NOTES.md"
  let t:notes_buf_number = bufnr("%")
  wincmd L "move window all the way to the right
  65wincmd | "set window width to notes_width
endfunction

function! VerticalSplitNoteClose()
  100wincmd l
  100wincmd k
  close
  unlet t:notes_buf_number
endfunction
"""""""""""""""""""""""""""""""""""""""""""""""""""""
function! SvnDiff()
  if exists("t:svn_head_buf_number")
    call SvnDiffClose()
  else
    call SvnDiffOpen()
  endif
endfunction

function! SvnDiffOpen()
  let t:diff_file_name = expand('%')
  execute "vert new"
  execute "read !svn cat " . t:diff_file_name
  let t:svn_head_buf_number = bufnr('%')
  execute "windo diffthis"
  execute "normal gg"
endfunction

function! SvnDiffClose()
  execute "windo diffoff"
  execute "bd! " . t:svn_head_buf_number
  unlet t:svn_head_buf_number
endfunction
  
"""""""""""""""""""""""""""""""""""""""""""""""""""""
"Auto Functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup vimrc
  autocmd! vimrc
  au BufNewFile,BufRead *.s43 set ft=msp
  au BufNewFile,BufRead *.au3 set ft=autoit
  au BufNewFile,BufRead *.md set textwidth=80
augroup END

let g:onedark_termcolors=16
set background=dark
silent! colorscheme onedark

if has('win32')
  silent! set guifont=Consolas:h11
endif

