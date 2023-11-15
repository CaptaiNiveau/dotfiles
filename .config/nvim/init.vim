lua require('plugins')
lua require('pluginconfig')

" save undo trees in files
set undofile
set undodir=~/.nvim/undo

" proper clipboard integration
set clipboard+=unnamedplus

" number of undo saved
set undolevels=10000 

" open files in the background using xdg-open 
nnoremap gX :silent :execute
            \ "!xdg-open" expand('%:p:h') . "/" . expand("<cfile>") " &"<cr>
