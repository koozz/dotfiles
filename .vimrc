" Bootstrap vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Configure plugins
let g:ale_disable_lsp = 1
let g:ale_sign_column_always = 1
let g:seoul256_background = 236

" Setup plugins
call plug#begin('~/.vim/plugged')
Plug 'dense-analysis/ale'
Plug 'editorconfig/editorconfig-vim'
if executable('go')
  Plug 'fatih/vim-go', { 'for': 'golang', 'do': ':GoUpdateBinaries' }
endif
Plug 'hashivim/vim-terraform', { 'for': 'terraform' }
Plug 'itchyny/lightline.vim'
Plug 'junegunn/goyo.vim', { 'for': 'markdown' }
if !executable('fzf')
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
endif
Plug 'junegunn/fzf.vim'
Plug 'junegunn/seoul256.vim'
Plug 'junegunn/vim-peekaboo'
Plug 'pearofducks/ansible-vim', { 'for': 'yaml.ansible' }
Plug 'tpope/vim-fugitive'
Plug 'tsandall/vim-rego'

if executable('yarn')
  Plug 'prettier/vim-prettier', { 'do': 'yarn install' }

  let cocplugins = [':CocInstall']
  let cocplugins = add(cocplugins, 'coc-css')
  let cocplugins = add(cocplugins, 'coc-eslint')
  let cocplugins = add(cocplugins, 'coc-fzf-preview')
  let cocplugins = add(cocplugins, 'coc-git')
  let cocplugins = add(cocplugins, 'coc-go')
  let cocplugins = add(cocplugins, 'coc-highlight')
  let cocplugins = add(cocplugins, 'coc-html')
  let cocplugins = add(cocplugins, 'coc-html-css-support')
  let cocplugins = add(cocplugins, 'coc-java')
  let cocplugins = add(cocplugins, 'coc-json')
  let cocplugins = add(cocplugins, 'coc-lists')
  let cocplugins = add(cocplugins, 'coc-markdownlint')
  let cocplugins = add(cocplugins, 'coc-pyright')
  let cocplugins = add(cocplugins, 'coc-rust-analyzer')
  let cocplugins = add(cocplugins, 'coc-sh')
  let cocplugins = add(cocplugins, 'coc-spell-checker')
  let cocplugins = add(cocplugins, 'coc-sql')
  let cocplugins = add(cocplugins, 'coc-svg')
  let cocplugins = add(cocplugins, 'coc-toml')
  let cocplugins = add(cocplugins, 'coc-tsserver')
  let cocplugins = add(cocplugins, 'coc-vimlsp')
  let cocplugins = add(cocplugins, 'coc-xml')
  let cocplugins = add(cocplugins, 'coc-yaml')
  let cocplugins = add(cocplugins, 'coc-yank')

  Plug 'neoclide/coc.nvim', {'branch': 'release', 'do': join(cocplugins, ' ')}

  " Symbol renaming.
  nmap <F2> <Plug>(coc-rename)

  " Code navigation.
  nmap <silent> cd <Plug>(coc-definition)
  nmap <silent> cy <Plug>(coc-type-definition)
  nmap <silent> ci <Plug>(coc-implementation)
  nmap <silent> cr <Plug>(coc-references)

  " Apply AutoFix to problem on the current line.
  nmap <leader>qf <Plug>(coc-fix-current)

  " Formatting selected code.
  xmap <leader>cf <Plug>(coc-format-selected)
  nmap <leader>cf <Plug>(coc-format-selected)

  " Tab completion
  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
  endfunction
  inoremap <silent><expr> <Tab>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<Tab>" :
        \ coc#refresh()
endif
call plug#end()

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
      \| PlugInstall --sync | source $MYVIMRC
      \| endif

" editorconfig settings
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

" grep settings
if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case\ --follow
  set grepformat=%f:%l:%c:%m
elseif executable('fd')
  set grepprg=fd\ --type\ f\ --hidden\ --exclude\ .git\ --exclude\ venv\ --exclude\ go/pkg
endif

" Global settings
set nocompatible
filetype plugin on
syntax enable
"set background=dark
colorscheme seoul256
set number relativenumber
set noswapfile
set smartindent tabstop=2 shiftwidth=2
set backspace=indent,eol,start
set list listchars=tab:\|\ ,trail:·
set clipboard=unnamedplus

" Highlight all search results and extra whitespaces
set hlsearch
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$\| \+\ze\t/
" hi clear SpellBad              " Clear any unwanted default settings
" hi SpellBad cterm=underline    " Set the spell checking highlight style
" hi SpellBad ctermbg=NONE       " Set the spell checking highlight background

" Do case insensitive search and show incremental search results as you type
set ignorecase
set incsearch

" Leader default=backslash
nnoremap <leader>a ggVG
vnoremap <leader>c "+y
vnoremap <leader>x "+d
inoremap <leader>v <ESC>"+pa
nnoremap <leader>= gg=G''
nnoremap <leader>ip :read ! curl -sL https://icanhazip.com<CR>
nnoremap <leader>f :Files<CR>
nnoremap <leader>g :GFiles<CR>
nnoremap <leader>s :w<CR>
nnoremap <leader>w :bwipeout<CR>
nnoremap <leader>` :shell<CR>

" Easy window movement
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" More ale!
"call ale#Set('ansible_ansible_lint_executable', 'ansible-lint'
"call ale#Set('dockerfile_dockerfile_lint_executable', 'dockerfile_lint')
"
let g:ale_fix_on_save = 1
let g:ale_fixers = {
      \   '*': ['trim_whitespace'],
      \   'elm': ['elm-format'],
      \   'go': ['gofmt'],
      \   'html': ['html-beautify'],
      \   'javascript': ['eslint'],
      \   'json': ['jsonlint'],
      \   'nix': ['nixfmt'],
      \   'rust': ['rustfmt'],
      \   'sh': ['shellcheck', 'shfmt'],
      \   'terraform': ['terraform'],
      \   'yaml': ['yamlfix'],
      \}

" Default run
nmap <leader>r :!%:p<CR>

" File options
au BufRead,BufNewFile *.md setlocal textwidth=80
au BufRead kubeconfig set filetype=yaml
au BufRead ~/.kube/config set filetype=yaml

" File-type settings
au FileType yaml set sw=2
au FileType yaml set expandtab
au FileType html set sw=2
au FileType js set sw=2
au FileType python set nocindent
au FileType python map <leader>r :w<CR>:!python %<CR>
au FileType rego map <leader>r :w<CR>:!opa check %<CR>

" vim:et:ft=vim:fdm=marker:sts=2:sw=2:ts=2
