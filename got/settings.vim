" set leader key
let g:mapleader = "\<Space>"
 
set hidden                              " Required to keep multiple buffers open multiple buffers
set encoding=utf-8                      " The encoding displayed
set pumheight=10                        " Makes popup menu smaller
set fileencoding=utf-8                  " The encoding written to file
set mouse=a                             " Enable your mouse
set t_Co=256                            " Support 256 colors
set conceallevel=0                      " So that I can see `` in markdown files
set tabstop=2                           " Insert 2 spaces for a tab
set shiftwidth=3                        " Change the number of space characters inserted for indentation
set smarttab                            " Makes tabbing smarter will realize you have 2 vs 4
set expandtab                           " Converts tabs to spaces
set smartindent                         " Makes indenting smart
set laststatus=0                        " Always display the status line
set number                              " Line numbers
set cursorline

""" Color corrections
hi Pmenu ctermfg=0 ctermbg=179 guifg=Black guibg=#fca103
hi DiagnosticError ctermfg=209 ctermbg=NONE guifg=NONE
hi FgCocWarningFloatBgCocFloating ctermfg=214 ctermbg=238 guifg=#ffaf00
hi FgCocErrorFloatBgCocFloating ctermfg=209 ctermbg=NONE guifg=#ff875f
hi CocMenuSel ctermbg=237 guibg=NONE
hi PmenuSbar ctermbg=240 guibg=#444444
hi PmenuThumb ctermbg=15 guibg=#444444
hi FoldColumn ctermfg=209 ctermbg=0 guifg=#ffaf00 guibg=#000000
hi Folded ctermfg=209 ctermbg=NONE guifg=#ffaf00 guibg=NONE
hi SignColumn ctermfg=209 ctermbg=NONE guifg=#ffaf00 guibg=NONE
hi Ignore ctermfg=15
hi CocListFgBlack ctermfg=7 guifg=#c0c0c0
hi CocFloating ctermbg=235

set background=dark                      " tell vim what the background color looks like
set showtabline=2                       " Always show tabs
set noshowmode                          " We don't need to see things like -- INSERT -- anymore
set nobackup                            " This is recommended by coc
set nowritebackup                       " This is recommended by coc
set updatetime=300                      " Faster completion
set timeoutlen=500                      " By default timeoutlen is 1000 ms
set formatoptions-=cro                  " Stop newline continution of comments
set clipboard=unnamedplus               " Copy paste between vim and everything else
"set autochdir                           " Your working directory will always be the same as your working directory
 
au! BufWritePost $MYVIMRC source %      " auto source when writing to init.vim alternatively you can run :source $MYVIMRC
 
" You can't stop me
cmap w!! w !sudo tee %
