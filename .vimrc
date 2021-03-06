" Modeline and Notes {
" vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={,} foldlevel=0 foldmethod=marker spell:
" }

" Environment {

    " Identify platform {
        silent function! OSX()
            return has('macunix')
        endfunction
        silent function! LINUX()
            return has('unix') && !has('macunix') && !has('win32unix')
        endfunction
        silent function! WINDOWS()
            return  (has('win32') || has('win64'))
        endfunction
    " }

    " Basics {
        set nocompatible        " Must be first line
        if !WINDOWS()
            set shell=/bin/bash
        endif
    " }

    " Windows Compatible {
        " On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
        " across (heterogeneous) systems easier.
        if WINDOWS()
          set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
        endif
    " }
" }

" Use before config if available {

        " Use bundles config {
        if filereadable(expand("~/.vimrc.bundles"))
            source ~/.vimrc.bundles
        endif
" }

" General {
        set background=light         " Assume a dark background

        " Allow to trigger background
        function! ToggleBG()
            let s:tbg = &background
            " Inversion
            if s:tbg == "dark"
                set background=light
            else
                set background=dark
            endif
        endfunction
        noremap <leader>bg :call ToggleBG()<CR>

        syntax on                   " Syntax highlighting
        set mouse=a                 " Automatically enable mouse usage
        set mousehide               " Hide the mouse cursor while typing

        if has('clipboard')
            if has('unnamedplus')  " When possible use + register for copy-paste
                set clipboard=unnamed,unnamedplus
            else         " On mac and Windows, use * register for copy-paste
                set clipboard=unnamed
            endif
        endif

        set autowrite                       " Automatically write a file when leaving a modified buffer
        set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
        set virtualedit=onemore             " Allow for cursor beyond last character
        set history=100                     " Store a ton of history (default is 20)
        set hidden                          " Allow buffer switching without saving

        " http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
        " Restore cursor to file position in previous editing session
        " To disable this, add the following to your .vimrc.before.local file:
        function! ResCur()
            if line("'\"") <= line("$")
                silent! normal! g`"
                return 1
            endif
        endfunction

        augroup resCur
            autocmd!
            autocmd BufWinEnter * call ResCur()
        augroup END

        " Setting up the directories {
        set backup                  " Backups are nice ...
        if has('persistent_undo')
            set undofile               " So is persistent undo ...
            set undolevels=100         " Maximum number of changes that can be undone
            set undoreload=1000        " Maximum number lines to save for undo on a buffer reload
        endif

        " Add exclusions to mkview and loadview
        " eg: *.*, svn-commit.tmp
        let g:skipview_files = [
            \ '\[example pattern\]'
            \ ]
" }

" Vim UI {
        if  filereadable(expand("~/.vim/bundle/vim-hybrid/colors/hybrid.vim"))
            colorscheme hybrid              " Load a colorscheme
        endif

        set showcmd                 " Show partial commands in status line and
        set noshowmode                  " Hidden the current mode
        set cursorline                  " Highlight current line

        highlight clear SignColumn      " SignColumn should match background
        highlight clear LineNr          " Current line number row will have same background color in relative mode

        set backspace=indent,eol,start  " Backspace for dummies
        set linespace=0                 " No extra spaces between rows
        set number                      " Line numbers on
        set showmatch                   " Show matching brackets/parenthesis
        set incsearch                   " Find as you type search
        set hlsearch                    " Highlight search terms
        set ignorecase                  " Case insensitive search
        set smartcase                   " Case sensitive when uc present
        set wildmenu                    " Show list instead of just completing
        set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
        set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
        set scrolljump=5                " Lines to scroll when cursor leaves screen
        set scrolloff=3                 " Minimum lines to keep above and below cursor
        set foldenable                  " Auto fold code
        set list
        set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace
" }

" Formatting {

        set nowrap                      " Do not wrap long lines
        set autoindent                  " Indent at the same level of the previous line
        set shiftwidth=4                " Use indents of 4 spaces
        set expandtab                   " Tabs are spaces, not tabs
        set tabstop=4                   " An indentation every four columns
        set softtabstop=4               " Let backspace delete indent
        set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
        set splitright                  " Puts new vsplit windows to the right of the current
        set splitbelow                  " Puts new split windows to the bottom of the current
        set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)
        autocmd FileType c,cpp,javascript,python,xml,sql autocmd BufWritePre <buffer> call StripTrailingWhitespace()
" }

" Key (re)Mappings {

        " The default mappings for editing and applying the spf13 configuration
        " are <leader>ev and <leader>sv respectively. Change them to your preference
        " by adding the following to your .vimrc.before.local file:
        "   let g:spf13_edit_config_mapping='<leader>ec'
        "   let g:spf13_apply_config_mapping='<leader>sc'
        let s:spf13_edit_config_mapping = '<leader>ev'
        let s:spf13_apply_config_mapping = '<leader>sv'

        " Code folding options
        nmap <leader>f0 :set foldlevel=0<CR>
        nmap <leader>f1 :set foldlevel=1<CR>
        nmap <leader>f2 :set foldlevel=2<CR>
        nmap <leader>f3 :set foldlevel=3<CR>
        nmap <leader>f4 :set foldlevel=4<CR>
        nmap <leader>f5 :set foldlevel=5<CR>
        nmap <leader>f6 :set foldlevel=6<CR>
        nmap <leader>f7 :set foldlevel=7<CR>
        nmap <leader>f8 :set foldlevel=8<CR>
        nmap <leader>f9 :set foldlevel=9<CR>

        " Most prefer to toggle search highlighting rather than clear the current
        " search results. To clear search highlighting rather than toggle it on
        " and off
        nmap <silent> <leader>/ :set invhlsearch<CR>

        " FIXME: Revert this f70be548
        " fullscreen mode for GVIM and Terminal, need 'wmctrl' in you PATH
        map <silent> <F11> :call system("wmctrl -ir " . v:windowid . " -b toggle,fullscreen")<CR>
" }

" Plugins {
    " LeaderF {
            if isdirectory(expand("~/.vim/bundle/LeaderF/"))
                let g:Lf_StlSeparator = { 'left': '', 'right': '', 'font': '' }

                let g:Lf_RootMarkers = ['.project', '.root', '.svn', '.git']
                let g:Lf_WorkingDirectoryMode = 'Ac'
                let g:Lf_WindowHeight = 0.30
                let g:Lf_CacheDirectory = expand('~/.cache')
                let g:Lf_ShowRelativePath = 0
                let g:Lf_HideHelp = 1
                let g:Lf_StlColorscheme = 'powerline'
                let g:Lf_PreviewResult = {'Function':0, 'BufTag':0}

                let g:Lf_ShortcutF = '<leader>p'
                noremap <leader>m :LeaderfMru<cr>
                noremap <leader>f :LeaderfFunction!<cr>
                noremap <leader>b :LeaderfBuffer<cr>
                noremap <leader>t :LeaderfTag<cr>

            endif
       "}

    " w0rp/ale {
        if isdirectory(expand("~/.vim/bundle/ale"))
            " 对应语言需要安装相应的检查工具
            " https://github.com/w0rp/ale
            let g:ale_linters_explicit = 1 "除g:ale_linters指定，其他不可用
            let g:ale_linters = {
            \   'cpp': ['cppcheck'],
            \   'c': ['cppcheck'],
            \   'python': ['flake8'],
            \   'bash': ['shellcheck'],
            \}
            let g:ale_fixers = {
            \   'cpp': ['clang-format'],
            \   'c': ['clang-format'],
            \   'python': ['autopep8'],
            \}

            let g:ale_sign_column_always = 1
            let g:ale_echo_delay = 20
            let g:ale_lint_delay = 500
            let g:ale_echo_msg_format = '[%linter%] %code: %%s'
            let g:ale_lint_on_text_changed = 'normal'
            let g:ale_lint_on_insert_leave = 1
            let g:airline#extensions#ale#enabled = 1
			
            let g:ale_sign_error = ">>"
            let g:ale_sign_warning = "!"

            map <F7> ::ALEToggle<CR>
            " Bind F8 to fixing problems with ALE
            nmap <F8> <Plug>(ale_fix)
        endif
    " }

    " vim-gutentags {
        if isdirectory(expand("~/.vim/bundle/vim-gutentags"))
            "keymap	    desc
            "<leader>cs	Find symbol (reference) under cursor
            "<leader>cg	Find symbol definition under cursor
            "<leader>cd	Functions called by this function
            "<leader>cc	Functions calling this function
            "<leader>ct	Find text string under cursor
            "<leader>ce	Find egrep pattern under cursor
            "<leader>cf	Find file name under cursor
            "<leader>ci	Find files #including the file name under cursor
            "<leader>ca	Find places where current symbol is assigned

            let g:gutentags_define_advanced_commands = 1
            "自动载入ctags gtags
            "let $GTAGSLABEL = 'native-pygments'
            let $GTAGSLABEL = 'native'
            let $GTAGSCONF = '/usr/local/share/gtags/gtags.conf'

            " gutentags 搜索工程目录的标志，当前文件路径向上递归直到碰到这些文件/目录名
            let g:gutentags_project_root = ['.root', '.svn', '.git', '.project']

            " 所生成的数据文件的名称
            let g:gutentags_ctags_tagfile = '.tags'

            " 同时开启 ctags 和 gtags 支持：
            let g:gutentags_modules = []
            if executable('ctags')
                let g:gutentags_modules += ['ctags']
                set tags=./.tags;,.tags  "set tags=./tags;/,~/.vimtags
            endif
            
            if executable('gtags-cscope') && executable('gtags')
                let g:gutentags_modules += ['gtags_cscope']
            endif

            " 将自动生成的 ctags/gtags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录
            let g:gutentags_cache_dir = expand('~/.cache/tags')

            " 配置 ctags 的参数
            let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
            let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
            let g:gutentags_ctags_extra_args += ['--c-kinds=+px']

            " 如果使用 universal ctags 需要增加下面一行
            let g:gutentags_ctags_extra_args += ['--output-format=e-ctags']

            " 禁用 gutentags 自动加载 gtags 数据库的行为,避免多个项目数据库相互干扰
            let g:gutentags_auto_add_gtags_cscope = 0

            "预览 quickfix 窗口 ctrl-w z 关闭
            "P 预览 大p关闭
            autocmd FileType qf nnoremap <silent><buffer> p :PreviewQuickfix<cr>
            autocmd FileType qf nnoremap <silent><buffer> P :PreviewClose<cr>
            noremap <leader>u :PreviewScroll -1<cr>  " 往上滚动预览窗口
            noremap <leader>d :PreviewScroll +1<cr>  " 往下滚动预览窗口
        endif
    " }

    " NerdTree {
        if isdirectory(expand("~/.vim/bundle/nerdtree"))

            let g:nerdtree_tabs_open_on_gui_startup=0
            let g:NERDShutUp=1
            let NERDTreeShowBookmarks=1
            let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
            let NERDTreeChDirMode=0
            let NERDTreeQuitOnOpen=1
            let NERDTreeMouseMode=2
            let NERDTreeShowHidden=1
            let NERDTreeKeepTreeInNewTab=1

            map <C-e> <plug>NERDTreeTabsToggle<CR>
            map <leader>e :NERDTreeFind<CR>
        endif
    " }

    " Tabularize {
        if isdirectory(expand("~/.vim/bundle/tabular"))
            nmap <leader>a& :Tabularize /&<CR>
            vmap <leader>a& :Tabularize /&<CR>
            nmap <leader>a= :Tabularize /^[^=]*\zs=<CR>
            vmap <leader>a= :Tabularize /^[^=]*\zs=<CR>
            nmap <leader>a=> :Tabularize /=><CR>
            vmap <leader>a=> :Tabularize /=><CR>
            nmap <leader>a: :Tabularize /:<CR>
            vmap <leader>a: :Tabularize /:<CR>
            nmap <leader>a:: :Tabularize /:\zs<CR>
            vmap <leader>a:: :Tabularize /:\zs<CR>
            nmap <leader>a, :Tabularize /,<CR>
            vmap <leader>a, :Tabularize /,<CR>
            nmap <leader>a,, :Tabularize /,\zs<CR>
            vmap <leader>a,, :Tabularize /,\zs<CR>
            nmap <leader>a<Bar> :Tabularize /<Bar><CR>
            vmap <leader>a<Bar> :Tabularize /<Bar><CR>
        endif
    " }

    " YouCompleteMe {
        if count(g:spf13_bundle_groups, 'youcompleteme')
            let g:acp_enableAtStartup = 0
            " 关闭加载配置文件提示
            let g:ycm_confirm_extra_conf=0
            " enable completion from tags
            let g:ycm_collect_identifiers_from_tags_files = 1
            let g:ycm_global_ycm_extra_conf = '~/.OmVim/ycm_conf/c++_standard/.ycm_extra_conf.py'
            "设置全局Python路径
            let g:ycm_server_python_interpreter='/usr/bin/python3'
            " remap Ultisnips for compatibility for YCM
            let g:UltiSnipsExpandTrigger = '<C-m-j>'
            let g:UltiSnipsJumpForwardTrigger = '<C-j>'
            let g:UltiSnipsJumpBackwardTrigger = '<C-k>'

            " Enable omni completion.
            autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
            autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
            autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
            autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
            autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

            " For snippet_complete marker.
            if !exists("g:spf13_no_conceal")
                if has('conceal')
                    set conceallevel=2 concealcursor=i
                endif
            endif

            " Disable the neosnippet preview candidate window
            " When enabled, there can be too much visual noise
            " especially when splits are used.
            set completeopt-=preview
        endif
    " }

    " UndoTree {
        if isdirectory(expand("~/.vim/bundle/undotree/"))
            nnoremap <leader>u :UndotreeToggle<CR>
            " If undotree is opened, it is likely one wants to interact with it.
            let g:undotree_SetFocusWhenToggle=1
        endif
    " }

    " indent_guides {
        if isdirectory(expand("~/.vim/bundle/vim-indent-guides/"))
            let g:indent_guides_start_level = 2
            let g:indent_guides_guide_size = 1
            let g:indent_guides_enable_on_vim_startup = 1
        endif
    " }
" }

" GUI Settings {

    " GVIM- (here instead of .gvimrc)
    if has('gui_running')
        set guioptions-=T           " Remove the toolbar
        set lines=40                " 40 lines of text instead of 24
        if !exists("g:spf13_no_big_font")
            if LINUX()
                set guifont=Andale\ Mono\ Regular\ 12,Menlo\ Regular\ 11,Consolas\ Regular\ 12,Courier\ New\ Regular\ 14
            elseif OSX()
                set guifont=Andale\ Mono\ Regular:h12,Menlo\ Regular:h11,Consolas\ Regular:h12,Courier\ New\ Regular:h14
            elseif WINDOWS()
                set guifont=Andale_Mono:h10,Menlo:h10,Consolas:h10,Courier_New:h10
            endif
        endif
    else
        if &term == 'xterm' || &term == 'screen'
            set t_Co=256            " Enable 256 colors to stop the CSApprox warning and make xterm vim shine
        endif
        "set term=builtin_ansi       " Make arrow and other keys work
    endif

" }

" Functions {

    " Initialize directories {
    function! InitializeDirectories()
        let parent = $HOME
        let prefix = 'vim'
        let dir_list = {
                    \ 'backup': 'backupdir',
                    \ 'views': 'viewdir',
                    \ 'swap': 'directory' }

        if has('persistent_undo')
            let dir_list['undo'] = 'undodir'
        endif

        " To specify a different directory in which to place the vimbackup,
        " vimviews, vimundo, and vimswap files/directories, add the following to
        " your .vimrc.before.local file:
        "   let g:spf13_consolidated_directory = <full path to desired directory>
        "   eg: let g:spf13_consolidated_directory = $HOME . '/.vim/'
        if exists('g:spf13_consolidated_directory')
            let common_dir = g:spf13_consolidated_directory . prefix
        else
            let common_dir = parent . '/.' . prefix
        endif

        for [dirname, settingname] in items(dir_list)
            let directory = common_dir . dirname . '/'
            if exists("*mkdir")
                if !isdirectory(directory)
                    call mkdir(directory)
                endif
            endif
            if !isdirectory(directory)
                echo "Warning: Unable to create backup directory: " . directory
                echo "Try: mkdir -p " . directory
            else
                let directory = substitute(directory, " ", "\\\\ ", "g")
                exec "set " . settingname . "=" . directory
            endif
        endfor
    endfunction
    call InitializeDirectories()
    " }

    " Initialize NERDTree as needed {
    function! NERDTreeInitAsNeeded()
        redir => bufoutput
        buffers!
        redir END
        let idx = stridx(bufoutput, "NERD_tree")
        if idx > -1
            NERDTreeMirror
            NERDTreeFind
            wincmd l
        endif
    endfunction
    " }

    " Strip whitespace {
    function! StripTrailingWhitespace()
        " Preparation: save last search, and cursor position.
        let _s=@/
        let l = line(".")
        let c = col(".")
        " do the business:
        %s/\s\+$//e
        " clean up: restore previous search history, and cursor position
        let @/=_s
        call cursor(l, c)
    endfunction
    " }

    function! s:ExpandFilenameAndExecute(command, file)
        execute a:command . " " . expand(a:file, ":p")
    endfunction
     
    function! s:EditSpf13Config()
        call <SID>ExpandFilenameAndExecute("tabedit", "~/.vimrc")
        call <SID>ExpandFilenameAndExecute("vsplit", "~/.vimrc.bundles")
     
        execute bufwinnr("~/.vimrc") . "wincmd w"

    endfunction
     
    execute "noremap " . s:spf13_edit_config_mapping " :call <SID>EditSpf13Config()<CR>"
    execute "noremap " . s:spf13_apply_config_mapping . " :source ~/.vimrc<CR>"
" }

