syntax enable
"カラースキーマ
colorscheme molokai
set t_Co=256
set t_ut=

set number
set smartindent
set expandtab
set shiftwidth=2
set showtabline=2
set tabstop=2
set ambiwidth=double
"検索時に大文字小文字を区別しない
set ic
"バックアップをとらない
set nobackup
"スワップファイルを作らない
set noswapfile 
"入力中のコマンドを表示
set showcmd
"現在のモードを表示
set showmode
"コピー時にクリップボードを使用
"set clipboard=unnamedplus,autoselect
set clipboard+=unnamedplus
"対応する括弧をハイライト
set showmatch
"バックスペースの挙動
"行頭で使用した場合、前の行と連結、インデントを削除
set backspace=eol,indent,start
" カーソルラインの強調表示を有効化
"set cursorline
" ステータスラインを常に表示
set laststatus=2 
" ステータスラインの内容
set statusline=%<%F\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P
" インクリメンタル検索を有効化
set incsearch
" 検索文字をハイライト
set hlsearch 

" デフォルトの文字コード
set encoding=utf-8
set fileformat=unix
" 自動エンコード
set fileencoding=utf-8
set fileencodings=utf-8,iso-2022-jp,cp932,sjis,euc-jp
 
"タブ関連
set switchbuf+=usetab,newtab"
 
au BufNewFile,BufRead *.hql setlocal filetype=hive expandtab tabstop=2 shiftwidth=2
au BufNewFile,BufRead *.py setlocal expandtab tabstop=4 shiftwidth=4
au BufNewFile,BufRead *.js setlocal tabstop=2 shiftwidth=2
au BufNewFile,BufRead *.php setlocal expandtab tabstop=4 shiftwidth=4
au BufNewFile,BufRead *.cpp setlocal expandtab tabstop=2 shiftwidth=2
au BufNewFile,BufRead *.hpp setlocal expandtab tabstop=2 shiftwidth=2
au BufNewFile,BufRead *Jenkinsfile* setf groovy
au BufNewFile,BufRead *.qgs setf xml

" XMLの対応カッコ移動
source $VIMRUNTIME/macros/matchit.vim

" Plug
silent! call plug#begin('~/.vim/plugged')
Plug 'othree/yajs.vim'
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'scrooloose/syntastic'
Plug 'othree/html5.vim'
Plug 'hail2u/vim-css3-syntax'
Plug 'gorodinskiy/vim-coloresque'
Plug 'mattn/emmet-vim'
Plug 'tomasr/molokai', {'do': 'cp colors/* ~/.vim/colors/'}
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tpope/vim-surround'
Plug 'Valloric/YouCompleteMe'
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}
call plug#end()


" nerdtree
nnoremap <silent><C-e> :NERDTreeToggle<CR><C-w>=

nnoremap +  <C-w>+
nnoremap -  <C-w>-
nnoremap \|  <C-w>\|
nnoremap _  <C-w>_
nnoremap =  <C-w>=

" syntastic
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_mode_map = { 'mode': 'passive',
                           \ 'active_filetypes': ['json','yaml', 'css', 'html', 'javascript'],
                           \ 'passive_filetypes': ['python','php', 'h', 'cpp', 'hpp'] }
let g:syntastic_python_checkers = ['pylint']
let g:syntastic_javascript_checkers=['eslint']
let g:syntastic_yaml_checkers=['jsyaml']
let g:syntastic_html_checkers=['tidy']
let g:syntastic_json_checkers=['jsonlint']
let g:syntastic_php_checkers=['php', 'phpcs']
let g:syntastic_php_phpcs_args='--standard=PSR2'
let g:syntastic_css_checkers=['csslint']
let g:syntastic_cpp_cpplint_exec = 'cpplint'
" ctrlp
let g:ctrlp_show_hidden = 1

" YouCompleteMe
let g:ycm_goto_buffer_command = 'new-tab'

nnoremap jd :YcmCompleter GoTo<CR> 
nnoremap gd :YcmCompleter GetDoc<CR> 
