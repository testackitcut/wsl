"dein Scripts-----------------------------{{{ 

if &compatible
  set nocompatible               " Be iMproved
endif

let s:dein_path = expand('~/.vim/dein')
let s:dein_repo_path = s:dein_path . '/repos/github.com/Shougo/dein.vim' 
" dein.vim がなければ github からclone
if &runtimepath !~# '/dein.vim'
   if !isdirectory(s:dein_repo_path)
      execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_path
   endif
   execute 'set runtimepath^=' . fnamemodify(s:dein_repo_path, ':p')
endif


" Required:
"set runtimepath+=/home/cmp/.vim/dein//repos/github.com/Shougo/dein.vim

" Required:
"if dein#load_state('/home/cmp/.vim/dein/')
"   call dein#begin('/home/cmp/.vim/dein/')
if dein#load_state(s:dein_path)
   call dein#begin(s:dein_path)

   " Let dein manage dein  " Required:
   "call dein#add('/home/cmp/.vim/dein//repos/github.com/Shougo/dein.vim')

   " Add or remove your plugins here:
   "call dein#add('Shougo/neosnippet.vim')

   " You can specify revision/branch/tag.
   "call dein#add('Shougo/deol.nvim', { 'rev': 'a1b5108fd' })

   let g:config_dir  = expand('~/.vim/dein/userconfig')
   let s:toml        = g:config_dir . '/MyPlugins.toml'
   let s:lazy_toml   = g:config_dir . '/MyPlugins_lazy.toml'
   " TOML 読み込み
   call dein#load_toml(s:toml,      {'lazy': 0})
   call dein#load_toml(s:lazy_toml, {'lazy': 1})

   " Required:
   call dein#end()
   call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
"if dein#check_install()
"  call dein#install()
"endif

" インストールされていないプラグインがあればインストールする 
" If you want to install not installed plugins on startup.
if dein#check_install()
   call dein#install()
endif

"End dein Scripts-------------------------}}}

" 自動補完関連 {{{

" ハイフン等を含む文字列も補完する {{{

"set iskeyword+=-,_,/,~,=,+,*,',.,^
set iskeyword+=-,_,/,~,=,+,*,',^

"}}}

" TAB キーで補完する {{{

" This function determines, wether we are on the start of the line text (then tab indents) or
" if we want to try autocompletion
function! InsertTabWrapper()
        let col = col('.') - 1
        if !col || getline('.')[col - 1] !~ '\k'
                return "\<TAB>"
        else
                if pumvisible()
                        return "\<C-N>"
                else
                        return "\<C-N>\<C-P>"
                end
        endif
endfunction
" Remap the tab key to select action with InsertTabWrapper
inoremap <tab> <c-r>=InsertTabWrapper()<cr>

" }}}

" autocomplpop.vim のように動作させる {{{
" Thanks ns9tks
" http://subtech.g.hatena.ne.jp/cho45/20071009#c1191925480
set completeopt=menuone,preview
function! CompleteWithoutInsert()
        return "\<C-n>\<C-r>=pumvisible() ? \"\\<C-P>\\<C-N>\\<C-P>\": \"\"\<CR>"
endfunction
inoremap <expr> <C-n> pumvisible() ? "\<C-n>" : CompleteWithoutInsert()
" 小文字・大文字・数字入力で常にメニューだす
let letter = "a"
while letter <=# "z"
        execute 'inoremap <expr> ' letter ' "' . letter . '" . (pumvisible() ? "" : CompleteWithoutInsert())'
        let letter = nr2char(char2nr(letter) + 1)
endwhile
let letter = "A"
while letter <=# "Z"
        execute 'inoremap <expr> ' letter ' "' . letter . '" . (pumvisible() ? "" : CompleteWithoutInsert())'
        let letter = nr2char(char2nr(letter) + 1)
endwhile
let letter = "0"
while letter <=# "9"
        execute 'inoremap <expr> ' letter ' "' . letter . '" . (pumvisible() ? "" : CompleteWithoutInsert())'
        let letter = nr2char(char2nr(letter) + 1)
endwhile
"inoremap . .<ESC>a
"inoremap ( (<ESC>a
"inoremap [ [<ESC>a
" }}}

" }}}

" カスタマイズ {{{

"0 を押すと強制終了．
map 0 :q!<Enter>

"モードライン検索行数を変更．
set modelines=10

"コマンドラインにクリップボードから貼付け．
"cnoremap <M-v>  +
cnoremap <M-v> <C-r>0

"ノーマルモードでもスペースを挿入．
nnoremap <Space> i<Space><ESC>

" ビジュアルモードでペーストするときにレジスタを更新させない．
vnoremap p "adP

" ノーマルモードで <BS> で 1 文字削除
nnoremap <BS> X

" zr⇔zR, zm⇔zM に変更
nnoremap zr zR
nnoremap zR zr
nnoremap zm zM
nnoremap zM zm

" <ESC> で IME を確実に OFF
inoremap <ESC> <ESC>:set iminsert=0<CR>:<BS>

"カーソル下から行の最後までの文字をコピー
nnoremap Y v$hy

"挿入モードでも ALT-v で貼り付ける．
inoremap <M-v> <ESC>"+pa

"純粋に 1 行上/下へ移動する．
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

"ノーマルモードでもエンターキーで改行を挿入
noremap <CR> o<ESC>

"ノーマルモードでも Ctrl-j でカーソル位置から改行
noremap <C-j> i<CR><ESC>

" <ESC> を 2 回押して検索ハイライトを消す
nnoremap <ESC><ESC> :nohlsearch<Enter>:<BS>

"Vimでコピー（ヤンク）した文字は、システムへクリップボード
set clipboard=unnamed

"検索時に検索ワードを常にセンターに持ってくる
nnoremap n nzz
nnoremap N Nzz

"勝手に自動改行するのを回避する
set formatoptions=q
set textwidth=0

"日本語の行の連結時には空白を入力しない。
set formatoptions+=mM

"折り畳み (fold) を本文の文頭に記述
cnoremap foldset <ESC>ggO{{{<Space>vim_foldmethod_setting<Enter><Enter>vim:fdm=marker<Enter><Enter>}}}<Enter><Enter>

"折り畳み (fold) maker を追加
cnoremap fdm <ESC>o{{{<Enter><Enter><Enter><Enter>}}}<Enter><Enter><ESC>kkkkkkA<Space>

"タブを常に表示
set showtabline=2
   "新しくファイルをVimで開いたときにすでに起動しているVimのウィンドウの中のタブで開くようにする
   "1 .レジストリエディタを起動
   "スタート → ファイル名を指定して実行 → 「regedit」と入力して「OK」をクリック
   "以上の手順でレジストリエディタが起動します。
   "なお、「ファイル名を指定して実行」は「Winsowsキー + R」のショートカットでも起動できます。 
   "2.編集の実行
   "レジストリエディタが起動したら /HKEY_CLASSES_ROOT/Applications/gvim.exe/shell/edit/command というようにツリーを辿っていき、値を「$VIM\gvim.exe -p -remote-tab-silent “%1″」に変更します。
   "$VIMの箇所にはVimのルートディレクトリを指定します。
   "ルートディレクトリはVimを起動後、:echo $VIMを実行すると確認できます。
   " 例えば、:echo $VIM 実行後に表示された値が「C:\Program Files\Vim」ならば、/HKEY_CLASSES_ROOT/Applications/gvim.exe/shell/edit/command の値には「C:\Program Files\Vim\gvim.exe -p -remote-tab-silent “%1″」と指定します。
   " 以上でレジストリの編集は終了です。 
   "レジストリの編集が完了したら、Vimを再起動して新しいファイルが起動中のVimのウィンドウ内のタブで開かれるか確認します。 

"ビープ音を無効
set visualbell t_vb=

"矢印キーでAとかBとか入力されるのを
"set nocompatible

"カーソル形状変更 ← 効果がなかった。。。
"let &t_ti.="\e[1 q"
"let &t_SI.="\e[5 q"
"let &t_EI.="\e[1 q"
"let &t_te.="\e[0 q"

" }}}

" 文字コードの自動認識, 改行コードの自動認識 {{{
" 文字コードの自動認識完璧版
if &encoding !=# 'utf-8'
 set encoding=japan
 set fileencoding=japan
endif
if has('iconv')
 let s:enc_euc = 'euc-jp'
 let s:enc_jis = 'iso-2022-jp'
 " iconvがeucJP-msに対応しているかをチェック
 if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
   let s:enc_euc = 'eucjp-ms'
   let s:enc_jis = 'iso-2022-jp-3'
 " iconvがJISX0213に対応しているかをチェック
 elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
   let s:enc_euc = 'euc-jisx0213'
   let s:enc_jis = 'iso-2022-jp-3'
 endif
 " fileencodingsを構築
 if &encoding ==# 'utf-8'
   let s:fileencodings_default = &fileencodings
   let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
   let &fileencodings = &fileencodings .','. s:fileencodings_default
   unlet s:fileencodings_default
 else
   let &fileencodings = &fileencodings .','. s:enc_jis
   set fileencodings+=utf-8,ucs-2le,ucs-2
   if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
     set fileencodings+=cp932
     set fileencodings-=euc-jp
     set fileencodings-=euc-jisx0213
     set fileencodings-=eucjp-ms
     let &encoding = s:enc_euc
     let &fileencoding = s:enc_euc
   else
     let &fileencodings = &fileencodings .','. s:enc_euc
   endif
 endif
 " 定数を処分
 unlet s:enc_euc
 unlet s:enc_jis
endif

" 改行コードの自動認識
set fileformats=unix,dos,mac

" }}}

" {{{ EnhancedCommentigy.vim

nmap <C-z> \x
vmap <C-z> \x

" }}}

"Vaffle設定 {{{ 

"xを押すと外部プログラム実行
autocmd FileType vaffle nmap <buffer> x :call ExecuteFileByVaffle()<CR>

function! ExecuteFileByVaffle()
    execute "normal v$h\"ay"
    execute "!start " . vaffle#buffer#extract_path_from_bufname(expand('%:p')) . '\' . substitute(@a, '^ \+', '', '')
endfunction


"vaffle上でautocdをON
let g:vaffle_auto_cd = 1

"}}}


"---------------------------------------------------------------------------
" 検索の挙動に関する設定:
"
" 検索時に大文字小文字を無視 (noignorecase:無視しない)
set ignorecase
" 大文字小文字の両方が含まれている場合は大文字小文字を区別
set smartcase

"---------------------------------------------------------------------------
" 編集に関する設定:
"
" タブの画面上での幅
"set tabstop=8
set tabstop=3
" タブをスペースに展開しない (expandtab:展開する)
set expandtab
" インデントの各段階に使われる空白の数
set shiftwidth=3
" 自動的にインデントする (noautoindent:インデントしない)
set autoindent
" バックスペースでインデントや改行を削除できるようにする
"set backspace=indent,eol,start
set backspace=2
" 検索時にファイルの最後まで行ったら最初に戻る (nowrapscan:戻らない)
set wrapscan
" 括弧入力時に対応する括弧を表示 (noshowmatch:表示しない)
set showmatch
" コマンドライン補完するときに強化されたものを使う(参照 :help wildmenu)
set wildmenu
" テキスト挿入中の自動折り返しを日本語に対応させる
set formatoptions+=mM

" 日本語整形スクリプト(by. 西岡拓洋さん)用の設定
let format_allow_over_tw = 1    " ぶら下り可能幅

" 外部のエディタで編集中のファイルが変更されたら、自動的に読み直す。ファイルが削除された場合は読み直さない。
set autoread

"カーソル行の強調表示
"set cursorline
"hi clear CursorLine "常にカーソルラインを表示するのが好きでないならば、cursorlineの色を付けないように設定

"---------------------------------------------------------------------------
" GUI固有ではない画面表示の設定:
"
" 行番号を非表示 (number:表示)
set number
" ルーラーを表示 (noruler:非表示)
set ruler
" タブや改行を表示 (list:表示)
set nolist
" どの文字でタブや改行を表示するかを設定
"set listchars=tab:>-,extends:<,trail:-,eol:<
" 長い行を折り返して表示 (nowrap:折り返さない)
set wrap
" 常にステータス行を表示 (詳細は:he laststatus)
set laststatus=2
" コマンドラインの高さ (Windows用gvim使用時はgvimrcを編集すること)
set cmdheight=2
" コマンドをステータス行に表示
set showcmd
" タイトルを表示
set title

"カーソルを行頭、行末で止まらないようにする
set whichwrap=b,s,h,l,<,>,[,]

"---------------------------------------------------------------------------
" ファイル操作に関する設定:
"
" バックアップファイルを作成しない (次行の先頭の " を削除すれば有効になる)
set nobackup
set noswapfile
set noundofile

"markerによる折りたたみ有効
set foldmethod=marker

" vim:fdm=marker
