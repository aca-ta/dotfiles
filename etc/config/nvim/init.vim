" 特定環境用
if filereadable($HOME . "/.vim/additional_vimrc")
  source $HOME/.vim/additional_vimrc
endif

syntax enable
"カラースキーマ
let g:space_vim_dark_background = 234
set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set t_Co=256
set t_ut=
set updatetime=1
set visualbell t_vb=
set mouse=a

set number
set smartindent
set expandtab
set shiftwidth=4
set showtabline=4
set tabstop=4
" タブ可視化と色設定
set list lcs=tab:\|\ 
hi SpecialKey ctermbg=NONE ctermfg=NONE guibg=NONE guifg=#4e4e4e
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
" use * for the default clipboard
set clipboard=unnamed
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
set statusline=%<%F\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}
set statusline+=%{fugitive#statusline()}
set statusline+=%=%l,%c%V%8P
set statusline+=%*
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

" vsplitで右に開く
set splitright

"タブ関連
set switchbuf+=usetab,newtab"

" sqlのautocompletionを行わない
" https://stackoverflow.com/questions/24931088/disable-omnicomplete-or-ftplugin-or-something-in-vim
let g:omni_sql_no_default_maps = 1
 
au BufNewFile,BufRead *.hql setlocal filetype=hive expandtab tabstop=2 shiftwidth=2
au BufNewFile,BufRead *.ddl setlocal filetype=hive expandtab tabstop=2 shiftwidth=2
au BufNewFile,BufRead *.js setlocal filetype=javascript expandtab tabstop=2 shiftwidth=2
au BufNewFile,BufRead *.ts setlocal filetype=typescript expandtab tabstop=2 shiftwidth=2
au BufNewFile,BufRead *.jsx setlocal filetype=javascriptreact expandtab tabstop=2 shiftwidth=2
au BufNewFile,BufRead *.tsx setlocal filetype=typescriptreact expandtab tabstop=2 shiftwidth=2
au BufNewFile,BufRead *.vue setlocal filetype=vue expandtab tabstop=2 shiftwidth=2
au BufNewFile,BufRead *.cpp setlocal filetype=cpp expandtab tabstop=2 shiftwidth=2
au BufNewFile,BufRead *.hpp setlocal filetype=cpp expandtab tabstop=2 shiftwidth=2
au BufNewFile,BufRead *.go setlocal filetype=go noexpandtab tabstop=4 shiftwidth=4
au BufNewFile *.py 0r $HOME/.vim/template/template.py
au BufNewFile *.cpp 0r $HOME/.vim/template/template.cpp
au BufNewFile,BufRead *Jenkinsfile* setf groovy
au BufNewFile,BufRead *.qgs setf xml
au BufNewFile,BufRead *.plb setf sql
au BufNewFile *.sh 0r $HOME/.vim/template/template.sh
au FileType yaml setlocal sw=2 sts=2 ts=2 et
au BufNewFile,BufRead *.yml setf yaml
au BufNewFile,BufRead *.yaml.liquid setf yaml
au BufNewFile,BufRead *.yml.liquid setf yaml
au BufNewFile,BufRead Dockerfile.* setf Dockerfile

" XMLの対応カッコ移動
source $VIMRUNTIME/macros/matchit.vim

function! UpdateRemotePlugins(...)
" Needed to refresh runtime files
    let &rtp=&rtp
    UpdateRemotePlugins
endfunction

" Plug
silent! call plug#begin()
Plug 'autowitch/hive.vim'
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'gorodinskiy/vim-coloresque'
Plug 'yuttie/hydrangea-vim'
Plug 'tpope/vim-vividchalk'
Plug 'liuchengxu/space-vim-dark'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-speeddating'
Plug 'mechatroner/rainbow_csv'
Plug 'tpope/vim-fugitive'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'airblade/vim-gitgutter'
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-commentary'
Plug 'thinca/vim-quickrun'
Plug 'kana/vim-operator-replace'
Plug 'kana/vim-operator-user'
Plug 'kannokanno/previm'
Plug 'tyru/open-browser.vim'
Plug 'janko/vim-test'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'hashivim/vim-terraform'
Plug 'juliosueiras/vim-terraform-completion'
Plug 'luochen1990/rainbow'
Plug 'puremourning/vimspector'
Plug 'psf/black', { 'branch': 'stable' }
Plug 'AndrewRadev/linediff.vim'
Plug 'rickhowe/diffchar.vim'
Plug 'glidenote/memolist.vim'
Plug 'rhysd/vim-clang-format'
Plug 'justmao945/vim-clang'
Plug 'tell-k/vim-autopep8'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'gelguy/wilder.nvim', { 'do': function('UpdateRemotePlugins') }
Plug 'mzlogin/vim-markdown-toc'
Plug 'heavenshell/vim-pydocstring', { 'do': 'make install', 'for': 'python' }
Plug 'tpope/vim-rhubarb'
Plug 'rhysd/conflict-marker.vim'
Plug 'github/copilot.vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }
Plug 'zbirenbaum/copilot.lua'
Plug 'nvim-lua/plenary.nvim'
Plug 'CopilotC-Nvim/CopilotChat.nvim', { 'branch': 'canary' }
Plug 'akinsho/toggleterm.nvim', {'tag' : '*'}
Plug 'EdenEast/nightfox.nvim' " Vim-Plug
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'delphinus/cellwidths.nvim'
call plug#end()

" plug-vimのディレクトリを参照するため、plug#end()の後にcolorschemeを定義する
colorscheme nightfox

" nerdtree
let NERDTreeShowHidden=1
let g:nerdtree_tabs_open_on_gui_startup=0
nnoremap <silent><C-e> :NERDTreeTabsToggle<CR><C-w>=

nnoremap +  <C-w>+
nnoremap -  <C-w>-
nnoremap \|  <C-w>\|
nnoremap _  <C-w>_
nnoremap =  <C-w>=
vnoremap > >gv
vnoremap < <gv

" gitgutter
let g:gitgutter_highlight_lines = 0
let g:gitgutter_max_signs = 1000

nnoremap gn :GitGutterNextHunk<CR>
nnoremap gp :GitGutterPrevHunk<CR>

" vim-markdown
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0
let g:vim_markdown_new_list_item_indent = 0

" vim-markdown-toc
let g:vmt_fence_text = 'TOC START'
let g:vmt_fence_closing_text = 'TOC END'

nmap <silent> <C-p> :cprev<CR>
nmap <silent> <C-n> :cnext<CR>

" close a loclist when a window is closed
augroup CloseLoclistWindowGroup
  autocmd!
  autocmd QuitPre * if empty(&buftype) | lclose | endif
augroup END

" close a quickfix when a window is closed
augroup CloseQuickfixWindowGroup
  autocmd!
  autocmd WinEnter * if (winnr('$') == 1) && (getbufvar(winbufnr(0), '&buftype')) == 'quickfix' | quit | endif
augroup END

" vim-operator-replace
map r <Plug>(operator-replace)

" previm
let g:previm_open_cmd = 'open -a Google\ Chrome'

" vim-test
let test#strategy = "neovim"
let test#python#runner = 'pyunit'
let test#vim#term_position = "aboveleft"
let test#python#pytest#options = '-vv'
let g:test#javascript#runner = 'jest'

" rainbow
let g:rainbow_active = 1

" vim-terraform
let g:terraform_fmt_on_save=1

" vimspector
let g:vimspector_base_dir=$HOME . "/.config/vimspector-config/"
let g:vimspector_enable_mappings='HUMAN'
let g:vimspector_install_gadgets = [ 'debugpy' ]
" clear breakpoints when vimspector reset
autocmd User VimspectorDebugEnded call vimspector#ClearBreakpoints()

" cucumbertables https://gist.github.com/tpope/287147
inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a
function! s:align()
  let p = '^\s*|\s.*\s|\s*$'
  if exists(':TableFormat') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
    TableFormat
    normal! 0
    call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction

" format json with jq
command! Jqf %!jq '.'

" fzf.vim
" ignore file name.
command! -bang -nargs=* Rg
      \ call fzf#vim#grep('rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
      \ fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0)
nnoremap Fd :Files<CR>

" easymotion
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1

" memolist
let g:memolist_memo_suffix = "md"

" set clang options for vim-clang
let g:clang_c_options = '-std=c11'
let g:clang_cpp_options = '-std=c++1z --pedantic-errors'

" clang-format
let g:clang_format#auto_format = 0
let g:clang_format#auto_filetypes = ["c", "cpp"]

" coc.nvim
nmap tj : call CocAction('jumpDefinition')<CR>
nmap gr <Plug>(coc-references)
nmap rn <Plug>(coc-rename)
nnoremap <silent> gd :call <SID>show_documentation()<CR>
inoremap <silent><expr> <c-x><c-o> coc#refresh()

" golang
" missing imports on save
autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" ref: https://github.com/damnever/dotfiles/blob/f014a64e816755aeffaf593a951320bfb5004762/vimrc#L224-L239
function! CocSplitIfNotOpen(...)
    let cursorCmd = ''
    let fname = a:1
    if a:0 == 2  " Two arguments.
        let cursorCmd = a:1
        let fname = a:2
    endif
    if fname != fnamemodify(expand('%'), ':p:~:.')
        exec 'vsplit '.fname
    endif
    if len(cursorCmd)
        exec cursorCmd
    endif
endfunction
command! -nargs=+ CocJumpCmd :call CocSplitIfNotOpen(<f-args>)

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" wilder.nvim
call wilder#setup({'modes': [':', '/', '?']})
" popup
call wilder#set_option('renderer', wilder#popupmenu_renderer({
      \ 'pumblend': 20,
      \ 'highlighter': wilder#basic_highlighter(),
      \ }))

" highlightedyank
let g:highlightedyank_highlight_duration = -1
highlight HighlightedyankRegion ctermbg=lightgray guibg=lightgray

" nvim
let g:python3_host_prog = system('echo -n $(which python3)')

" markdown outline
" https://zenn.dev/kawarimidoll/articles/8abb570dac523f
function! s:markdown_outline() abort
  let fname = @%
  let current_win_id = win_getid()

  " # heading
  execute 'vimgrep /^#\{1,6} .*$/j' fname

  " heading
  " ===
  execute 'vimgrepadd /\zs\S\+\ze\n[=-]\+$/j' fname

  let qflist = getqflist()
  if len(qflist) == 0
    cclose
    return
  endif

  " make sure to focus original window because synID works only in current window
  call win_gotoid(current_win_id)
  call filter(qflist,
        \ 'synIDattr(synID(v:val.lnum, v:val.col, 1), "name") != "markdownCodeBlock"'
        \ )
  call sort(qflist, {a,b -> a.lnum - b.lnum})
  call setqflist(qflist)
  call setqflist([], 'r', {'title': fname .. ' TOC'})
  copen 5
endfunction

nnoremap <buffer> gO <Cmd>call <sid>markdown_outline()<CR>

"pydocstring
let g:pydocstring_formatter = 'google'

" mzlogin/vim-markdown-toc
let g:vmt_list_item_char = '-'

let g:copilot_filetypes = {'markdown': v:true}

" copilotChat.nvim
" ファイルの存在を確認
if filereadable(expand($HOME . '/.config/github-copilot/hosts.json'))
  " Luaファイルを読み込む
  lua require('copilotchat-settings')
endif

" toggleterm.nvim
lua require("toggleterm").setup()


let g:python3_host_prog = $HOME . '/.pyenv/shims/python3'

" indent blackline
lua require("ibl").setup()

lua require("cellwidths").setup { name = "default" }

augroup highlight_yank
  autocmd!
  autocmd TextYankPost * silent! lua vim.highlight.on_yank { timeout=-1 }
augroup END
