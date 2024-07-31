set encoding=utf-8
set nu
set cursorcolumn
set cursorline

set mouse=a
set syn=vim
set window=23
set nuw=4
set guifont=Monospace\ 12
set backspace=2
set autoindent
set ai!
set smartindent
set shiftwidth=4
set cindent shiftwidth=2
set nu!
set mouse=a
set ruler
set nowrapscan
set nocompatible
set hidden
set autochdir
set foldmethod=syntax
set foldlevel=100
set laststatus=2
set cmdheight=2
"set showmatch
"set nowrap
set writebackup
set nobackup
"set list
set listchars=tab:\|\ ,
set tabstop=4
set expandtab
syntax enable
syntax on
filetype indent on
filetype plugin on
filetype plugin indent on

colors ron
hi PmenuSel ctermbg=lightblue

au BufRead,BufNewFile *.s,*.c,*.cpp,*.h,*.cl,*.rb,*.sql,*.sh,*.vim,*.js,*.css,*.html 2match Underlined /.\%81v/

set fenc=utf-8
set encoding=utf-8
set fileencodings=utf-8,gbk,cp936,latin-1

set fencs=utf-8,usc-bom,euc-jp,gb18030,gbk,gb2312,cp936,big-5
set enc=utf-8
let &termencoding=&encoding

:inoremap ( ()<ESC>i
:inoremap ) <c-r>=ClosePair(')')<CR>
:inoremap { {}<ESC>i
:inoremap } <c-r>=ClosePair('}')<CR>
:inoremap [ []<ESC>i
:inoremap ] <c-r>=ClosePair(']')<CR>
:inoremap " ""<ESC>i

function ClosePair(char)
  if getline('.')[col('.') - 1] == a:char
      return "\<Right>"
  else
    return a:char
  endif
endf

function! DevHelpCurrentWord()
    let word = expand("<cword>")
    exe "!devhelp -s " . word . " &"
endfunction
nmap <esc>h :call DevHelpcurrentWord()<CR>

let g:miniBufExplMapWindowNavVim=1
let g:miniBufExplMapWindowNavArrows=1
let g:miniBufExplMapCTabSwitchBufs=1
let g:miniBufExplModSelTarget=1


let Tlist_Show_One_File=1
let Tlist_Exit_OnlyWindow=1
let Tlist_Use_Right_Window=1
let Tlist_File_Fold_Auto_close=1

let g:template_path='~/.vim/template/'

let g:snips_author='Ruchee'

let g:vimrc_author='Ruchee'
let g:vimrc_email='my@ruchee.com'
let g:vimrc_homepage='http://www.ruchee.com'


func! Compilecode()
    exec "w"
    if &filetype == "c"
        exec "!clang -std=c99 %<.c -o %<"
    elseif &filetype == "cpp"
        exec "!clang++ -std=c++98 %<.cpp -o %<"
    elseif &filetype == "ruby"
        exec "!ruby %<.rb"
    elseif &filetype == "sh"
        exec "!bash %<.sh"
    endif
endfunc


func! RunCode()
    exec "w"
    if &filetype == "c" || &filetype == "cpp"
        exec "! ./%<"
    elseif &filetype == " ruby"
        exec "!ruby %<.rb"
    elseif &filetype == "sh"
        exec " ! bash %<.sh"
    endif
endfunc


map <c-c> :call CompileCode()<CR>
imap <c-c> <ESC>:call Compilecode ()<CR>
vmap <c-c> <ESC> :call CompileCode()<CR>

map <c-r> :call RunCode()<CR>
imap <c-r> <ESC>:call RunCode()<CR>
vmap <c-r> <ESC>:call RunCode()<CR>


let g:vimwiki_w32_dir_enc = 'utf-8'

let g:vimwiki_use_mouse = 1

let g:vimwiki_camel_case = 0

let g:wimwiki_valid_html_tags='b,i,s,u,sub,sup,kbd,br,hr,div,del,code,red,center,left,right,h2,h4,h5,h6,pre,script,style'

let g:vimwiki_list = [{
\ 'path': '~/mysite/wiki',
\ 'path_html' : '~/mysite/html/',
\ 'html_header': '~/mysite/template/header.html',
\ 'html_footer': '~/mysite/template/footer.html',
\ 'auto_export': 1,
\ 'nested syntaxes': {'Clang': 'c', 'C++': 'cpp', 'Lisp': 'lisp', 'Ruby': 'ruby', 'SQL': 'sql', 'Bash': 'sh'},}]

set cursorline
set cursorcolumn

set guicursor=a:blinkon0

set lines=65 columns=135

winpos 10000 10
set nu
set history=1000
set autoread


set wildmenu
set ruler
set wildignore=*.o,*~,*.pyc
set cmdheight=2
set hid
set backspace=eol,start,indent
set ignorecase
set smartcase
set hlsearch
hi Search term=bold ctermfg=231 ctermbg=133 guifg=#ffffff guibg=#af5faf

set incsearch
set lazyredraw
set magic
set showmatch
set mat=2
set noerrorbells
set novisualbell
set t_vb=
set tm=500
set ffs=unix,dos,mac

set nobackup
set nowb
set noswapfile
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4
set lbr
set tw=500
set ai
set si
set wrap
colorscheme evening
