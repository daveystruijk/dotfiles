
-- set undofile
-- set number
-- set signcolumn=number

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'christoomey/vim-tmux-navigator'
end)

--  Key mappings
--  map j gj
--  map k gk
--  nnoremap ; :
--  nnoremap <C-p> <cmd>Telescope find_files<CR>
--  nnoremap <C-f> <cmd>Telescope live_grep<CR>
--  nnoremap <C-n> <cmd>NvimTreeFindFileToggle<CR>
--  nnoremap <C-e> <cmd>TroubleToggle<CR>
--  nnoremap <C-c> <cmd>noh<CR>
--  nnoremap <S-Tab> <cmd>BufferLineCyclePrev<CR>
--  nnoremap <Tab> <cmd>BufferLineCycleNext<CR>
-- 
--  Leader mappings
--  let mapleader = ","
--  nnoremap <leader>r :source $MYVIMRC<CR>
--  nnoremap <leader>p :PackerSync<CR>
--  nnoremap <leader>f :Format<CR>
--  vnoremap <leader>c "+y
--  nnoremap <leader>v "+p
