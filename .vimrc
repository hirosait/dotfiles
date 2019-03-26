"===============文字コードに関する設定================
"ファイル読み込み時の文字コードの設定
set encoding=utf-8

"Vim script内でマルチバイト文字を使う際の設定
scriptencoding uft-8

" 保存時の文字コード
set fileencoding=utf-8

" 読み込み時の文字コードの自動判別. 左側が優先される
set fileencodings=ucs-boms,utf-8,euc-jp,cp932

" 改行コードの自動判別. 左側が優先される
set fileformats=unix,dos,mac

" □や○文字が崩れる問題を解決
set ambiwidth=double

" ヤンクする行数上限を増やす
set viminfo='20,\"1000

" ステータスバーに文字コードを表示
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P
"=====================================================



"===============タブやインデントに関する設定===============
"タブ入力を複数の空白文字に置き換える
set expandtab

"画面上でタブ文字が占める幅を規定
set tabstop=2

"連続した空白に対してtab_key やbackspace_keyでカーソルが動く幅を規定
set softtabstop=2

"改行時に前の行のインデントを継続させる
set autoindent

"改行時に前の行の構文をチェックし次の行のインデントを増減させる
set smartindent

"smartindentで増減する幅を規定
set shiftwidth=2

" インデントを設定
autocmd FileType coffee     setlocal sw=2 sts=2 ts=2 et
"============================================================



"==================== 検索系============================
"検索結果をハイライト
set hlsearch
"ESC二回押しでハイライトを消す
nnoremap <ESC><ESC> :nohlsearch<CR>

"検索結果に大文字小文字を区別しない
set ignorecase

"検索文字に大文字が含まれていたら、大文字小文字を区別する
set smartcase

"----------検索対象から除外するファイルを指定---------
let Grep_Skip_Dirs = '.svn .git'  "無視するディレクトリ
let Grep_Default_Options = '-I'   "バイナルファイルがgrepしない
let Grep_Skip_Files = '*.bak *~'  "バックアップファイルを無視する
"-----------------------------------------------------

":cn,:cpを、[q、]q にバインディング
nnoremap [q :cprevious<CR>   " 前へ
nnoremap ]q :cnext<CR>       " 次へ
nnoremap [Q :<C-u>cfirst<CR> " 最初へ
nnoremap ]Q :<C-u>clast<CR>  " 最後へ


"======================================================



"====================syntax系=========================

syntax enable
set background=dark
colorscheme desert

"シンタックスハイライト有効
syntax on
"=======================================================



"======================カーソル系========================
"カーソルの左右移動で行末から次の行の行頭への移動が可能になる
set whichwrap=b,s,h,l,<,>,[,],~

"横線を入れる
set cursorline

"行番号を表示する
set number

"INSERTモードのときだけ横線解除
augroup set_cursorline
  autocmd!
  autocmd InsertEnter,InsertLeave * set cursorline!  "redraw!
augroup END

"全角スペースを視覚化
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=#666666
au BufNewFile,BufRead * match ZenkakuSpace /　/

" タイトルをウインドウ枠に表示する
set title

"カーソルが何行目の何列目に置かれているかを表示する
set ruler

" backspace使用できるように
set backspace=indent,eol,start

" 最後に開いていた場所にカーソルを合わす
augroup vimrcEx
  au BufRead * if line("'\"") > 0 && line("'\"") <= line("$") |
  \ exe "normal g`\"" | endif
augroup END
"========================================================



"=======================コピー&ペースト系=================
" クリップボード
set clipboard=unnamed,autoselect


"----------コピーした際に自動インデントでズレない設定----
if &term =~ "xterm"
    let &t_SI .= "\e[?2004h"
    let &t_EI .= "\e[?2004l"
    let &pastetoggle = "\e[201~"

    function XTermPasteBegin(ret)
        set paste
        return a:ret
    endfunction

    inoremap <special> <expr> <Esc>[200~ XTermPasteBegin("")
endif
"--------------------------------------------------------

"==========================================================



"======================ファイル操作系=====================
"VimFilter起動時からファイル操作が出来る設定(切り替えはgs)
let g:vimfiler_as_default_explorer = 1
"=========================================================



"====================その他設定===========================
"自動でswpファイル作らない
set noswapfile

"自動補完(タブで移動)
set wildmenu

"保存するコマンド履歴の数を設定
set history=5000

" vimにcoffeeファイルタイプを認識させる
au BufRead,BufNewFile,BufReadPre *.coffee   set filetype=coffee

"Ctags
set tags=./.tags;
"==========================================================



"=================独自キーバインド=========================
"jjでインサートモードを抜ける
inoremap <silent> jj <ESC>

"qで終了
nmap q :q<CR>

"Shift + hで行の先頭
noremap <S-h>   ^

"Shift + lで行の末尾
noremap <S-l>   $

"上下移動を表示行ベースに
noremap j gj
noremap k gk
"==========================================================



"==================tab移動の設定===========================
"---t1,t2...でタブ移動,ttでタブ新規作成,tqでタブ閉じ-------
" Anywhere SID.
function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

" Set tabline.
function! s:my_tabline()  "{{{
  let s = ''
  for i in range(1, tabpagenr('$'))
    let bufnrs = tabpagebuflist(i)
    let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears

    let no = i  " display 0-origin tabpagenr.
    let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
    let title = fnamemodify(bufname(bufnr), ':t')
    let title = '[' . title . ']'
    let s .= '%'.i.'T'
    let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
    let s .= no . ':' . title
    let s .= mod
    let s .= '%#TabLineFill# '
  endfor
  let s .= '%#TabLineFill#%T%=%#TabLine#'
  return s
endfunction "}}}
let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
set showtabline=2 " 常にタブラインを表示

" The prefix key.
nnoremap    [Tag]   <Nop>
nmap    t [Tag]
" Tab jump
for n in range(1, 9)
  execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor
" t1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ

map <silent> [Tag]t :tablast <bar> tabnew<CR>
" tt 新しいタブを一番右に作る
map <silent> [Tag]q :tabclose<CR>
" tq タブを閉じる
map <silent> [Tag]n :tabnext<CR>
" tn 次のタブ
map <silent> [Tag]p :tabprevious<CR>
" tp 前のタブ
"==============================================================



"====================== dein ===========================
"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=$HOME/.vim/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('$HOME/.vim/dein')
  call dein#begin('$HOME/.vim/dein')

  " Let dein manage dein
  " Required:
  call dein#add('$HOME/.vim/dein/repos/github.com/Shougo/dein.vim')

  " プラグインを設定
  " NerdTree
  call dein#add('scrooloose/nerdtree')
  " 閉じ括弧補完
  call dein#add('cohama/lexima.vim')
  " HTMLなど 閉じタグ自動補完
  " call dein#add('alvan/vim-closetag')
  " HTML 対応するタグをハイライト
  " call dein#add('valloric/matchtagalways')
  " コード補完
  call dein#add('Shougo/neocomplete.vim')
  call dein#add('Shougo/neosnippet.vim')
  call dein#add('Shougo/neosnippet-snippets')
  " Git関連
  call dein#add('airblade/vim-gitgutter')
  call dein#add('tpope/vim-fugitive')

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" インストールされていないものは自動インストールする
if dein#check_install()
  call dein#install()
endif

"----------------------------------------------------------
"  nerdtree
"----------------------------------------------------------
let g:NERDTreeShowBookmarks=1
" autocmd vimenter * NERDTree
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
nnoremap <C-e> :NERDTreeToggle<CR>

" NERDTress File highlighting
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
   exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
    exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
  endfunction
  call NERDTreeHighlightFile('py',     'yellow',  'none', 'yellow',  '#151515')
  call NERDTreeHighlightFile('md',     'blue',    'none', '#3366FF', '#151515')
  call NERDTreeHighlightFile('yml',    'yellow',  'none', 'yellow',  '#151515')
  call NERDTreeHighlightFile('config', 'yellow',  'none', 'yellow',  '#151515')
  call NERDTreeHighlightFile('conf',   'yellow',  'none', 'yellow',  '#151515')
  call NERDTreeHighlightFile('json',   'yellow',  'none', 'yellow',  '#151515')
  call NERDTreeHighlightFile('html',   'yellow',  'none', 'yellow',  '#151515')
  call NERDTreeHighlightFile('styl',   'cyan',    'none', 'cyan',    '#151515')
  call NERDTreeHighlightFile('css',    'cyan',    'none', 'cyan',    '#151515')
  call NERDTreeHighlightFile('rb',     'Red',     'none', 'red',     '#151515')
  call NERDTreeHighlightFile('js',     'Red',     'none', '#ffa500', '#151515')
  call NERDTreeHighlightFile('php',    'Magenta', 'none', '#ff00ff', '#151515')

" ディレクトリ表示記号を変更する
let g:NERDTreeDirArrows = 1
let g:NERDTreeDirArrowExpandable  = '▶'
let g:NERDTreeDirArrowCollapsible = '▼'


"----------------------------------------------------------
"  vim-closetag
"----------------------------------------------------------
let g:closetag_filenames = '*.html,*.xhtml,*.php'
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx'
let g:closetag_filetypes = 'html,xhtml,php'
let g:closetag_xhtml_filetypes = 'xhtml,jsx'

let g:closetag_emptyTags_caseSensitive = 1
let g:closetag_shortcut = '>'
let g:closetag_close_shortcut = '<leader>>'


"----------------------------------------------------------
"  matchtagalways
"----------------------------------------------------------
"オプション機能ONにする
let g:mta_use_matchparen_group = 1

"使用するファイルタイプ(phpを追加)
let g:mta_filetypes = {
    \ 'html' : 1,
    \ 'xhtml' : 1,
    \ 'xml' : 1,
    \ 'jinja' : 1,
    \ 'php' : 1,
    \}

"----------------------------------------------------------
"  neosnippet-snippets
"----------------------------------------------------------
" Plugin key-mappings.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
" <C-k>で、TARGETのところへジャンプ
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
"imap <expr><TAB>
" \ pumvisible() ? "\<C-n>" :
" \ neosnippet#expandable_or_jumpable() ?
" \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" 独自スニペットファイルのあるディレクトリを指定
let g:neosnippet#enable_snipmate_compatibility = 1
let g:neosnippet#snippets_directory=$HOME.'/.vim/dein/vim-neosnippets/'

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif
"----------------------------------------------------------
"  neocomplete.vim
"----------------------------------------------------------
"Note: This option must be set in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3

" 辞書ファイルを設定
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : ''
    \ }

"辞書ファイル設定する場合は上記にこちら追加
"    \ 'php' : $HOME.'/.vim/dein/dict/php.dict'

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
  return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? "\<C-y>" : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? "\<C-y>" : "\<Space>"

" AutoComplPop like behavior.
"let g:neocomplete#enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplete#enable_auto_select = 1
"let g:neocomplete#disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType php setlocal omnifunc=phpcomplete#CompletePHP

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'


" PHPLint 構文チェック　,lでチェック
nmap ,l :call PHPLint()<CR>

" " 
"  PHPLint
"  
"  @author halt feits <halt.feits at gmail.com>
"  
function PHPLint()
    let result = system( &ft . ' -l ' . bufname(""))
    echo result
endfunction

"----------------------------------------------------------
"  vim-gitgutter
"----------------------------------------------------------
" 記号更新のタイミングを早くする
set updatetime=250
" ハイライトを有効にする
"let g:gitgutter_highlight_lines = 1


"----------------------------------------------------------
"  プラグイン関連の微調整
"----------------------------------------------------------
" バックスペースが使用できなくなるときに使用
"set backspace=indent,eol,start

"End dein Scripts-------------------------
"
