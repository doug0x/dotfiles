"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
source ~/.vim/plug/plug.vim
call plug#begin('~/.vim/plug')
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'lervag/vimtex'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'jamestthompson3/nvim-remote-containers'
Plug 'shime/vim-livedown'
Plug 'neovimhaskell/haskell-vim'
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'eagletmt/neco-ghc'
Plug 'omnisharp/omnisharp-vim'
call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" set leader key
let g:mapleader = "\<Space>"

set hidden                              " Required to keep multiple buffers open multiple buffers
set encoding=utf-8                      " The encoding displayed
set pumheight=10                        " Makes popup menu smaller
set fileencoding=utf-8                  " The encoding written to file
set mouse=a                             " Enable your mouse
set t_Co=256                            " Support 256 colors
set conceallevel=2                      " So that I can see `` in markdown files
set tabstop=2                           " Insert 2 spaces for a tab
set shiftwidth=3                        " Change the number of space characters inserted for indentation
set expandtab                           " Converts tabs to spaces
set smartindent                         " Makes indenting smart
set laststatus=0                        " Always display the status line
set number                              " Line numbers
set cursorline                          " Track (this) line
set background=dark                     " Tell vim what the background color looks like
set showtabline=2                       " Always show tabs
set noshowmode                          " We don't need to see things like -- INSERT -- anymore
set nobackup                            " This is recommended by coc
set nowritebackup                       " This is recommended by coc
set noswapfile                          " I hate swp files
set noundofile
set updatetime=300                      " Faster completion
set timeoutlen=500                      " By default timeoutlen is 1000 ms
set formatoptions-=o                    " Stop newline continution of comments
set clipboard=unnamedplus               " Copy paste between vim and everything else
set number relativenumber               " Hybrid line number

" You can't stop me
cmap w!! w !sudo tee % 

filetype plugin indent on
syntax enable
let g:vimtex_view_method = 'zathura'
let g:vimtex_view_general_viewer = 'okular'
let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'
let g:vimtex_compiler_method = 'latexrun'
let maplocalleader = ","


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Color
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

hi Pmenu ctermfg=0 ctermbg=179 guifg=Black guibg=#d7af5f
hi DiagnosticError ctermfg=209 ctermbg=NONE guifg=NONE
hi FgCocWarningFloatBgCocFloating ctermfg=214 ctermbg=238 guifg=#ffaf00
hi FgCocErrorFloatBgCocFloating ctermfg=209 ctermbg=NONE guifg=#ff875f
hi CocMenuSel ctermbg=237 guibg=#3a3a3a
hi PmenuSbar ctermbg=240 guibg=#585858
hi PmenuThumb ctermbg=15 guibg=#ffffff
hi MatchParen ctermbg=136 
hi FoldColumn ctermfg=209 ctermbg=0 guifg=#ffaf00 guibg=#000000
hi Folded ctermfg=209 ctermbg=NONE guifg=#ffaf00 guibg=NONE
hi SignColumn ctermfg=209 ctermbg=NONE guifg=#ffaf00 guibg=NONE
hi Ignore ctermfg=15
hi CocListFgBlack ctermfg=7 guifg=#c0c0c0
hi CocFloating ctermbg=234
hi DiffAdd ctermbg=65 guibg=#5f875f ctermfg=15
hi DiffChange ctermbg=94 guibg=#875f00 ctermfg=15
hi DiffDelete ctermbg=124 guibg=#af0000 ctermfg=15 guifg=#ffffff
hi Comment ctermfg=67 guifg=#5f87af
hi CocInlayHint ctermbg=235 ctermfg=107


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Coc Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set nobackup
set nowritebackup
set updatetime=300
set signcolumn=yes
let g:coc_global_extensions_dir="~/.vim/coc-settings.json"

" Use tab for trigger completion with characters ahead and navigate.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General Mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Better nav for omnicomplete
inoremap <expr> <c-j> ("\<C-n>")
inoremap <expr> <c-k> ("\<C-p>")

" Yep, im done with >no pairs<... 
inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap {- {--}<left><left>
inoremap {# {-# -}<left><left>
inoremap {\| {-\|-}<left><left>
inoremap {; {};<left><left>

" Use alt + hjkl to resize windows
nnoremap <M-j>:resize -2<CR>
nnoremap <M-k>:resize +2<CR>
nnoremap <M-h>:vertical resize -2<CR>
nnoremap <M-l>:vertical resize +2<CR>

" Jump between pairs
vnoremap <S-q> %

" TAB in general mode will move to text buffer
nnoremap <TAB> :bnext<CR>

" SHIFT-TAB will go back
nnoremap <S-TAB> :bprevious<CR>

" Deletes the current buffer, error if there are unwritten changes
nnoremap <C-a> :bw<CR>

" Alternate way to save
nnoremap <C-s> :w<CR>

" Open Explore
nnoremap <C-q> :Ex<CR>

" Better tabbing
vnoremap < <gv
vnoremap > >gv

" Save and exec file in normal mode
autocmd FileType python map <buffer> <F3> :w<CR>:exec '!python3' shellescape(@%, 1)<CR>
autocmd FileType javascript map <buffer> <F4> :w<CR>:exec '!node' shellescape(@%, 1)<CR>
autocmd FileType sh map <buffer> <F5> :w<CR>:exec '!bash' shellescape(@%, 1)<CR>
autocmd FileType haskell map <buffer> <F6> :w<CR>:exec '!stack runghc --' shellescape(@%, 1)<CR>
