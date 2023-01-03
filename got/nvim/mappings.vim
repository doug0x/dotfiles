" Better nav for omnicomplete
inoremap <expr> <c-j> ("\<C-n>")
inoremap <expr> <c-k> ("\<C-p>")

" Yep, im done with >no pairs<... (going as faster as i can)
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

" I hate escape more than anything else
inoremap qq <Esc>

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
